//
//  Parser.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

/* ----- TODO ------
	*	parse individual assignments
	_	inout parameters for _form_ functions
	_	support for semester courses, and for dropped/1.5 credit courses
	_	rewrite some shit
	_	fix private functions
	*	write a damn substring method, or a class. (Sane String)
*/

import UIKit

class Parser {
	class func getLTfromHTML(html: String) -> String {
		var substring = html["name=\"lt\" value=\"", "name=\"_eventId\""]
		return substring.substringTo(substring.length() - 32)
	}
	
	
	class func getUIDfromHTML(html: String) -> String {
		var starting_index = html["\"uID\" value=\""] + "\"uID\" value=\"".length()
		return html.substring(start: starting_index, end: starting_index + 50)
	}
	
	class func getRedirectfromHTML(html: String) -> String {
		let index_start = html.rangeOfString("<a href=\"")!.endIndex
		let index_end = html.rangeOfString("\">here</a>")!.startIndex
		return html.substringWithRange(Range<String.Index>(start: index_start, end: index_end))
	}
	
	class func getGradeFormFromHTML(html: String) -> [String : String] {
		let form = [
			"action"	: "trans",
			"uT"		: "S",
			"uID"		: self.getUIDfromHTML(html)
		]
		return form
	}
	
	class func getPinnacleFormFromHTML(html: String) -> [String : String] {
		var form = [String : String]()
		
		var scanner: NSScanner
		var index_start: String.Index
		var substring: String
		
		let form_names = ["userId", "password"]

		for name in form_names {
			index_start = html.rangeOfString("\"\(name)\" value=\"")!.endIndex
			substring = html.substringFromIndex(index_start)
			
			scanner = NSScanner(string: substring)
			
			let endString = "\"/></td>"
			
			var value: NSString?
			scanner.scanUpToString(endString, intoString: &value)
			
			form[name] = value as? String
		}
		return form
	}
	
	class func getReportTableFromHTML(html: String) -> ([Course], Int) {
		let divisorString = "<td class=\"gradeNumeric\" colspan=\"3\" title=\"\" >"
		let initGradesString = "<tr class='row"
		let endGradesString = "</tbody>"
		let endTitleString = "<th class=\"classTitle\" scope=\"row\">"
		let courseSeparatorString = "</tr>"
		
		
		var gradeString: String = html.substringFromIndex(html.rangeOfString(initGradesString)!.startIndex)
		gradeString = gradeString.substringToIndex(gradeString.rangeOfString(endGradesString)!.startIndex)
		
		//println(gradeString)
		
		var courseStrings = gradeString.componentsSeparatedByString(courseSeparatorString)
		
		courseStrings.removeLast()
		
		var studentID: Int = 0
		
		var courses = [Course]()
		for courseString in courseStrings {
			let (possibleCourse, possibleStudentID) = extractCourse(courseString)
			if let course = possibleCourse {
				courses.append(course)
			}
			if possibleStudentID != nil && studentID == 0 {
				studentID = possibleStudentID!
			}
		}
		
		return (courses, studentID)
	}
	
	class func getAssignmentsFromHTML(html: String) -> [Assignment] {
		var assignments = [Assignment]()
		
		let string_beginAssignments = "<table id=\"Assignments\" class=\"reportTable\">"
		let string_endAssignments = "</table>"
		let startRange = html.rangeOfString(string_beginAssignments)
		if startRange == nil {
			return assignments
		}
		var substring = html.substringFromIndex(startRange!.startIndex)
		substring = substring.substringFromIndex(substring.rangeOfString("<tbody>")!.endIndex)
		let assignmentString = substring.substringToIndex(substring.rangeOfString("</tbody>")!.startIndex)
		//Trim substring to only include <tbody> ... </tbody> and parse each assignment.
		let scanner = NSScanner(string: assignmentString)
		var stringBuffer : NSString?
		while scanner.scanString("<tr>", intoString: nil) {
			scanner.scanUpToString("<tr>", intoString: &stringBuffer)
			let singleAssignment = Parser.getSingleAssignmentFromHTML(stringBuffer! as String)
			assignments.append(singleAssignment)
		}
		return assignments
		
	}
	
