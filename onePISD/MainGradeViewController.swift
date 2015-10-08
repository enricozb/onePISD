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
		super.viewDidLoad()
		
		initStatusBarView()
		initNavigationBar()
		initBackgroundView()
		initPageMenu()
		initTabBar()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	private func initStatusBarView() {
		let sbview = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
		sbview.backgroundColor = Colors.getColor(4)
		self.view.addSubview(sbview)
	}
	
	private func initNavigationBar() {
		self.navigationItem.title = "Grade Summary"
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
		self.navigationController?.navigationBar.backgroundColor = Colors.getColor(4)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.translucent = true
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSForegroundColorAttributeName: Colors.getColor(0),
			NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!
		]
	}
	
	private func initBackgroundView() {
		let imageView = UIImageView(frame: self.view.frame)
		imageView.image = UIImage(named: "BG-gauss-100-2")
		self.view.addSubview(imageView)
		self.view.sendSubviewToBack(imageView)
	}
	
	private func initPageMenu() {
		var controllerArray : [UIViewController] = []
		
		for course in MainSession.session.courses()! {
			let controller = CourseGradeTableView()
			controller.setCourse(course)
			
			controller.title = course.name
			controllerArray.append(controller as UIViewController)
		}
		
		let parameters: [String: AnyObject] = [
			"scrollMenuBackgroundColor": Colors.getColor(4),
			"viewBackgroundColor": UIColor.clearColor(),
			"selectionIndicatorColor": Colors.getColor(0),
			"addBottomMenuHairline": false,
			"menuItemFont": UIFont(name: "HelveticaNeue-Light", size: 11.0)!,
			"menuHeight": 50.0,
			"selectionIndicatorHeight": 2.0,
			"menuItemWidthBasedOnTitleTextWidth": true,
			"selectedMenuItemLabelColor": Colors.getColor(0),
			"unselectedMenuItemLabelColor": UIColor.darkGrayColor()
		]
		
		pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 64, self.view.frame.width, self.view.frame.height), options: parameters)
		self.view.addSubview(pageMenu!.view)
	}
	
	private func initTabBar() {
		self.tabBarController?.tabBar.backgroundImage = UIImage()
		self.tabBarController?.tabBar.backgroundColor = Colors.getColor(4)
		self.tabBarController?.tabBar.shadowImage = UIImage()
		self.tabBarController?.tabBar.translucent = true
		//self.tabBarController?.tabBar.barStyle = UIBarStyle.BlackTranslucent
		self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
		self.tabBarController?.tabBar.selectedImageTintColor = Colors.getColor(0)
	}
}