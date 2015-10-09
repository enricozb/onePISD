//
//  AppDelegate.swift
//  onePISD
//
//  Created by Enrico Borba on 2/18/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	private func setGlobalUI() {
		setNavBar()
		setTabBar()
	}
	
	private func setNavBar() {
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		UINavigationBar.appearance().barTintColor = Colors.grayscale(2)
		UINavigationBar.appearance().tintColor = Colors.grayscale(4)
		UINavigationBar.appearance().translucent = false
		UINavigationBar.appearance().titleTextAttributes =
			[
				NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
				NSForegroundColorAttributeName: Colors.grayscale(4)
		]
	}
	
	private func setTabBar() {
		UITabBar.appearance().shadowImage = UIImage()
		UITabBar.appearance().backgroundImage = UIImage()
		UITabBar.appearance().barTintColor = Colors.grayscale(2)
		UITabBar.appearance().translucent = false
		UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: Colors.grayscale(4)
			], forState: UIControlState.Selected)
		UITabBarItem.appearance().setTitleTextAttributes([ NSForegroundColorAttributeName: Colors.grayscale(0)
			], forState: UIControlState.Normal)
	}
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		setGlobalUI()
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