	class func getAttendanceCredentials(html: String) -> (viewState: String, eventVal: String, pageID: String) {
		
		return ("", "", "")
	}
	
	class func getFacultyFromHTML(html: String) -> ([FacultyEntry], [FacultyEntry])  {
		var faculty_admin = [FacultyEntry]()
		var faculty_staff = [FacultyEntry]()
		let begin_admin_string = "<h2>Administrators &amp; Office Staff<br>"
		let end_admin_string = "<h2>Staff &amp; Faculty</h2>"
		
		let admin_string = html.substring(start: begin_admin_string, end: end_admin_string)
		//println(admin_string)
		
		let scanner = NSScanner(string: admin_string)
		var string_buffer: NSString?
		scanner.scanUpToString("</tr>", intoString: &string_buffer)

		while(scanner.scanUpToString("<tr valign=\"top\">", intoString: nil)) {
			scanner.scanString("<tr valign=\"top\">", intoString: nil)
			if !scanner.scanUpToString("</tr>", intoString: &string_buffer) {
				break
			}
			let faculty_entry = Parser.getFacultyEntryFromHTML(string_buffer as! String, admin: true)
			faculty_admin.append(faculty_entry)
		}
		
		var staff_string = Parser.trimAndCondenseWhitespace(html.substringFrom(html[end_admin_string]))
		staff_string = staff_string.substringFrom(staff_string["</tr>"] + "</tr>".length())
		
		let strings = staff_string.componentsSeparatedByString("</tr>")
		for string in strings {
			let faculty_entry = Parser.getFacultyEntryFromHTML(string, admin: false)
			faculty_staff.append(faculty_entry)
		}
		
		return (faculty_admin, faculty_staff)
	}
	
	// MARK: Private class methods
	
	private class func extractCourse(html: String) -> (Course?, Int?){
		let scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		
		scanner.scanUpToString("<a href", intoString: nil)
		scanner.scanUpToString("<th", intoString: &stringBuffer)
		let (title, enrollmentID) = extractClassTitleAndID(stringBuffer! as String)
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
	
		let period = (stringBuffer as! String).toInt()!
		var grades = [Grade]()
		scanner.scanUpToString("<td", intoString: nil) //Begin grade grabbing
		
		if scanner.scanString("<td class=\"disabledCell\"", intoString: nil) {
			return (nil, nil)
		}
		
		var studentID: Int = 0
		
		for i in 0...9 {
			scanner.scanUpToString("</td", intoString: &stringBuffer)
			let (grade, termID, possibleStudentID) = self.extractGradeAndTermIDAndStudentID(stringBuffer! as String)
			if let tid = termID {
				if studentID == 0 {
					studentID = possibleStudentID!
				}
				grades.append(Grade(termID: tid, grade: grade, index: i))
			}
			else {
				grades.append(Grade(termID: i/5, grade: grade, index: i))
			}
			scanner.scanUpToString("<td", intoString: nil)
		}
		return (Course(name: title, period: period, grades: grades, enrollmentID: enrollmentID), studentID)
	}
	
	private class func extractClassTitleAndID(html: String) -> (String, Int) {
		// Comes in as <a href="javascript:ClassDetails.getClassDetails(...);">CLASS TITLE</a></th> (...) is enrollementID
		var substring: String = html.substringFromIndex(html.rangeOfString(">")!.endIndex)
		let title =  decodeString(substring.substringToIndex(substring.rangeOfString("<")!.startIndex))
		
		substring = html.substringFromIndex(html.rangeOfString("(")!.endIndex)
		let enrollmentID = substring.substringToIndex(substring.rangeOfString(")")!.startIndex).toInt()!
		
		return (title, enrollmentID)
	}
	
