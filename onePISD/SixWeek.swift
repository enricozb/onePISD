//
//  SixWeek.swift
//  onePISD
//
//  Created by Enrico Borba on 2/20/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class SixWeek {
	let index: Int
	var grades: [Grade]
	var blank : Bool

	class func template() -> [SixWeek] {
		var sixWeeks = [SixWeek]()
		for i in 0...9 {
			sixWeeks.append(SixWeek(index: i, grades: [Grade](), blank: true))
		}
		return sixWeeks
	}
	
	init(index: Int, grades: [Grade], blank: Bool = false) {
		self.index = index
		self.grades = grades
		self.blank = blank
	}
	
	func purgeEmpty() {
		for i in stride(from: grades.count - 1, through: 0, by: -1){
			let grade = grades[i]
			if grade.blank {
				grades.removeAtIndex(i)
			}
		}
	}
	
	func addGrade(grade: Grade) {
		grades.append(grade)
		blank = blank && grade.blank
	}
	
	func getName() -> String {
		switch (self.index) {
		case 0: return "1st Six Weeks"
		case 1: return "2nd Six Weeks"
		case 2: return "3rd Six Weeks"
		case 3: return "1st Semester Exam"
		case 4: return "1st Semester"
		case 5: return "4th Six Weeks"
		case 6: return "5th Six Weeks"
		case 7: return "6th Six Weeks"
		case 8: return "2nd Semester Exam"
		case 9: return "2nd Semester"
		default: return ""
		}
	}
}