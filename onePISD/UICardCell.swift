//
//  UICardCell.swift
//  UICardView
//
//  Created by Enrico Borba on 2/24/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

class UICardCell : UICollectionViewCell {


	@IBOutlet weak var gradeLabel: UILabel!
	@IBOutlet weak var assignmentTitleLable: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}