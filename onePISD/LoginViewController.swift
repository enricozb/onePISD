/**
* LoginViewController.swift
* onePISD
*
* @author Enrico Borba
* Period: 2
* Date: 5/7/15
* Copyright (c) 2015 Enrico Borba. All rights reserved.
*/

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	var usernameTextField: UITextField?		// The user-interactive text field that holds the username
	var passwordTextField: UITextField?		// The user-interactive text field that holds the username
	
	var usernameFieldImage: UIImageView?	// The image behind the username text field
	var passwordFieldImage: UIImageView?	// The image behind the username text field
	
	var loginButton: UIButton?
	var loginButtonImage: UIImage?			// The image representing the login button
	
	var topCoverView: UIView?				// The onePISD Logo
	
	/**
	* Is called when the login view appears. Clears any loading overlays when called.
	* @param animated Whether or not the appearance of this view animated
	*/
	override func viewDidAppear(animated: Bool) {
		View.currentView = self
		View.clearOverlays()
	}
	
	/**
	* Is called when the login view is loaded. Called only once throughout the entire
	* execution of the application
	*/
	override func viewDidLoad() {
		initTextFields()
		initButton()
		initCoverViews()
		initBackground()
		animateCoverViews()
	}
	
	/**
	* Returns the desired UIStatusBarStyle for this view. (Light, Translucent, etc.)
	* @return The desired UIStatusBarStyle for this view.
	*/
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	/**
	* Called when a user touches the view only, and not a button/field within the view.
	* Dismisses the keyboard. Is used so the user can access the login button.
	* @param touches The touches that caused this method to be called
	* @param event The UIEvent associated with the touches (ex. touches pressed,
	* released, etc).
	*/
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		self.view.endEditing(true)
	}
	
	/**
	* Called when the user presses the RETURN key on the keyboard while editing one
	* of the text fields. Dismisses the keyboard. Must be public in order to 
	* be called by the delegate.
	* @param textField The text field that was being edited.
	* @return Whether or not the RETURN button should display a pressed animation
	*/
	 func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	
	/**
	* Initializes the positions of the text fields and the images behind them.
	* Centers the text fields and positions them properly on the screen.
	*/
	private func initTextFields() {
		let width:  CGFloat = 250
		let height: CGFloat = 50
		let midX = self.view.frame.midX
		let midY = self.view.frame.midY
		let padding: CGFloat = 20
		
		usernameFieldImage = UIImageView(frame: CGRect(x: midX - width/2, y: midY - height, width: width, height: height))
		usernameFieldImage?.image = UIImage(named: "textField")

		usernameTextField = UITextField(frame: CGRect(x: midX - width/2, y: midY - height, width: width, height: height))
		usernameTextField?.textAlignment = NSTextAlignment.Center
		usernameTextField?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
		usernameTextField?.textColor = Colors.grayscale(3)
		usernameTextField?.autocapitalizationType = UITextAutocapitalizationType.None
		usernameTextField?.autocorrectionType = UITextAutocorrectionType.No
		usernameTextField?.attributedPlaceholder = NSAttributedString(string: "Username",
			attributes: [NSForegroundColorAttributeName : Colors.grayscale(3)])
		usernameTextField?.keyboardAppearance = UIKeyboardAppearance.Dark
		
		passwordFieldImage = UIImageView(frame: CGRect(x: midX - width/2, y: midY + padding, width: width, height: height))
		passwordFieldImage?.image = UIImage(named: "textField")
		
		passwordTextField = UITextField(frame: CGRect(x: midX - width/2, y: midY + padding, width: width, height: height))
		passwordTextField?.textAlignment = NSTextAlignment.Center
		passwordTextField?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
		passwordTextField?.textColor = Colors.grayscale(3)
		passwordTextField?.secureTextEntry = true
		passwordTextField?.autocapitalizationType = UITextAutocapitalizationType.None
		passwordTextField?.autocorrectionType = UITextAutocorrectionType.No
		passwordTextField?.attributedPlaceholder = NSAttributedString(string: "Password",
			attributes: [NSForegroundColorAttributeName : Colors.grayscale(3)])
		passwordTextField?.keyboardAppearance = UIKeyboardAppearance.Dark
		
		self.view.addSubview(usernameTextField!)
		self.view.addSubview(passwordTextField!)
		self.view.addSubview(usernameFieldImage!)
		self.view.addSubview(passwordFieldImage!)
		
		usernameTextField?.delegate = self
		passwordTextField?.delegate = self
		
	}
	
	/**
	* Initializes the positions of the login button and the image behind it.
	* Centers the button and positions it properly on the screen.
	*/
	private func initButton() {
		let width:  CGFloat = 250
		let height: CGFloat = 50
		let midX = self.view.frame.midX
		let maxY = passwordTextField!.frame.maxY
		let padding: CGFloat = 35
		
		loginButton = UIButton(frame: CGRect(x: midX - width/2, y: maxY + padding, width: width, height: height))
		loginButton?.setImage(UIImage(named: "loginButton"), forState: UIControlState.Normal)
		loginButton?.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(loginButton!)
	}
	
	/**
	* Initializes the logo at the top of the login view page.
	* Centers it properly on the screen.
	*/
	private func initCoverViews() {
		let width = self.view.frame.width
		var height: CGFloat = 150
		let logoImageView = UIImageView(image: UIImage(named: "logo"))
		logoImageView.frame = CGRect(x: self.view.frame.width/2 - logoImageView.frame.width/2, y: 0, width: logoImageView.frame.width, height: logoImageView.frame.height)
		let colorImageView = UIImageView(frame: CGRect(x: 0, y: height, width: width, height: 5))
		colorImageView.image = UIImage(named: "colorBar")
		
		topCoverView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
		topCoverView?.backgroundColor = Colors.grayscale(2)
		topCoverView?.addSubview(logoImageView)
		topCoverView?.addSubview(colorImageView)
		self.view.addSubview(topCoverView!)
		
	}
	
	/**
	* Sets the background color.
	*/
	func initBackground() {
		self.view.backgroundColor = Colors.grayscale(1)
	}
	
	/**
	* Animates the cover views when the app first loads
	* [CURRENTLY NOT IMPLEMENTED]
	*/
	func animateCoverViews() {
		UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
			
			}, completion: {(_) in
		})
	}
	
	/**
	* Is called when the login button is pressed. Attempts to login with the credentials that
	* were typed in. Must be public in order to be called by the delegate.
	* @param sender The button that was pressed
	*/
	func buttonPressed(sender: UIButton) {
		if(sender == loginButton) {
			loginButton?.enabled = false
			login()
		}
	}
	
	/**
	* Attempts to log the user in with the given credentials within the text fields. 
	* Displays a loading overlay while the user is being logged in to show progress. 
	* Reports any errors during the login attempt to the user.
	*/
	private func login() {
		self.loginButton?.enabled = false
		MainSession.session.setCredentials(username: usernameTextField!.text, password: passwordTextField!.text)
		MainSession.session.login { (response, html_data, error) in
			if error == SessionError.wrongCredentials {
				println("Wrong Credentials")
				self.passwordTextField!.text = ""
				View.showTextOverlay("Incorrect Credentials", clearAfter: 2)
				self.loginButton?.enabled = true
			}
			else if error == SessionError.noInternetConnection {
				println("No Internet Connection")
				View.showTextOverlay("No Internet Connection", clearAfter: 2)
				self.loginButton?.enabled = true
			}
			else {
				println("Six Week Grades Loaded!")
				View.loadView(Storyboard.MainView, fromView: self)
			}
		}
	}

}