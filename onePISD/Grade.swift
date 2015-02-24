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
		at the moment this has been "solved" by creating termID's based on their previous and next values
		ex. [111, 0, 113] is now [111, 112, 113]
		Becomes an issue when Session tries to load grades in these 'imaginary' termID's.
			-Prevent segue on tablecells when row == 4 | 9
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