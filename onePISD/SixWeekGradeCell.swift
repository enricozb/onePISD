//
//  SixWeekGradeCell.swift
//  onePISD
//
//  Created by Enrico Borba on 3/28/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class SixWeekGradeCell: UITableViewCell {

	class var height: CGFloat { return 100 }
	class var x_padding: CGFloat { return 0 }
	class var y_padding: CGFloat { return 0 }
	
	var internalView: UIView?
	var superTableView: UITableView?
	var circle: CircleGraph?
	var grade: Grade?
	var label: UILabel?
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectedBackgroundView.backgroundColor = UIColor.orangeColor()
		self.backgroundColor = UIColor.clearColor()
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func setContent(grade: Grade?, tableView: UITableView) {
		self.superTableView = tableView
		self.grade = grade
	}
	
	func initView() {
		if internalView == nil {
			initInternalView()
			initCircleGraph()
			initLabel()
			self.addSubview(internalView!)
		}
		else {
			circle?.removeFromSuperview()
			initCircleGraph()
			initLabel()
		}
	}
	
	func initInternalView() {
		let width = superTableView!.frame.width - SixWeekGradeCell.x_padding
		let height = SixWeekGradeCell.height - SixWeekGradeCell.y_padding/2
		let x = SixWeekGradeCell.x_padding/2
		let y = SixWeekGradeCell.y_padding/4
		let view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
		view.backgroundColor = UIColor.clearColor()
		internalView = view
	}
	
	func initCircleGraph() {
		if circle != nil {
			circle!.removeFromSuperview()
		}
		let inset: CGFloat = 10
		circle = CircleGraph(frame: CGRect(x: inset/2, y: inset/2, width: internalView!.frame.height - inset, height: internalView!.frame.height - inset), grade: self.grade!)
		internalView!.addSubview(circle!)
	}

	func initLabel() {
		if label != nil {
			label!.removeFromSuperview()
		}
		
		let height = internalView!.frame.height
		let width  = internalView!.frame.width
		label = UILabel(frame: CGRect(x: 5 + height + 30, y: 0, width: width - (height + 60), height: height))
		label!.font = UIFont(name: "HelveticaNeue-Light", size: 20)
		label!.text = getLabelString(grade!.index)
		label!.textAlignment = NSTextAlignment.Left
		label!.textColor = Colors.getColor(0)
		label!.adjustsFontSizeToFitWidth = true
		internalView!.addSubview(label!)
	}
	
	func willDisplay() {
		
	}

	func destroyContent() {
		internalView?.removeFromSuperview()
		internalView = nil
	}
	
	private func getLabelString(index: Int) -> String {
		switch (index) {
		case 0: return "1st Six Weeks"
		case 1: return "2nd Six Weeks"
		case 2: return "3rd Six Weeks"
		case 3: return "1st Semester Exam"
		case 4: return "1st Semester"
		case 5: return "4th Six Weeks"
		case 6: return "5th Six Weeks"
		case 7: return "6th Six Weeks"
		case 8: return "2nd Semester Exam"
		case 9: return "2nd Semester"
		default: return ""
		}
	}
	
}