/**
* MainTabViewController.swift
* Handles the navigation between the GradeSummary and the 
* faculty contact page through a UITabBar.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class MainTabBarController : UITabBarController, UITabBarControllerDelegate {
	
	/**
	* Sets the background color of the root view
	*/
	private func initBackground() {
		self.view.backgroundColor = Colors.grayscale(1)
	}
	
	/**
	* Initializes the two views and adds them to the main UITabBar. Creates the two tabbaritems
	* and binds them to their respective views. Essentially creates the lowermost navigation.
	*/
	private func initViewControllers() {
		let view_grades = Storyboard.getViewControllerByID(.GradeSummaryNav)
		let icon_grades = UITabBarItem(title: "Grades", image: UIImage(named: "TabBarItem-Grades-U"), selectedImage: UIImage(named: "TabBarItem-Grades-S"))
		icon_grades.image = icon_grades.image?.imageWithRenderingMode(.AlwaysOriginal)
		icon_grades.selectedImage = icon_grades.selectedImage.imageWithRenderingMode(.AlwaysOriginal)
		view_grades.tabBarItem = icon_grades
		
		let view_staff = Storyboard.getViewControllerByID(.StaffContactNav)
		let icon_staff = UITabBarItem(title: "Staff", image: UIImage(named: "TabBarItem-Grades-U"), selectedImage: UIImage(named: "TabBarItem-Grades-S"))
		icon_staff.image = icon_staff.image?.imageWithRenderingMode(.AlwaysOriginal)
		icon_staff.selectedImage = icon_staff.selectedImage.imageWithRenderingMode(.AlwaysOriginal)
		view_staff.tabBarItem = icon_staff
		
		self.viewControllers = [view_grades, view_staff]
	}
	
	/**
	* Is called when the view is loaded/constructed. Is called only once. Assigns
	* this class as a tabBarController delegate, which allows it to modify a 
	* global tabBarItem.
	*/
	override func viewDidLoad() {
		tabBarController?.delegate = self
		initBackground()
		initViewControllers()
	}
	
	
}