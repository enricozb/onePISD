/**
* GradeCell
* The UITableView Cell that displays the grade information
* for a specific six week and course.
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/18/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class GradeCell: UITableViewCell {
	
	var grade: Grade?				// The Grade Object corresponding to the cell
	
	static let height: CGFloat = 64 // The Constant cell height
	
	var height : CGFloat {
		return GradeCell.height
	}
	
	var indicator: UIView?
	var gradeLabel: UILabel?
	var courseNameLabel: UILabel?
	var segueChevron: UIImageView?
	var active = false
	
	private var UICreated: Bool = false
	
	/**
	* Prepares the cell for display with the current grade.
	*/
	func configure(grade: Grade) {
		self.grade = grade
		if !UICreated {
			createCellUI()
		}
		setIndicator()
		setLabels()
		setChevron()
	}
	
	/**
	* Sets the corresponding color for the grade indicator
	*/
	private func setIndicator() {
		indicator?.backgroundColor = Colors.forGrade(grade!.grade!)
	}
	
	/**
	* Sets the labes to correspond to the grade
	*/
	private func setLabels() {
		self.gradeLabel?.text = "\(grade!.grade!)"
		var name = self.grade!.course!.name.lowercaseString.capitalizedString
		if let range = name.rangeOfString("Ap", options: nil, range: nil, locale: nil) {
			name.replaceRange(range, with: "AP")
		}
		self.courseNameLabel?.text = name
	}
	
	/**
	* Prepares the chevron icon to be used.
	*/
	private func setChevron() {
		if(!grade!.isSemesterGrade()) {
			let image = UIImage(named: "Chevron")!
			segueChevron?.image = image
			segueChevron?.frame = CGRect(x: self.contentView.frame.maxX - 3 * image.size.width, y: height/2 - image.size.height/2, width: image.size.width, height: image.size.height)
		}
		else {
			segueChevron?.image = UIImage()
		}
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
		
		courseNameLabel = UILabel(frame: CGRect(x: gradeLabel!.frame.maxX + 5, y:gradeLabel!.frame.minY, width: 200, height: 40))
		courseNameLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
		courseNameLabel?.textColor = Colors.grayscale(4)
		
		let image = UIImage(named: "Chevron")!
		segueChevron = UIImageView(image: image)
		segueChevron?.frame = CGRect(x: self.contentView.frame.maxX - 3 * image.size.width, y: height/2 - image.size.height/2, width: image.size.width, height: image.size.height)
		
		self.addSubview(gradeLabel!)
		self.addSubview(courseNameLabel!)
		self.addSubview(segueChevron!)
		self.addSubview(indicator!)
		
		self.backgroundColor = Colors.grayscale(1)
		self.selectionStyle = UITableViewCellSelectionStyle.None;
		
		UICreated = true
	}
	
	/**
	* Prepares the cell for animation to the assignmentView.
	* @param completion The function to be called when the animation
	* finishes. Defaults to a blank function.
	*/
	func segue(completion: (Bool) -> () = {(_) in }) {
		if active || self.grade!.isSemesterGrade(){
			return
		}
		active = true
		UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
			let inframe = self.indicator!.frame
			self.indicator?.frame = CGRect(x: inframe.origin.x, y: inframe.origin.y, width: self.contentView.frame.width, height: inframe.height)
			}, completion: {(bool) in
				completion(bool)
		})
	}
	
	/**
	* Deselects the cell. Animates it's color animation back to its
	* normal state.
	*/
	func deselect() {
		UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
			let inframe = self.indicator!.frame
			self.indicator?.frame = CGRect(x: inframe.origin.x, y: inframe.origin.y, width: 5, height: inframe.height)
			}, completion: {(_) in
				self.active = false
		})
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		segueChevron?.frame = CGRect(x: self.contentView.frame.maxX - 3 * segueChevron!.frame.width, y: height/2 - segueChevron!.frame.height/2, width: segueChevron!.frame.width, height: segueChevron!.frame.height)
	}
}
