//
//  Login.swift
//  onePISD
//
//  Created by Enrico Borba on 2/19/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import UIKit

class LoginView : UIViewController {
	
	let backgroundColor = UIColor(red: 0.290196078, green: 0.392156863, blue: 0.568627451, alpha: 1)
	
	@IBOutlet weak var textFieldBackground: UIImageView!
	@IBOutlet weak var usernameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	@IBAction func loginButtonPressed(sender: UIButton) {
		
		self.view.endEditing(false)
		
		MainSession.session.setCredentials(username: usernameTextField.text, password: passwordTextField.text)
		
		MainSession.session.login { (response, html_data, error) in
			if error == SessionError.wrongCredentials {
				println("Wrong Credentials")
				self.notifyWrongCredentials()
			}
			else if error != SessionError.noInternetConnection {
				println("Six Week Grades Loaded!")
				View.loadView(Storyboard.GradeSummary, fromView: self)
			}
		}
	}
	
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = self.backgroundColor
		View.currentView = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
}