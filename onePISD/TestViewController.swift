//
//  SecondViewController.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
	@IBOutlet var tableView: UITableView!
	
	
	var courses = [Course]()
	let textCellIdentifier = "TextCell"

	override func viewDidLoad() {
		super.viewDidLoad()
		View.currentView = self
		courses = MainSession.session.courses()!
		
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	//Sections, swank up.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return courses.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
		
		let row = indexPath.row
		cell.textLabel?.text = courses[row].name
		
		return cell
	}
	
	let segueString = "ShowAssignmentsSegue"
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == segueString {
			if let destination = segue.destinationViewController as? TestAssignmentViewController {
				if let index = tableView.indexPathForSelectedRow()?.row {
					destination.labelString = courses[index].name
				}
			}
		}
	}
	
	//SELECTION METHOD: Called when tapped on cell!
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let row = indexPath.row
		println(courses[row])
	}
}

