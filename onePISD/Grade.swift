//
//  Grade.swift
//  onePISD
//
//  Created by Enrico Borba on 2/21/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation

/* ----- TODO ------
	_ possibly change termID to an optional, for semester grades that have no detailed view.
*/

class Grade {
	var course : Course?
	let termID : Int
	let grade : Int?
	let blank : Bool
	var assignments : [Assignment]?
	
	init(termID: Int, grade: Int?) {
		self.termID = termID
		self.grade = grade
		self.blank = false
	}
	
	init(blank: Bool) {
		self.termID = 0
		self.grade = 0
		self.blank = true
	}
}