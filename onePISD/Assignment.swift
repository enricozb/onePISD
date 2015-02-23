//
//  MiniGrade.swift
//  onePISD
//
//  Created by Enrico Borba on 2/22/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

class Assignment {
	let name: String
	let date: String
	let category: String
	let grade: Int?
	let assignmentID: Int
	let comment: String? //Not currently used
	
	
	init(name: String, date: String, category: String, grade: Int?, assignmentID: Int) {
		self.name = name
		self.date = date
		self.category = category
		self.grade = grade
		self.assignmentID = assignmentID
	}
}