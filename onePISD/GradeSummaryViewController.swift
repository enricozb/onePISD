//
//  GradeSummaryTableViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/23/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class GradeSummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet var courseTableView: UITableView!
	let cellId = "CourseGradeCell"
	
	// MARK: Helper Methods
	
	func getTermLabel(term: Int) -> String {
		switch(term) {
		case 0 : return "1st Six Weeks:"
		case 1 : return "2nd Six Weeks:"
		case 2 : return "3rd Six Weeks:"
		case 3 : return "Semester Exam:"
		case 4 : return "1st Semester:"
		case 5 : return "4th Six Weeks:"
		case 6 : return "5th Six Weeks:"
		case 7 : return "6th Six Weeks:"
		case 8 : return "Semester Exam:"
		case 9 : return "2nd Semester:"
		default: assert(false, "Term Error \(term)")
		}
	}
	
	// MARK: Delegate Methods
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return MainSession.session.courses()!.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MainSession.session.courses()![section].grades.count
	}
	
	let segueId = "SegueToAssignments"
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == segueId {
			if let destination = segue.destinationViewController as? UICardViewController {
				if let section = courseTableView.indexPathForSelectedRow?.section {
					if let row = courseTableView.indexPathForSelectedRow?.row {
						if shouldPerformSegueWithIdentifier(segueId, sender: sender) {
							let courses = MainSession.session.courses()!
							destination.grade = courses[section].grades[row]
						}
					}
				}
			}
		}
	}
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		let row = courseTableView.indexPathForSelectedRow!.row
		return (row + 1) % 5 != 0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.row + 1) % 5 == 0 {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
	}
	
	// MARK: DataSource Methods
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! GradeCell
		let section = indexPath.section
		let row = indexPath.row
		
		let termDescription = getTermLabel(row)
		cell.termLabel?.text = "\(termDescription)"
		cell.gradeLabel?.text = "-"
		if let grade = MainSession.session.courses()![section].grades[row].grade {
			cell.gradeLabel?.text = "\(grade)"
		}
		if (row + 1) % 5 == 0 {
			cell.accessoryType = UITableViewCellAccessoryType.None
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
		}
		return cell
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return MainSession.session.courses()![section].name
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	// MARK: ViewController Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.title = "Grade Summary"
		
		self.edgesForExtendedLayout = UIRectEdge.All
		courseTableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.tabBarController!.tabBar.frame.height, 0);
		courseTableView.delegate = self
		courseTableView.dataSource = self
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		View.currentView = self
		self.deselectLastCell()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: Private Methods
	
	private func deselectLastCell() {
		let indexPath = courseTableView.indexPathForSelectedRow
		if let path = indexPath {
			courseTableView.deselectRowAtIndexPath(path, animated: true)
		}
	}
	
}