//
//  Login.swift
//  onePISD
//
//  Created by Enrico Borba on 2/19/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class LoginView : UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	@IBOutlet weak var usernameImageView: UIImageView!
	@IBOutlet weak var passwordImageView: UIImageView!
	
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var centerBar: NSLayoutConstraint!
	
	@IBOutlet weak var loginButton: UIButton!
	
	func debugLogin() {
		usernameTextField.text = "username"
		passwordTextField.text = "password"
		buttonPressed(self)
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool {
		self.view.endEditing(true)
		return true
	}

	@IBAction func buttonPressed(sender: AnyObject) {
		self.view.endEditing(true)
		self.loginButton.enabled = false
		View.clearOverlays()
		MainSession.session.setCredentials(username: usernameTextField.text, password: passwordTextField.text)
		MainSession.session.login { (response, html_data, error) in
			if error == SessionError.wrongCredentials {
				println("Wrong Credentials")
				self.loginButton.enabled = true
				self.passwordTextField.text = ""
				View.showTextOverlay("Incorrect Credentials", clearAfter: 2)
			}
			else if error == SessionError.noInternetConnection {
				println("No Internet Connection")
				View.showTextOverlay("No Internet Connection", clearAfter: 2)
			}
			else {
				println("Six Week Grades Loaded!")
				View.loadView(Storyboard.GradeSummary, fromView: self)
			}
		}
	}
	
	
	// MARK: UIView Functions
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.view.endEditing(true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		usernameTextField.delegate = self
		passwordTextField.delegate = self
		self.setPlaceholderText()
		self.prepareForAnimate()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		View.currentView = self
		self.animateLogin()
		self.debugLogin()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	// MARK: Private Functions
	
	private func prepareForAnimate() {
		self.usernameTextField.alpha = 0
		self.passwordTextField.alpha = 0
		self.usernameImageView.alpha = 0
		self.passwordImageView.alpha = 0
		self.loginButton.alpha = 0
	}
	
	private func animateLogin() {
		self.centerBar.constant = self.view.frame.height/5
		
		UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
			self.view.layoutIfNeeded()
			self.usernameTextField.alpha = 1
			self.passwordTextField.alpha = 1
			self.usernameImageView.alpha = 1
			self.passwordImageView.alpha = 1
			self.loginButton.alpha = 1
			}, completion: {(_) in
		})
		

	}
	
	private func setPlaceholderText() {
		let attributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
		let str_user = NSAttributedString(string: "Username", attributes: attributes)
		let str_pass = NSAttributedString(string: "Password", attributes: attributes)
		usernameTextField.attributedPlaceholder = str_user
		passwordTextField.attributedPlaceholder = str_pass
	}
	
	/*
	private func notifyWrongCredentials() {
		let useranimation = CABasicAnimation(keyPath: "position")
		useranimation.duration = 0.06
		useranimation.repeatCount = 3
		useranimation.autoreverses = true
		useranimation.fromValue = NSValue(CGPoint: CGPointMake(usernameTextField.center.x - 10, usernameTextField.center.y))
		useranimation.toValue = NSValue(CGPoint: CGPointMake(usernameTextField.center.x + 10, usernameTextField.center.y))
		
		let passanimation = CABasicAnimation(keyPath: "position")
		passanimation.duration = 0.06
		passanimation.repeatCount = 3
		passanimation.autoreverses = true
		passanimation.fromValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x - 10, passwordTextField.center.y))
		passanimation.toValue = NSValue(CGPoint: CGPointMake(passwordTextField.center.x + 10, passwordTextField.center.y))
		
		let textanimation = CABasicAnimation(keyPath: "position")
		textanimation.duration = 0.06
		textanimation.repeatCount = 3
		textanimation.autoreverses = true
		textanimation.fromValue = NSValue(CGPoint: CGPointMake(textFieldBackground.center.x - 10, textFieldBackground.center.y))
		textanimation.toValue = NSValue(CGPoint: CGPointMake(textFieldBackground.center.x + 10, textFieldBackground.center.y))
		
		passwordTextField.text = ""
		usernameTextField.layer.addAnimation(useranimation, forKey: "position")
		passwordTextField.layer.addAnimation(passanimation, forKey: "position")
		textFieldBackground.layer.addAnimation(textanimation, forKey: "position")
	}
	*/
	
}