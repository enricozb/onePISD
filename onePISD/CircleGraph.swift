//
//  CircleGraph.swift
//  onePISD
//
//  Created by Enrico Borba on 4/3/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class CircleGraph: UIView {
	
	var grade: Grade
	var circle_bg: CAShapeLayer?
	var circle_progress: CAShapeLayer?
	let weight: CGFloat = 3
	
	init(frame: CGRect, grade: Grade) {
		self.grade = grade
		super.init(frame: frame)
		setUp()
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	func setUp() {
		circle_bg = createBgCircle()
		self.layer.addSublayer(circle_bg)
		if grade.grade != nil {
			circle_progress = createProgressCircle()
			self.layer.addSublayer(circle_progress)
				
			let label = createLabel()
			self.addSubview(label)
		}
		initLine()
	}
	
	func initLine() {
		let radius = min(self.frame.height, self.frame.width)/2.0 - weight/2 - 10
		let x = self.frame.width/2 - 0.5
		let y = self.frame.height/2 + radius + weight/2
		let height = SixWeekGradeCell.height/2 - radius - weight/2
		if grade.index % 5 != 4 {
			var frame = CGRect(x: x, y: y, width: 1, height: height)
			let line1 = UIView(frame: frame)
			line1.backgroundColor = UIColor.whiteColor()
			self.addSubview(line1)
		}
		
		if grade.index % 5 != 0 {
			var frame = CGRect(x: x, y: y - radius * 2 - height - weight, width: 1, height: height)
			let line2 = UIView(frame: frame)
			line2.backgroundColor = UIColor.whiteColor()
			self.addSubview(line2)
		}
	}
	
	func createLabel() -> UILabel {
		let label = UILabel(frame: self.frame)
		label.frame.origin.x = 0
		label.frame.origin.y = 0
		
		label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
		label.text = "\(grade.grade!)"
		label.textAlignment = NSTextAlignment.Center
		label.textColor = Colors.getColor(0)
		return label
	}
	
	func createProgressCircle() -> CAShapeLayer {
		let circle = CAShapeLayer()
		let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
		let radius = min(self.frame.height, self.frame.width)/2.0 - weight/2 - 10
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = CGFloat(2 * M_PI) * CGFloat(grade.grade!)/100.0
		
		circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
		circle.fillColor = UIColor.clearColor().CGColor
		circle.strokeColor = Colors.getColor(0).CGColor
		circle.lineCap = kCALineCapRound
		circle.lineWidth = weight
		circle.strokeEnd = 0
		
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0
		animation.toValue = 1
		animation.duration = 1
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		circle.addAnimation(animation, forKey: "animateCircle")
		circle.strokeEnd = 1
		return circle
	}
	
	func createBgCircle() -> CAShapeLayer {
		let circle = CAShapeLayer()
		let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
		let radius = min(self.frame.height, self.frame.width)/2 - weight/2 - 10
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = 2 * CGFloat(M_PI)
		
		circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false).CGPath
		circle.fillColor = UIColor.clearColor().CGColor
		circle.strokeColor = Colors.getColor(3).CGColor
		circle.lineWidth = weight
		
		return circle
	}

}