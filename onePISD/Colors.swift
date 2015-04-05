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
	
	class var theme: Int {
		return 3
	}
	
	class func makeUIColor(#r: Int, g: Int, b: Int, a: Float) -> UIColor {
		return UIColor(red: CGFloat(Float(r)/255.0), green: CGFloat(Float(g)/255.0), blue: CGFloat(Float(b)/255.0), alpha: CGFloat(a))
	}
	
	class func getColor(num: Int) -> UIColor {
		switch( theme ) {
		case 0: return getColor1(num)
		case 1: return getColor2(num)
		case 2: return getColor3(num)
		case 3: return getColor4(num)
		default: fatalError("No such theme exists.")
		}
	}
	
	private class func getColor1(num: Int) -> UIColor {
		switch( num ) {
		case 0: return makeUIColor(r: 207, g: 240, b: 158, a: 1.0)
		case 1: return makeUIColor(r: 168, g: 219, b: 168, a: 1.0)
		case 2: return makeUIColor(r: 121, g: 189, b: 154, a: 1.0)
		case 3: return makeUIColor(r:  59, g: 134, b: 134, a: 1.0)
		case 4: return makeUIColor(r:  11, g:  72, b: 107, a: 1.0)
		default: fatalError("No such color exists.")
		}
	}
	
	private class func getColor2(num: Int) -> UIColor {
		switch( num ) {
		case 0: return makeUIColor(r: 254, g:  67, b: 101, a: 1.0)
		case 1: return makeUIColor(r: 252, g: 157, b: 154, a: 1.0)
		case 2: return makeUIColor(r: 249, g: 205, b: 173, a: 1.0)
		case 3: return makeUIColor(r: 200, g: 200, b: 169, a: 1.0)
		case 4: return makeUIColor(r: 131, g: 175, b: 155, a: 1.0)
		default: fatalError("No such color exists.")
		}
	}
	
	private class func getColor3(num: Int) -> UIColor {
		switch( num ) {
		case 0: return makeUIColor(r: 248, g: 177, b: 148, a: 1.0)
		case 1: return makeUIColor(r: 246, g: 114, b: 128, a: 1.0)
		case 2: return makeUIColor(r: 192, g: 108, b: 132, a: 1.0)
		case 3: return makeUIColor(r: 108, g:  91, b: 123, a: 1.0)
		case 4: return makeUIColor(r:  55, g:  92, b: 125, a: 1.0)
		default: fatalError("No such color exists.")
		}
	}
	
	private class func getColor4(num: Int) -> UIColor {
		switch(num) {
		case 0: return UIColor.whiteColor()
		case 1: return UIColor.lightGrayColor()
		case 2: return UIColor(white: 0.3, alpha: 0.5)
		case 3: return UIColor(white: 0.7, alpha: 0.5)
		case 4: return UIColor(white: 0.9, alpha: 0.5)
		default: fatalError("No such color exists.")
		}
	}

	
}