//
//  UICardViewController.swift
//  UICardView
//
//  Created by Enrico Borba on 2/24/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class UICardViewController : UICollectionViewController{
	
	var assignments = [Assignment]()
	var grade : Grade?
	
	func loadData() {
		View.currentView = self
		View.showWaitOverlayWithText("Loading Assignments")
		MainSession.session.loadAssignmentsForGrade(self.grade!) { (response, html_data, error) in
			View.clearOverlays()
			self.assignments = self.grade!.assignments!
			self.collectionView?.reloadData()
		}
	}
	
	override func viewDidLoad() {
		
		self.automaticallyAdjustsScrollViewInsets = false
		// CHANGE TO SET FRAME METHOD
		let frame = self.collectionView!.frame
		let height = self.navigationController!.navigationBar.frame.height + 20
		
		self.collectionView?.frame = CGRectMake(frame.minX, frame.minY + height, frame.width, frame.height - height)
		
		// FRAME METHOD END
		
		self.collectionView?.registerNib(UINib(nibName: "UICardCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "card") //Seen in IB attributes inspector on .xib file
		
	}
	
	override func viewWillAppear(animated: Bool) {
		self.setNeedsStatusBarAppearanceUpdate()
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return assignments.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("card", forIndexPath: indexPath) as UICardCell
		let assignment = self.assignments[indexPath.row]
		
		if let grade = assignment.grade {
			cell.gradeLabel.text = "\(grade)"
		}
		else {
			cell.gradeLabel.text = "-"
		}

		cell.assignmentTitleLable.text = assignment.name
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		var should = true
		
		for path in collectionView.indexPathsForSelectedItems() as [NSIndexPath] {
			collectionView.deselectItemAtIndexPath(path, animated: true)
			self.collectionView(collectionView, didDeselectItemAtIndexPath: path as NSIndexPath)
			should = false
		}
		
		return should
	}
	
	override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.performBatchUpdates(nil, completion: nil)
		collectionView.scrollEnabled = true
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		collectionView.performBatchUpdates(nil, completion: nil)
		collectionView.scrollEnabled = false
	}
	
	override func shouldAutomaticallyForwardAppearanceMethods() -> Bool{
		return true
	}
	
	override func viewDidAppear(animated: Bool) {
		View.currentView = self
		if grade?.assignments == nil {
			self.loadData()
		}
		else {
			self.assignments = self.grade!.assignments!
			self.collectionView?.reloadData()
		}
	}
}