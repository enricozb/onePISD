//
//  AssignmentViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/23/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class TestAssignmentViewController: UIViewController {

	
	@IBOutlet var testLabel: UILabel!
	var labelString = ""
	
	override func viewWillAppear(animated: Bool) {
		testLabel.text = labelString
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		View.currentView = self
	}
	
}
