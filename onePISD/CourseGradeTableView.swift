//
//  CourseGradeTableView.swift
//  onePISD
//
//  Created by Enrico Borba on 3/28/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//


import Foundation
import UIKit

class CourseGradeTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let tableView: UITableView = UITableView()
	var grades: [Grade]?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
    
    /*
    override init() {
        super.init()
    }*/
	
	//required init?;?(coder aDecoder: NSCoder) {

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		tableView.backgroundColor = UIColor.clearColor()
		tableView.tableFooterView = UIView(frame: CGRectZero)
		tableView.separatorColor = UIColor.clearColor()
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
		tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 163);
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.registerClass(SixWeekGradeCell.self, forCellReuseIdentifier: "cell")
		
		self.view.addSubview(tableView)
	}
	
	func setCourse(course: Course) {
		grades = course.grades
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let _ = grades {
			return self.grades!.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return SixWeekGradeCell.height
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		(cell as! SixWeekGradeCell).willDisplay()
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! SixWeekGradeCell
		cell.setContent(grades?[indexPath.item], tableView: tableView)
		cell.initView()
		
		return cell as UITableViewCell
		
	}
}