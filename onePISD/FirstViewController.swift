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
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		View.currentView = self
		/*
		MainSession.session.loadAttendanceSummary { (response, html_data, error) in
			println(html_data)
		}
		*/
	}
	
}

