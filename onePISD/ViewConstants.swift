//
//  ViewConstants.swift
//	Used for Storyboard constant convinience
//  onePISD
//
//  Created by Enrico Borba on 2/19/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//
import UIKit

public enum Storyboard: String {
	case Login = "LoginViewController"
	case MainView = "MainView"
	case GradeSummary = "GradeSummaryViewController"
	case GradeSummaryNav = "GradeSummaryNavigationController"
	case StaffContactView = "StaffContactViewController"
	case StaffContactNav = "StaffContactNavigationController"
	
	public static func getViewControllerByID(storyboard: Storyboard) -> UIViewController {
		return getViewControllerByID(storyboard.rawValue)
	}
	
	public static func getViewControllerByID(storyboardID: String) -> UIViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		return storyboard.instantiateViewControllerWithIdentifier(storyboardID) as! UIViewController
	}
}

public class View: NSObject {
	
	//Static variable workaround. Thank you swift?
	private struct currentViewStruct {
		static var view : UIViewController?
	}
	
	class var currentView : UIViewController {
		get { return currentViewStruct.view! }
		set { currentViewStruct.view = newValue }
	}
	
	private struct loadingBarStruct {
		static var bar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
	}
	
	class var loadingBarView : UIView {
		get { return loadingBarStruct.bar }
		set { loadingBarStruct.bar = newValue }
	}
	
	class func loadView(storyboard: Storyboard, fromView: UIViewController) {
		let destinationView = Storyboard.getViewControllerByID(storyboard.rawValue) as UIViewController
		fromView.presentViewController(destinationView, animated: true, completion: nil)
	}
	
	class func showTextOverlay(string: String, clearAfter time: Double) {
		self.clearOverlays()
		currentView.view.userInteractionEnabled = false
		currentView.showTextOverlay(string)
		NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: Selector("clearOverlays"), userInfo: nil, repeats: false)
	}
	
	class func showWaitOverlayWithText(string: String) {
		self.clearOverlays()
		currentView.view.userInteractionEnabled = false
		currentView.showWaitOverlayWithText(string)
		println(string)
	}
	
	class func clearOverlays() {
		currentView.view.userInteractionEnabled = true
		SwiftOverlays.removeAllOverlaysFromView(currentView.view)
	}
	
	class func showLoadingOverlay(percent: Double) {
		loadingBarView.removeFromSuperview()
		UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
			self.loadingBarView.frame = CGRect(x: 0, y: 0, width: Double(self.currentView.view.frame.width) * percent, height: 20)
			self.loadingBarView.backgroundColor = Colors.forGrade(Int(percent * 100))
			}, completion: {(_) in
				if Int(percent * 100) == 100 {
					UIView.animateWithDuration(0.5, delay: 1, options: .CurveEaseInOut, animations: {
						self.loadingBarView.frame = CGRect(x: 0, y: 0, width: self.currentView.view.frame.width, height: 0)
						}, completion: {(_) in
							
					})
				}
		})
		UIApplication.sharedApplication().keyWindow?.addSubview(loadingBarView)
	}
}