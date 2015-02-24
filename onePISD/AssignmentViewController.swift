//
//  AssignmentViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/23/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class AssignmentViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var assignmentTableView: UITableView!
	
	var assignments = [Assignment]()
	var grade : Grade?
	
	// MARK: Delegate Methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return assignments.count
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	// MARK: DataSource Methods
	
	let cellId = "AssignmentCell"
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
		let row = indexPath.row
		cell.textLabel?.text = assignments[row].name
		cell.detailTextLabel?.text = assignments[row].category
		return cell
	}
	
	// MARK: UIView Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		View.currentView = self
		self.navigationItem.title = "\(grade!.course!.name)"
		if grade?.assignments == nil {
			MainSession.session.loadAssignmentsForGrade(self.grade!) {
				(response, html_data, error) in
				View.clearOverlays()
				self.assignments = self.grade!.assignments!
				self.assignmentTableView.reloadData()
			}
		}
		else {
			self.assignments = self.grade!.assignments!
			self.assignmentTableView.reloadData()
		}
		
		self.edgesForExtendedLayout = UIRectEdge.All
		assignmentTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.tabBarController!.tabBar.frame.height, 0);

		assignmentTableView.delegate = self
		assignmentTableView.dataSource = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	
}