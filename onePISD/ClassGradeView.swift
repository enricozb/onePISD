//
//  ClassGradeView.swift
//  onePISD
//
//  Created by Enrico Borba on 3/16/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class ClassGradeView: UIViewController {
	
	init() {
        super.init(nibName: "ClassGradeView", bundle: nil);
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	//required init?;?(coder aDecoder: NSCoder) {

	required init?(coder aDecoder: NSCoder) {
	    //fatalError("init(coder:) has not been implemented")
		super.init(nibName: "ClassGradeView", bundle: NSBundle.mainBundle())
	}
}