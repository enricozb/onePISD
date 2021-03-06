//
//  Session.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Alamofire
import UIKit

/* ----- TODO ------
	possibly remove View attachment, not sure how loading/activity would work...
		-	possibly use a view instance. Would have to change when views are changed...

	add storage mechanism for other fields 
		*	grades
		*	studentId
		_	Tickets?
		
	error handling (no connection, wrong password, etc)
		*	wrong password
		*	no internet connection
		_	PISD problems (timeout)
	
	add functions
		*	daily/major grade grabber for each six weeks

	rewrite for clarity, and convention
		*	make studentId an instance variable of session, not of grade
		-	remove getter functions.
		-	flip storing structure, store by class.
*/

/* ----- Public Functions -----
	login			- () used with a trailing closure to attempt to login. completionHandler consists of (NSHTTPURLResponse, String, SessionError?)
	courses			- () returns grades [Course]?
	studentId		- () returns studentId
	setCredentials	- (username: String, password: String) is obvious.
*/

public struct MainSession {
	static let session: Session = Session()
}

enum SessionError {
	case wrongCredentials
	case timeout
	case noInternetConnection
	case success
}

class Session {
	
	private let url_login =
		"https://sso.portal.mypisd.net/cas/login?"
	private let url_user =
		"https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	private let url_grades =
		"https://parentviewer.pisd.edu/EP/PIV_Passthrough.aspx"
	private let url_pinnacle =
		"https://gradebook.pisd.edu/Pinnacle/Gradebook/link.aspx?target=InternetViewer"
	private let url_gradesummary =
		"https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/GradeSummary.aspx"
	private let url_gradeassignments =
		"https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/StudentAssignments.aspx?"
	private let url_attendancesummary =
		"https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/AttendanceSummary.aspx?"
	private let url_weststaff =
		"http://www.pisd.edu/schools/secondary/pwsh/staff.shtml"
	private let url_eaststaff =
		"http://www.pisd.edu/schools/secondary/pesh/staff.shtml"
	
	
	private var username: String
	private var password: String
	
	private let manager: Alamofire.Manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	
	private var studentId: Int?
	
	private var grade_form: [String: String]?
	private var pinnacle_form: [String: String]?
	private var course_list: [Course]?
	private var sixweek_list: [SixWeek]?
	private var faculty: ([FacultyEntry], [FacultyEntry])?
	
	init(username: String, password: String) {
		self.username = username
		self.password = password
	}
	
	init() {
		self.username = ""
		self.password = ""
	}
	
	/**
		Sets the credentials (username and password) of the current session
	
		:param: username The username for the Session
		:param: password The password for the Session
	*/
	func setCredentials(#username: String, password: String) {
		self.username = username
		self.password = password
	}

