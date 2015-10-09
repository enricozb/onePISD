//
//  FacultyEntry.swift
//  onePISD
//
//  Created by Enrico Borba on 5/25/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FacultyEntry {
	static let adminSection = 0
	static let staffSection = 1
	
	let firstName: String
	let lastName: String
	let email: String
	let title: String?
	let section: Int
	
	init(first: String, last: String, email: String, section: Int, title: String?) {
		self.firstName = first
		self.lastName = last
		self.email = email
		self.section = section
		self.title = title
	}
}
