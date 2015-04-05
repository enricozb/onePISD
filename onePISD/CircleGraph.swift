//
//  CircleGraph.swift
//  onePISD
//
//  Created by Enrico Borba on 4/3/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class CircleGraph: UIView {
	
	var progress: CGFloat
	var circle_bg: CAShapeLayer?
	var circle_progress: CAShapeLayer?
	let weight: CGFloat = 5
	
	init(frame: CGRect, progress: Float) {
		self.progress = CGFloat(progress)
		super.init(frame: frame)
		setUp()
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	func setUp() {
		circle_bg = createBgCircle()
		circle_progress = createProgressCircle()
		let label = createLabel()
		self.layer.addSublayer(circle_bg)
		self.layer.addSublayer(circle_progress)
		self.addSubview(label)
	}
	
	func createLabel() -> UILabel {
		let label = UILabel(frame: self.frame)
		label.frame.origin.x = 0
		label.frame.origin.y = 0
		
		label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
		label.text = "\(Int(round(progress * 100)))%"
		label.textAlignment = NSTextAlignment.Center
		label.textColor = Colors.getColor(0)
		return label
	}
	
	func createProgressCircle() -> CAShapeLayer {
		let circle = CAShapeLayer()
		let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
		let radius = min(self.frame.height, self.frame.width)/2.0 - weight/2 - 10
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = CGFloat(2 * M_PI) * (progress)
		
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
		let radius = min(self.frame.height, self.frame.width)/2 - weight/2
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = 2 * CGFloat(M_PI)
		
		circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false).CGPath
		circle.fillColor = UIColor.clearColor().CGColor
		circle.strokeColor = Colors.getColor(1).CGColor
		circle.lineWidth = weight
		
		return circle
	}

}