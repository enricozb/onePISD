//
//  MainGradeViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 3/15/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class MainGradeViewController: UIViewController {
	var pageMenu : CAPSPageMenu?
	
	override func viewDidLoad() {
		//#34495e
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 52/255.0, green: 73/255.0, blue: 94/255.0, alpha: 0)
		
		self.navigationItem.title = "Grade Summary"
		self.navigationController?.navigationBar.clipsToBounds = true
		var controllers : [UIViewController] = []
		for course in MainSession.session.courses()! {
			var controller : UIViewController = ClassGradeView()
			controller.title = course.name
			controllers.append(controller)
		}
		var parameters: [String : AnyObject] = [
			"menuItemWidthBasedOnTitleTextWidth": true,
			"useMenuLikeSegmentedControl": false,
			"menuItemSeparatorPercentageHeight": 0.1,
			"selectionIndicatorHeight" : 0,
			"scrollMenuBackgroundColor" : UIColor(red: 52/255.0, green: 73/255.0, blue: 94/255.0, alpha: 1),
			"menuItemFont" : UIFont(name: "HelveticaNeue-Light", size: 16)!
		]
		
		pageMenu = CAPSPageMenu(viewControllers: controllers, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height - 64), options: parameters) //Nav-bar and status bar height
		self.view.addSubview(pageMenu!.view)
	}
}