	private class func extractGradeAndTermIDAndStudentID(html: String) -> (Int?, Int?, Int?) {
		var scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("</td", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		if let grade = (stringBuffer! as String).toInt() {
			return (grade, nil, nil)
		}
		else if stringBuffer!.length == 0 {
			return (nil, nil, nil)
		}
		
		scanner = NSScanner(string: stringBuffer! as String)
		
		 // Now scanning this <a href="StudentAssignments.aspx?EnrollmentId=0&amp;TermId=0&amp;StudentId=0&amp;H=G">0</a>
		
		scanner.scanUpToString("TermId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer) // TermID=0
		stringBuffer = stringBuffer?.substringFromIndex(count("TermId="))
		
		let termID = (stringBuffer! as String).toInt()!
		
		scanner.scanUpToString("StudentId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer)
		
		stringBuffer = stringBuffer?.substringFromIndex(count("StudentId="))
		
		let studentID = (stringBuffer! as String).toInt()!
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		if stringBuffer?.length == 0 {
			return (nil, termID, studentID)
		}
		else {
			return ((stringBuffer! as String).toInt()!, termID, studentID)
		}
	}
	
	private class func getSingleAssignmentFromHTML(html: String) -> Assignment{
		var scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		
		scanner.scanUpToString("assignmentId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(count("assignmentId="))
		
		let assignmentID = (stringBuffer as! String).toInt()!
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		let title = decodeString(stringBuffer! as String)
		
		scanner.scanString("</a></td>", intoString: nil)
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		let date = decodeString(stringBuffer! as String)
		
		scanner.scanUpToString("<td>", intoString: nil)
		scanner.scanString("<td>", intoString: nil)
		scanner.scanUpToString("</td>", intoString: &stringBuffer)
		
		let category = decodeString(stringBuffer! as String)
		
		scanner.scanUpToString("<td class=\"grade\">", intoString: nil)
		scanner.scanString("<td class=\"grade\">", intoString: nil)
		scanner.scanUpToString("</td>", intoString: &stringBuffer)
		
		let grade = (stringBuffer as! String).toInt()
		
		return Assignment(name: title, date: date, category: category, grade: grade, assignmentID: assignmentID)
	}
	
	private class func decodeString(string: String) -> String {
		let encodedData = string.dataUsingEncoding(NSUTF8StringEncoding)!
		let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
		let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
		
		let decodedString = attributedString!.string
		return decodedString
	}
	
	private class func getFacultyEntryFromHTML(html: String, admin: Bool) -> FacultyEntry {
		if admin {
			
			var title = html.substring(start: "<th scope=\"row\">", end: "</th>")
			title = title.stringByReplacingOccurrencesOfString("<br>", withString: "")
			title = Parser.trimAndCondenseWhitespace(title)
			
			var name = html.substringFrom(html["<td>"] + "<td>".length())
			name = name.substringTo(name["</td>"])
			name = Parser.trimAndCondenseWhitespace(name)
			
			var email = html.substringFrom(html["</td>"] + "</td>".length())
			email = email.substring(start: "<td>", end: "</td>")
			email = Parser.trimAndCondenseWhitespace(email)
			
			return FacultyEntry(first: name, last: "", email: email, section: FacultyEntry.adminSection, title: title)
		}
		
		else {
			var lastname = html.substringFrom(html["valign=\"top\">"] + "valign=\"top\">".length())
			lastname = lastname.substringTo(lastname["</td>"])
			lastname = lastname.stringByReplacingOccurrencesOfString("<p>", withString: "")
			lastname = lastname.stringByReplacingOccurrencesOfString("</p>", withString: "")
			
			var firstname = html.substringFrom(html["</td>"] + "</td>".length())
			var email = firstname.substringFrom(firstname["</td>"] + "</td>".length())
			
			firstname = firstname.substringFrom(firstname["valign=\"top\">"] + "valign=\"top\">".length())
			firstname = firstname.substringTo(firstname["</td>"])
			firstname = firstname.stringByReplacingOccurrencesOfString("<p>", withString: "")
			firstname = firstname.stringByReplacingOccurrencesOfString("</p>", withString: "")
			
			email = email.substringFrom(email["valign=\"top\">"] + "valign=\"top\">".length())
			email = email.substringTo(email["</td>"])
			email = email.stringByReplacingOccurrencesOfString("<p>", withString: "")
			email = email.stringByReplacingOccurrencesOfString("</p>", withString: "")
			
			return FacultyEntry(first: firstname, last: lastname, email: email, section: FacultyEntry.staffSection, title: nil)
		}
	}
	
	private class func trimAndCondenseWhitespace(string: String) -> String {
		let string_trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		let components = string_trimmed.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
		return join(" ", components)

	}
}