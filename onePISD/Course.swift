//
//  Course.swift
//  onePISD
//
//  Created by Enrico Borba on 2/20/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Course {
	let name: String
	let period: Int
	let grades: [Grade]
	let enrollmentID: Int
	
	init(name: String, period: Int, grades: [Grade], enrollmentID: Int) {
		self.name = name
		self.period = period
		self.grades = grades
		self.enrollmentID = enrollmentID
		
		for grade in grades {
			grade.course = self
		}
	}
}