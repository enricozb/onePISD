//
//  Session.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
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
}

class Session {
	
	private let url_login = "https://sso.portal.mypisd.net/cas/login?"
	private let url_user = "https://sso.portal.mypisd.net/cas/login?service=http%3A%2F%2Fportal.mypisd.net%2Fc%2Fportal%2Flogin"
	private let url_grades = "https://parentviewer.pisd.edu/EP/PIV_Passthrough.aspx"
	private let url_pinnacle = "https://gradebook.pisd.edu/Pinnacle/Gradebook/link.aspx?target=InternetViewer"
	private let url_gradesummary = "https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/GradeSummary.aspx"
	private let url_gradeassignments = "https://gradebook.pisd.edu/Pinnacle/Gradebook/InternetViewer/StudentAssignments.aspx?"
	
	private var username: String
	private var password: String
	
	private let manager: Alamofire.Manager = Alamofire.Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	
	private var studentId: Int?
	
	private var grade_form: [String: String]?
	private var pinnacle_form: [String: String]?
	private var course_list: [Course]?
	
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
		self.manager.request(.GET, url_login).responseString { (_, response, html_data, error) in
			if error?.code == -1009 {
				View.showTextOverlay("No Internet Connection", clearAfter: 5)
				completionHandler(response, html_data!, SessionError.noInternetConnection)
			}
			else {
				self.loginWithParams(html_data!, completionHandler: completionHandler)
			}
		}
	}
	
	func loadAssignmentsForGrade(grade: Grade, completionHandler: (NSHTTPURLResponse?, String, SessionError?) -> ()) {
		
		let params = [
			"EnrollmentId"	: "\(grade.course!.enrollmentID)",
			"TermId"		: "\(grade.termID)",
			"StudentId"		: "\(studentId!)",
			"H"				: "G"	//No idea what this is, but it's in the form
		]
		let url = "\(url_gradeassignments) "
		View.showWaitOverlayWithText("Loading Assignments")
		self.manager.request(.GET, url_gradeassignments, parameters: params).responseString {
			(request, response, html_data, error) in
			
			let assignments = Parser.getAssignmentsFromHTML(html_data!)
			grade.assignments = assignments
			completionHandler(response, html_data!, nil)
		}
	}
	
	func courses() -> [Course]? {
		return course_list
	}
	
	func studentID() -> Int? {
		return studentId
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
		
		self.manager.request(.POST, url_login, parameters: params).responseString { (_, response, html_data, error) in
			
			//PARSE RESPONSE HERE; CHECK FOR WRONG PASSWORD (~11 elements = correct password, ~10 elements = incorrect password)
			//OR CHECK FOR nil on "Set-Cookie" in response <- much better
			
			View.showWaitOverlayWithText("Grabbing Cookies")
			let responseDict = response!.allHeaderFields as [String: String]
			
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
		self.manager.request(.GET, url_user).responseString { (_, response, html_data, _) in
			let url_redirect = Parser.getRedirectfromHTML(html_data!)
			self.grabGradeFormWithURL(url_redirect, completionHandler)
		}
	}
	
	private func grabGradeFormWithURL(url: String, completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Gradebook form")
		println("\tfrom url \(url)")
		self.manager.request(.GET, url).responseString { (_, response, html_data, error) in
			self.grade_form = Parser.getGradeFormFromHTML(html_data!)
			self.submitGradeForm(completionHandler)
		}
	}
	
	private func submitGradeForm(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Submitting Gradebook form")
		self.manager.request(.GET, url_grades, parameters: grade_form!).responseString { (_, response, html_data, _) in
			self.pinnacle_form = Parser.getPinnacleFormFromHTML(html_data!)
			self.loadMainGradePage(completionHandler)
		}
	}
	
	private func loadMainGradePage(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Loading Gradebook")
		self.manager.request(.POST, url_pinnacle, parameters: pinnacle_form!).responseString { (_, response, html_data, _) in
			self.setSemesterGrades(completionHandler)
		}
	}
	
	private func setSemesterGrades(completionHandler: (NSHTTPURLResponse, String, SessionError?) -> ()) {
		View.showWaitOverlayWithText("Grabbing Semester Grades")
		self.manager.request(.GET, url_gradesummary).responseString { (_, response, html_data, _) in
			let (courses, studentId) = Parser.getReportTableFromHTML(html_data!)
			self.course_list = courses
			self.studentId = studentId
			completionHandler(response!, html_data!, nil)
		}
	}
}