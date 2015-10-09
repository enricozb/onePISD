//
//  Colors.swift
//  onePISD
//
//  Created by Enrico Borba on 4/4/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

public class Colors {
	
	class func color(#red: Int, green: Int, blue: Int, alpha: Float = 1) -> UIColor {
		return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
	}
	
	class var red : UIColor {
		return color(red: 203, green: 75, blue: 100)
	}
	
	class var orange : UIColor {
		return color(red: 273, green: 147, blue: 40)
	}
	
	class var yellow : UIColor {
		return color(red: 232, green: 192, blue: 60)
	}
	
	class var green : UIColor {
		return color(red: 141, green: 198, blue: 63)
	}
	
	class func grayscale(num: Int) -> UIColor {
		return grayscale(num, alpha: 1)
	}
	
	class func grayscale(num: Int, alpha: Float) -> UIColor {
		switch(num) {
		case 0: return color(red: 39, green: 44, blue: 51, alpha: alpha)
		case 1: return color(red: 63, green: 71, blue: 83, alpha: alpha)
		case 2: return color(red: 76, green: 88, blue: 102, alpha: alpha)
		case 3: return color(red: 140, green: 154, blue: 171, alpha: alpha)
		case 4: return color(red: 182, green: 200, blue: 222, alpha: alpha)
		default: fatalError("Grayscale color of \(num) does not exist")
		}
	}
	
	class func forGrade(gval: Int?) -> UIColor {
		if let grade = gval {
			switch (grade) {
			case 0..<70:
				return red
			case 70..<80:
				return lerpColor(start: red, end: orange, val: Float(grade - 70)/10.0)
			case 80..<90:
				return lerpColor(start: orange, end: yellow, val: Float(grade - 80)/10.0)
			default:
				return lerpColor(start: yellow, end: green, val: Float(grade - 90)/10.0)
			}
		}
		else {
			return grayscale(1)
		}
	}
	
	private class func lerpColor(start uic0: UIColor, end uic1: UIColor, val: Float) -> UIColor {
		let v = CGFloat(val)
		
		let c0 = CIColor(color: uic0)!
		let c1 = CIColor(color: uic1)!
		
		let r0 = c0.red()
		let g0 = c0.green()
		let b0 = c0.blue()
		
		let r1 = c1.red()
		let g1 = c1.green()
		let b1 = c1.blue()
		
		let r = (1 - v) * r0 + v * r1
		let g = (1 - v) * g0 + v * g1
		let b = (1 - v) * b0 + v * b1
		return UIColor(red: r, green: g, blue: b, alpha: 1)
	}
}