	/**
		Attempts to login and grab all grades in one go. If successful, grades() will return a [Course]?
		Use with a trailing closure with parameters (NSHTTPURLResponse, String, SessionError?)
	*/
	func login(completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Loading PISD")
		self.startBackgroundFacultyLoading()
		self.manager.request(.GET, url_login).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, error) in
			if error?.code == -1009 {
				completionHandler(response, html_data!, SessionError.noInternetConnection)
			}
			else {
				self.loginWithParams(html_data!) { (response, data, error) in
					completionHandler(response, data, error)
					self.startBackgroundAssignmentLoading()
				}
			}
		}
	}
	
	func loadAssignmentsForGrade(grade: Grade, completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		if grade.assignments != nil {
			completionHandler(nil, "", SessionError.success)
			return
		}
		let params = [
			"EnrollmentId"	: "\(grade.course!.enrollmentID)",
			"TermId"		: "\(grade.termID)",
			"StudentId"		: "\(studentId!)",
			"H"				: "G"	//No idea what this is, but it's in the form
		]
		let url = "\(url_gradeassignments) "
		View.showWaitOverlayWithText("Loading Assignments")
		self.manager.request(.GET, url_gradeassignments, parameters: params).responseString(encoding: NSUTF8StringEncoding) {
			(request, response, html_data, error) in
			
			let assignments = Parser.getAssignmentsFromHTML(html_data!)
			grade.assignments = assignments
			completionHandler(response, html_data!, nil)
		}
	}
	
	func loadAttendanceSummary(completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		self.manager.request(.GET, url_attendancesummary).responseString(encoding: NSUTF8StringEncoding) { (request, response, html_data, error) in
			println(html_data!)
			let (viewstate, eventvalidation, pageuniqueid) = Parser.getAttendanceCredentials(html_data!)
		}
	}
	
	func loadFaculty(completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		self.manager.request(.GET, url_weststaff).responseString(encoding: NSUTF8StringEncoding) {
			(request, response, html_data, error) in
			self.faculty = Parser.getFacultyFromHTML(html_data!)
			completionHandler(response, html_data!, SessionError.success)
		}
	}
	
	// MARK: Getter Functions (remove)
	
	func courses() -> [Course]? {
		return course_list
	}
	
	func studentID() -> Int? {
		return studentId
	}
	
	func sixWeeks() -> [SixWeek]? {
		if sixweek_list != nil {
			return sixweek_list
		}
		var sixWeeks = SixWeek.template()
		if let courses = course_list {
			for course in courses {
				for grade in course.grades {
					sixWeeks[grade.index].addGrade(grade)
				}
			}
		}
		sixweek_list = sixWeeks
		return sixWeeks
	}
	
	func facultyData() -> ([FacultyEntry], [FacultyEntry]) {
		return faculty!
	}
	
	// MARK: Private class methods
	
	private func loginWithParams(html: String, completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Logging in")
		let lt = Parser.getLTfromHTML(html)
		
		let params = [
			"username" : self.username,
			"password" : self.password,
			"warn" : "false",
			"lt" : lt,
			"_eventId" : "submit",
			"reset" : "CLEAR",
			"submit": "LOGIN"
		]
		
		self.manager.request(.POST, url_login, parameters: params).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, error) in
			
			//PARSE RESPONSE HERE; CHECK FOR WRONG PASSWORD (~11 elements = correct password, ~10 elements = incorrect password)
			//OR CHECK FOR nil on "Set-Cookie" in response <- much better
			
			View.showWaitOverlayWithText("Grabbing Cookies")
			let responseDict = response!.allHeaderFields as! [String: String]
			
			if responseDict["Set-Cookie"] == nil {
				View.clearOverlays()
				completionHandler(response!, html_data!, SessionError.wrongCredentials)
			}
			else {
				self.loadMainPage(completionHandler)
			}
		}
	}
	
	private func loadMainPage(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Refreshing")
		self.manager.request(.GET, url_user).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, _) in
			let url_redirect = Parser.getRedirectfromHTML(html_data!)
			self.grabGradeFormWithURL(url_redirect, completionHandler)
		}
	}
	
	private func grabGradeFormWithURL(url: String, _ completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Gradebook form")
		println("\tfrom url \(url)")
		self.manager.request(.GET, url).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, error) in
			if response?.statusCode == 504 {
				View.showTextOverlay("PISD is down", clearAfter: 5)
			} else {
				self.grade_form = Parser.getGradeFormFromHTML(html_data!)
				self.submitGradeForm(completionHandler)
			}
		}
	}
	
	private func submitGradeForm(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Submitting Gradebook form")
		self.manager.request(.GET, url_grades, parameters: grade_form!).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, _) in
			self.pinnacle_form = Parser.getPinnacleFormFromHTML(html_data!)
			self.loadMainGradePage(completionHandler)
		}
	}
	
	private func loadMainGradePage(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Loading Gradebook")
		self.manager.request(.POST, url_pinnacle, parameters: pinnacle_form!).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, _) in
			self.setSemesterGrades(completionHandler)
		}
	}
	
	private func setSemesterGrades(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Semester Grades")
		self.manager.request(.GET, url_gradesummary).responseString(encoding: NSUTF8StringEncoding) { (_, response, html_data, _) in
			let (courses, studentId) = Parser.getReportTableFromHTML(html_data!)
			self.course_list = courses
			self.studentId = studentId
			completionHandler(response!, html_data!, nil)
		}
	}
	
	private func startBackgroundAssignmentLoading() {
		var percent: Double = 0.0
		if sixweek_list == nil {
			sixweek_list = sixWeeks()
		}
		for sixweek in sixweek_list!.reverse() {
			for grade in sixweek.grades {
				loadAssignmentsForGradeNoOverlay(grade) { (_, _, _) in
					percent += Double(1.0/Double(grade.course!.grades.count))/Double(self.course_list!.count)
					View.showLoadingOverlay(percent)
				}
			}
		}
	}
	
	private func loadAssignmentsForGradeNoOverlay(grade: Grade, completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		if grade.assignments != nil {
			completionHandler(nil, "", SessionError.success)
			return
		}
		let params = [
			"EnrollmentId"	: "\(grade.course!.enrollmentID)",
			"TermId"		: "\(grade.termID)",
			"StudentId"		: "\(studentId!)",
			"H"				: "G"	//No idea what this is, but it's in the form
		]
		let url = "\(url_gradeassignments) "
		self.manager.request(.GET, url_gradeassignments, parameters: params).responseString(encoding: NSUTF8StringEncoding) {
			(request, response, html_data, error) in
			let assignments = Parser.getAssignmentsFromHTML(html_data!)
			grade.assignments = assignments
			completionHandler(response, html_data!, nil)
		}
	}
	
	private func startBackgroundFacultyLoading() {
		self.loadFaculty() { (_, _, _) in
			println("FACULTY LOADED")
		}
	}
}