//
//  UICardLayout.swift
//  UICardView
//
//  Created by Enrico Borba on 2/24/15.
//  Copyright (c) 2015 Enrico Borba. All rights reserved.
//

import Foundation
import UIKit

struct CellMetrics {
	var size : CGSize = CGSize(width: 0, height: 0)
	var overlap : CGFloat = 0
}

struct CellLayoutMetrics {
	var normal = CellMetrics()
	var collapsed = CellMetrics()
	var bottomStackedTotalHeight : CGFloat = 0
	var bottomStackedHeight : CGFloat = 0
}

struct CellLayoutEffects {
	var inheritance : CGFloat = 0
	var bouncesTop : Bool = false
	var sticksTop : Bool = false
}

class UICardLayout : UICollectionViewLayout {
	var metrics = CellLayoutMetrics()
	var effects = CellLayoutEffects()
	
	// MARK: Initialization
	
	override init() {
		super.init()
		self.useDefaultMetricsAndInvalidate(false)
	}
	
	//required init?;?(coder aDecoder: NSCoder) {

	required init?(coder aDecoder: NSCoder) {
	    //fatalError("init(coder:) has not been implemented")
		super.init(coder: aDecoder)
		self.useDefaultMetricsAndInvalidate(false)
	}
	
	func useDefaultMetricsAndInvalidate(invalidate: Bool) {
		var m = CellLayoutMetrics()
		var e = CellLayoutEffects()
		
		m.normal.size       = CGSizeMake(320.0, 420.0);
		m.normal.overlap    = 0.0;
		m.collapsed.size    = CGSizeMake(320.0, 96.0);
		m.collapsed.overlap = 48.0;
		
		m.bottomStackedHeight = 8.0;
		m.bottomStackedTotalHeight = 32.0;
		
		e.inheritance       = 0.20;
		e.sticksTop         = true;
		e.bouncesTop        = true;
		
		self.metrics = m
		self.effects = e
		
		if invalidate {
			self.invalidateLayout()
		}
	}
	
	func useDefaultMetrics() {
		self.useDefaultMetricsAndInvalidate(true)
	}
	
	// MARK: Layout

	override func prepareLayout() {
		
	}
	
	override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
		let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
		let selectedPaths = self.collectionView!.indexPathsForSelectedItems()!
		
		if selectedPaths.count > 0 && selectedPaths[0].isEqual(indexPath) {
			attributes.frame = frameForSelectedCard(self.collectionView!.bounds, metrics: self.metrics)
		}
		else if selectedPaths.count > 0 {
			attributes.frame = frameForUnselectedCard(indexPath, selectedIndexPath: selectedPaths[0], bounds: self.collectionView!.bounds, metrics: self.metrics)
		}
		else {
			let isLast = (indexPath.item == (self.collectionView!.numberOfItemsInSection(indexPath.section) - 1));
			attributes.frame = frameForCardAtIndex(indexPath, isLast: isLast, bounds: self.collectionView!.bounds, metrics: self.metrics, effects: self.effects)
		}
		
		attributes.zIndex = zIndexForCardAtIndex(indexPath)
		return attributes
	}

	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let range = rangeForVisibleCells(rect, count: self.collectionView!.numberOfItemsInSection(0), metrics: self.metrics)
		var cells = Array<UICollectionViewLayoutAttributes>(count: range.length, repeatedValue: UICollectionViewLayoutAttributes())
		var index = 0
		for item in range.location..<(range.location + range.length) {
			cells[index] = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: item, inSection: 0))!
			index++
		}
		return cells
	}
	
	override func collectionViewContentSize() -> CGSize {
		return collectionViewSize(self.collectionView!.bounds, count: self.collectionView!.numberOfItemsInSection(0), metrics: self.metrics)
	}
	
	override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
		return true
	}
	
	// MARK: Cell Visibility
	
	func rangeForVisibleCells(rect: CGRect, count: Int, metrics: CellLayoutMetrics) -> NSRange {
		var min = Int(floor(rect.origin.y / (metrics.collapsed.size.height - metrics.collapsed.overlap)))
		var max = Int(ceil((rect.origin.y + rect.size.height) / (metrics.collapsed.size.height - metrics.collapsed.overlap)))
		//HERERE
		
		max = (max > count) ? count : max
		min = (min < 0) ? 0 : min
		min = (min < max) ? min : max
		
		return NSMakeRange(min, max - min)
	}
	
	func collectionViewSize(bounds: CGRect, count: Int, metrics: CellLayoutMetrics) -> CGSize {
		return CGSizeMake(bounds.size.width, CGFloat(count) * (metrics.collapsed.size.height - metrics.collapsed.overlap))
	}
	
	// MARK: Cell Positioning
	
	func frameForCardAtIndex(indexPath: NSIndexPath, isLast: Bool, bounds: CGRect, metrics: CellLayoutMetrics, effects: CellLayoutEffects) -> CGRect {
		let x = (bounds.size.width - metrics.normal.size.width) / 2.0
		var y : CGFloat = CGFloat(indexPath.item) * CGFloat(metrics.collapsed.size.height - metrics.collapsed.overlap)
		
		let size = metrics.normal.size
		
		if (bounds.origin.y < 0.0) && (effects.inheritance > (0.0)) && (effects.bouncesTop) {
			
			if indexPath.section == 0 && indexPath.item == 0 {
				y = bounds.origin.y * effects.inheritance/2.0
				//size.height = metrics.collapsed.size.height - bounds.origin.y * (1 + effects.inheritance);
			}
			else {
				y -= bounds.origin.y * CGFloat(indexPath.item) * effects.inheritance
				//size.height -= bounds.origin.y * effects.inheritance;
			}
		}
		else if bounds.origin.y > 0 {
			if y < bounds.origin.y && effects.sticksTop {
				y = bounds.origin.y
			}
		}
		/*
		if isLast {
			size = metrics.normal.size
		}
		*/
		let origin = CGPoint(x: x, y: y)
		
		return CGRect(origin: origin, size: size)
	}

	
	func frameForSelectedCard(bounds: CGRect, metrics: CellLayoutMetrics) -> CGRect {
		
		let size = metrics.normal.size
		let x =	(bounds.size.width - size.width) / 2.0
		let y = bounds.origin.y + (bounds.size.height - size.height)/2.0
		let origin = CGPoint(x: x, y: y)
		
		return CGRect(origin: origin, size: size)
	}

	func frameForUnselectedCard(indexPath: NSIndexPath, selectedIndexPath: NSIndexPath, bounds: CGRect, metrics: CellLayoutMetrics) -> CGRect {
		let size = metrics.collapsed.size
		
		let x = (bounds.size.width - metrics.normal.size.width) / 2.0
		let y = bounds.origin.y + bounds.size.height - metrics.bottomStackedTotalHeight + metrics.bottomStackedHeight * CGFloat(indexPath.item - selectedIndexPath.item)
		
		let origin = CGPoint(x: x, y: y)
		return CGRect(origin: origin, size: size)
	}
	
	// MARK: z-index
	
	func zIndexForCardAtIndex(indexPath: NSIndexPath) -> Int {
		return indexPath.item
	}
	
	// MARK: Accessors 
	
	func setMetrics(metrics: CellLayoutMetrics) {
		self.metrics = metrics
		self.invalidateLayout()
	}
	
	func setEffects(effects: CellLayoutEffects) {
		self.effects = effects
		self.invalidateLayout()
	}
}