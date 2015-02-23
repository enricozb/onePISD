//
//  FirstViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		View.currentView = self
		let courses = MainSession.session.courses()!
		
		for course in courses {
			println(course.enrollmentID)
			for grade in course.grades {
				println("\(grade.grade) \(grade.termID)")
			}
			println()
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

