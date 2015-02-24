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
*/

import Foundation
import UIKit

class Parser {
	class func getLTfromHTML(html: String) -> String {
		let range_start = html.rangeOfString("name=\"lt\" value=\"")
		let range_end = html.rangeOfString("name=\"_eventId\"")
		
		var index_end = range_end!.startIndex
		
		for i in 0...31 {
			index_end = index_end.predecessor()	//It's sad how bad swift actually is.
		}
		return html.substringWithRange(Range<String.Index>(start: range_start!.endIndex, end: index_end))
	}
	
	
	class func getUIDfromHTML(html: String) -> String {
		let index_start = html.rangeOfString("\"uID\" value=\"")!.endIndex
		var index_end = index_start
		
		for _ in 1...50 {
			index_end = index_end.successor()
		}
		
		return html.substringWithRange(Range<String.Index>(start: index_start, end: index_end))
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
			
			form[name] = value
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
		let string_beginAssignments = "<table id=\"Assignments\" class=\"reportTable\">"
		let string_endAssignments = "</table>"
		var substring = html.substringFromIndex(html.rangeOfString(string_beginAssignments)!.startIndex)
		substring = substring.substringFromIndex(substring.rangeOfString("<tbody>")!.endIndex)
		let assignmentString = substring.substringToIndex(substring.rangeOfString("</tbody>")!.startIndex)
		
		//Trim substring to only include <tbody> ... </tbody> and parse each assignment.
		
		var assignments = [Assignment]()
		let scanner = NSScanner(string: assignmentString)
		var stringBuffer : NSString?
		while scanner.scanString("<tr>", intoString: nil) {
			scanner.scanUpToString("<tr>", intoString: &stringBuffer)
			let singleAssignment = Parser.getSingleAssignmentFromHTML(stringBuffer!)
			assignments.append(singleAssignment)
		}
		return assignments
		
	}
	
	// MARK: Private class methods
	
	private class func extractCourse(html: String) -> (Course?, Int?){
		let scanner = NSScanner(string: html)
		var stringBuffer: NSString?
		
		scanner.scanUpToString("<a href", intoString: nil)
		scanner.scanUpToString("<th", intoString: &stringBuffer)
		let (title, enrollmentID) = extractClassTitleAndID(stringBuffer!)
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
	
		let period = (stringBuffer as String).toInt()!
		var grades = [Grade]()
		scanner.scanUpToString("<td", intoString: nil) //Begin grade grabbing
		
		if scanner.scanString("<td class=\"disabledCell\"", intoString: nil) {
			return (nil, nil)
		}
		
		var studentID: Int = 0
		
		for i in 0...9 {
			scanner.scanUpToString("</td", intoString: &stringBuffer)
			let (grade, termID, possibleStudentID) = self.extractGradeAndTermIDAndStudentID(stringBuffer!)
			if let tid = termID {
				if studentID == 0 {
					studentID = possibleStudentID!
				}
				grades.append(Grade(termID: tid, grade: grade))
			}
			else {
				grades.append(Grade(termID: i/5, grade: grade))
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
		
		scanner = NSScanner(string: stringBuffer!)
		
		 // Now scanning this <a href="StudentAssignments.aspx?EnrollmentId=0&amp;TermId=0&amp;StudentId=0&amp;H=G">0</a>
		
		scanner.scanUpToString("TermId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer) // TermID=0
		stringBuffer = stringBuffer?.substringFromIndex(countElements("TermId="))
		
		let termID = (stringBuffer! as String).toInt()!
		
		scanner.scanUpToString("StudentId=", intoString: nil)
		scanner.scanUpToString("&", intoString: &stringBuffer)
		
		stringBuffer = stringBuffer?.substringFromIndex(countElements("StudentId="))
		
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
		stringBuffer = stringBuffer?.substringFromIndex(countElements("assignmentId="))
		
		let assignmentID = (stringBuffer as String).toInt()!
		
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		let title = decodeString(stringBuffer!)
		
		scanner.scanString("</a></td>", intoString: nil)
		scanner.scanUpToString(">", intoString: nil)
		scanner.scanUpToString("<", intoString: &stringBuffer)
		stringBuffer = stringBuffer?.substringFromIndex(1)
		
		let date = decodeString(stringBuffer!)
		
		scanner.scanUpToString("<td>", intoString: nil)
		scanner.scanString("<td>", intoString: nil)
		scanner.scanUpToString("</td>", intoString: &stringBuffer)
		
		let category = decodeString(stringBuffer!)
		
		scanner.scanUpToString("<td class=\"grade\">", intoString: nil)
		scanner.scanString("<td class=\"grade\">", intoString: nil)
		scanner.scanUpToString("</td>", intoString: &stringBuffer)
		
		let grade = (stringBuffer as String).toInt()
		
		return Assignment(name: title, date: date, category: category, grade: grade, assignmentID: assignmentID)
	}
	
	private class func decodeString(string: String) -> String {
		let encodedData = string.dataUsingEncoding(NSUTF8StringEncoding)!
		let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
		let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
		
		let decodedString = attributedString!.string
		return decodedString
	}
}