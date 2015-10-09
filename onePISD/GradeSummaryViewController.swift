/**
* GradeSummaryViewController.swift
* Holds the main "Grades" navigation. Allows for the viewing of
* any of the available SixWeeks.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/


import UIKit

class GradeSummaryViewController : UIViewController, CAPSPageMenuDelegate {
	var pageMenu : CAPSPageMenu?
	var sixWeeks : [SixWeek]?
	
	/**
	* Called when the view is brought to the front of the application.
	* Clears any selected cell, and sets itself as the current view
	* in case of any overlayed animations.
	*/
	override func viewDidAppear(animated: Bool) {
		clearCells()
		View.currentView = self
	}
	
	/**
	* Called when the view is finished being constructed/loaded.
	* Called only once. Initializes the main components of the view,
	* including the page menu that holds the SixWeeksViews, and the 
	* NavigationBar.
	*/
	override func viewDidLoad() {
		initSixWeekTables()
		initPageMenu()
		self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent;
		self.navigationItem.title = "Grade Summary"
	}
	
	/**
	* Clears all cells in all SixWeekTableViews within the pageMenu.
	*/
	private func clearCells() {
		if pageMenu != nil {
			let index = pageMenu!.currentPageIndex
			let sixWeekView = pageMenu!.controllerArray[index] as! SixWeekTableView
			sixWeekView.clearCells()
		}
	}
	
	/** 
	* Creates and fills the pageMenu that holds each SixWeekTableView
	* Each SixWeekTableView is configured with a reference to its grades,
	* which may change while they are loaded asynchronously.
	*/
	func initPageMenu() {
		var controllers = [UIViewController]()
		if let _ = sixWeeks {
			for sixWeek in sixWeeks! {
				if sixWeek.blank {
					println("blank")
					continue
				}
				let tableview = SixWeekTableView()
				tableview.setGradeData(sixWeek)
				tableview.gradeView = self
				controllers.append(tableview)
			}
		}
		else {
			fatalError("Six Weeks empty in GradeSummaryViewController")
		}
		
		var parameters: [String: AnyObject] =
			[
				"menuItemSeparatorWidth": 4.3,
				"menuItemSeparatorPercentageHeight": 0.1,
				"addBottomMenuHairline": false,
				"menuItemWidthBasedOnTitleTextWidth": true,
				"viewBackgroundColor": Colors.grayscale(1),
				"scrollMenuBackgroundColor": Colors.grayscale(2),
				"selectionIndicatorColor": Colors.grayscale(3),
				"unselectedMenuItemLabelColor": Colors.grayscale(0),
				"selectedMenuItemLabelColor": Colors.grayscale(3),
				"menuItemFont": UIFont(name: "HelveticaNeue-Light", size: 15)!
			]
		pageMenu = CAPSPageMenu(viewControllers: controllers, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), options: parameters)
		pageMenu?.moveToPage(controllers.count - 1, duration: 0)
		pageMenu!.delegate = self
		self.view.addSubview(pageMenu!.view)

	}
	
	/**
	* Rearranges the grades in the sixWeeks format, instead of by course.
	*/
	private func initSixWeekTables() {
		sixWeeks = MainSession.session.sixWeeks()
	}
	
	/**
	* Called when the user swipes to a new SixWeekTableView, and clears
	* the cells in the view that is soon to be shown.
	*/
	func willMoveToPage(controller: UIViewController, index: Int) {
		let sixWeekTableView = controller as! SixWeekTableView
		sixWeekTableView.clearCells()
	}
}