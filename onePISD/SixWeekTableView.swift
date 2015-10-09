/**
* SixWeekTableView.swift
* Holds a set of Grades that correspond to a sixweeks
* and displays them in a table format. Allows for the 
* user to click on a Grade and see the assignments 
* for that specific course in that specific sixweeks.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class SixWeekTableView : UIViewController, UITableViewDelegate, UITableViewDataSource{
	let tableView = UITableView()				// The main tableView displaying the GradeCells
	var grade_data: SixWeek?					// The SixWeek data specific to the table view
	var gradeView: GradeSummaryViewController?	// The parent controller holding this view
	var active = false							// If assignments are being viewed
	
	/**
	* Configures this SixWeekTableView with it's grade Data. Removes any
	* Empty SixWeeks grades, and sets its title for the assignment view.
	*/
	func setGradeData(data: SixWeek) {
		data.purgeEmpty()
		grade_data = data
		self.title = grade_data?.getName()
	}
	
	/**
	* A function required by UITableViewDelegate. Returns the number of sections within the
	* table view. (Only one, as all grades in this SixWeeks are under the same six weeks.
	* @param tableView The tableView who's section count is in question.
	*/
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	/**
	* A method required by UITableViewDelegate. Returns the number of rows within a section.
	* Used to determine the number of table cells that will be needed.
	* @param tableView The tableView in question.
	* @param section The section number in question
	* @return The number of grades, which is equivalent to the number of cells being displayed.
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return grade_data!.grades.count
	}
	
	/**
	* A method required by UITableViewDelegate. Returns the cell to be displayed, given an index.
	* Used to determine the how the cell will be configured before displaying it.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being configured.
	* @return cell The cell after being configured to its specific grade.
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("GradeCell") as! GradeCell
		cell.configure(grade_data!.grades[indexPath.row])
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
		return GradeCell.height
	}
	
	/**
	* A method used by UITableViewDelegate. Called when the user selects a cell.
	* Sets the cell's selection animation and calles animates to the assignment view
	* through the navigation controller.
	* @param tableView The tableView in question.
	* @param indexPath The index of the cell being selected.
	*/
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if active {
			return
		}
		active = true
		let cell = tableView.cellForRowAtIndexPath(indexPath) as! GradeCell
		MainSession.session.loadAssignmentsForGrade(grade_data!.grades[indexPath.row]) { (response, data, sessionError) in
			cell.segue{ (_) in
				View.clearOverlays()
				let assignmentTableView = AssignmentTableView()
				assignmentTableView.setAssignmentData(self.grade_data!.grades[indexPath.row])
				self.gradeView?.navigationController?.pushViewController(assignmentTableView, animated: true)
			}
		}
	}
	
	/**
	* Initializes the internal TableView. Sets this class as its delegate,
	* and properly configures its UI. Registers the GradeCell class as its cell
	* class to be used, and adds the TableView onto it's subview tree.
	*/
	private func initTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView(frame: CGRectZero)
		tableView.separatorColor = Colors.grayscale(4, alpha: 0.2)
		tableView.backgroundColor = Colors.grayscale(1)
		tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
		tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49, 0)
		tableView.registerClass(GradeCell.self, forCellReuseIdentifier: "GradeCell")
		self.view.addSubview(tableView)
	}
	
	/**
	* Deselects the cells in this SixWeeks and clears them of their animations.
	*/
	func clearCells() {
		let indexPaths = tableView.indexPathsForVisibleRows()
		if indexPaths != nil {
			for indexPath in indexPaths as! [NSIndexPath]{
				let cell = tableView.cellForRowAtIndexPath(indexPath) as! GradeCell
				tableView.deselectRowAtIndexPath(indexPath, animated: false)
				cell.deselect()
			}
		}
		active = false
	}
	
	/**
	* Called only once, when the view is constructed. Does the initial setup
	* for the view.
	*/
	override func viewDidLoad() {
		super.viewDidLoad()
		initTableView()
	}
}