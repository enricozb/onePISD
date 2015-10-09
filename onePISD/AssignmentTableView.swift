/**
* AssignmentTableView.swift
* The UITableView that displays the assignments specific
* to a grade.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class AssignmentTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var tableView = UITableView()		// The table view instance.
	var assignments: [Assignment]?		// The assignments to be displayed
	var courseName : String?
	
	/**
	* Sets the assignment data, and configures the title
	* and cells for display.
	* @param grade The Grade data to be used.
	*/
	func setAssignmentData(grade: Grade) {
		var name = grade.course!.name.lowercaseString.capitalizedString
		if let range = name.rangeOfString("Ap", options: nil, range: nil, locale: nil) {
			name.replaceRange(range, with: "AP")
		}
		self.navigationItem.title = name
		assignments = grade.assignments!
		courseName = grade.course!.name
	}
	
	/**
	* A method used by UITableViewDelegate. Used to determine how
	* many sections will be displayed. Only one section.
	* @param tableView The tableView in question.
	*/
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
 
	/**
	* A method used by UITableViewDelegate. Used to determine how
	* many rows will be displayed.
	* @param tableView The tableView in question.
	* @param section The section in question.
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return assignments!.count
	}
 
	/**
	* A method required by UITableViewDelegate. Returns the cell to be displayed, given an index.
	* Used to determine the how the cell will be configured before displaying it. Configures it
	* to the AssignmentCell standard.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being configured.
	* @return cell The cell after being configured to its specific grade.
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell") as! AssignmentCell
		cell.configure(assignments![indexPath.row])
		return cell
	}
	
	/**
	* A method used by UITableViewDelegate. Returns the height of the cell to be displayed,
	* given an index.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being configured.
	* @return cell The cell height. The same for every GradeCell
	*/
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return AssignmentCell.height
	}
	
	/**
	* A method used by UITableViewDelegate. Called when the user selects a cell.
	* Sets the cell's selection animation and calls animates to the assignment view
	* through the navigation controller.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being selected.
	*/
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! AssignmentCell
		if !cell.selected {
			cell.select()
		}
	}
	
	/**
	* A method used by UITableViewDelegate. Called a cell is deselected.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being selected.
	*/
	func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! AssignmentCell
		cell.deselect()
		return indexPath
	}
	
	/**
	* Initializes the table view for presentation. Places the table view
	* in the proper position.
	*/
	func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView(frame: CGRectZero)
		tableView.separatorColor = Colors.grayscale(4, alpha: 0.2)
		tableView.backgroundColor = Colors.grayscale(1)
		tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - self.tabBarController!.tabBar.frame.height - self.navigationController!.navigationBar.frame.height - 20)
		tableView.registerClass(AssignmentCell.self, forCellReuseIdentifier: "AssignmentCell")
		self.view.addSubview(tableView)
	}
	
	/**
	* Called when the view is constructed.
	* Sets up the view.
	*/
	override func viewDidLoad() {
		initTableView()
	}
}
