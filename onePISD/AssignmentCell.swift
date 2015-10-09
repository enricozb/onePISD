/**
* AssignmentCell.swift
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

class AssignmentCell: UITableViewCell {
	
	var assignment: Assignment?
	
	static let height: CGFloat = 64
	var height : CGFloat {
		return AssignmentCell.height
	}
	
	var indicator: UIView?
	var gradeLabel: UILabel?
	var courseNameLabel: UILabel?
	var dateLabel: UILabel?
	private var UICreated: Bool = false
	
	/**
	* Prepares the cell for display with the current assignment.
	*/
	func configure(assignment: Assignment) {
		self.assignment = assignment
		if !UICreated {
			createCellUI()
		}
		setIndicator()
		setLabels()
	}
	
	/**
	* Sets the corresponding color for the assignment indicator
	*/
	private func setIndicator() {
		indicator?.backgroundColor = Colors.forGrade(assignment!.grade)
	}
	
	/**
	* Sets the labes to correspond to the assignment
	*/
	private func setLabels() {
		if let grade = assignment?.grade {
			self.gradeLabel?.text = "\(grade)"
		}
		else {
			self.gradeLabel?.text = "-"
		}
		var name = self.assignment!.name.lowercaseString.capitalizedString
		if let range = name.rangeOfString("Ap", options: nil, range: nil, locale: nil) {
			name.replaceRange(range, with: "AP")
		}
		self.courseNameLabel?.text = name
		self.dateLabel?.text = assignment!.date
	}
	
	/**
	* Creates the cell UI, called once since cells are reused.
	* Positions the labels and UI properly.
	*/
	private func createCellUI() {
		
		indicator = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: height))
		setIndicator()
		
		gradeLabel = UILabel(frame: CGRect(x: 20, y: height/2 - 20, width: 35, height: 40))
		gradeLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
		gradeLabel?.textColor = Colors.grayscale(4)
		
		courseNameLabel = UILabel(frame: CGRect(x: gradeLabel!.frame.maxX + 5, y: gradeLabel!.frame.minY, width: self.frame.width - gradeLabel!.frame.maxX - 20, height: 40))
		courseNameLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
		courseNameLabel?.textColor = Colors.grayscale(4)
		courseNameLabel?.adjustsFontSizeToFitWidth = true
		
		dateLabel = UILabel(frame: CGRect(x: courseNameLabel!.frame.origin.x, y: courseNameLabel!.frame.maxY - 7, width: courseNameLabel!.frame.width, height: 15))
		dateLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
		dateLabel?.textColor = Colors.grayscale(4)
		dateLabel?.adjustsFontSizeToFitWidth = true
		
		self.addSubview(gradeLabel!)
		self.addSubview(courseNameLabel!)
		self.addSubview(dateLabel!)
		self.addSubview(indicator!)
		
		self.backgroundColor = Colors.grayscale(1)
		self.selectionStyle = UITableViewCellSelectionStyle.None;
		
		UICreated = true
	}
	
	/**
	* Empty functions that are called by the tableView Delegate.
	* Assignments cannot be selected.
	*/
	func select() { }
	
	func deselect() { }
}
 