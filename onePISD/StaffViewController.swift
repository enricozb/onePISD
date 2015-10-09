/**
* StaffViewController.swift
* The UITableView that displays the staff contacts.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit


class StaffViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
	let tableView = UITableView()
	let sectionCount = 2
	var faculty_data: (admin: [FacultyEntry], staff: [FacultyEntry])?
	
	/**
	* Called by the delegate in order to determine the number
	* of sections
	* @param the table view in question
	* @return the number of sections
	*/
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sectionCount
	}
 
	/**
	* Called by the delegate in order to determine the number
	* of sections
	* @param the table view in question
	* @param the section.
	* @return the number of rows
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return faculty_data!.admin.count
		}
		else {
			return faculty_data!.staff.count
		}
	}
 
	/**
	* Called by the delegate in order to determine the number
	* cell's configuration
	* @param the table view in question
	* @param the index path of the cell being rendered
	* @return the number of rows
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
		let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
		if(indexPath.section == 0) {
			cell.configure(faculty_data!.admin[indexPath.row])
		}
		else {
			cell.configure(faculty_data!.staff[indexPath.row])
		}
		// set cell's textLabel.text property
		// set cell's detailTextLabel.text property
		return cell
	}
	
	/**
	* Configures the faculty data.
	*/
	func initData() {
		self.faculty_data = MainSession.session.facultyData()
	}
	
	/**
	* Sets up the tableView and assigns the delegate.
	*/
	func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView(frame: CGRectZero)
		tableView.separatorColor = Colors.grayscale(4, alpha: 0.2)
		tableView.backgroundColor = Colors.grayscale(1)
		tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
		tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49, 0)
		tableView.registerClass(ContactCell.self, forCellReuseIdentifier: "ContactCell")
		self.navigationItem.title = "Staff"
		self.view.addSubview(tableView)
	}
	
	/**
	* Called once, when the view is loaded. Initializes and prepares
	* the table for display.
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		initData()
		initTableView()
	}
	
}


