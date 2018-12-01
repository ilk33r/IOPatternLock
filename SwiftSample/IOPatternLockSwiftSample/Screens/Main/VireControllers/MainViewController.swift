//
//  MainViewController.swift
//  IOPatternLockSwiftSample
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

import Foundation
import IOPatternLock
import UIKit

class MainViewController: UIViewController, IOPatternLockDelegate {
	
	@IBOutlet weak var patternLockView: IOPatternLockView!
	
	func ioPatternLockView(_ patternLockView: IOPatternLockView, patternCompleted selectedPatterns: [NSNumber]) {
		print(selectedPatterns)
	}
	
	func ioPatternLockView(_ patternLockView: IOPatternLockView, patternCompletedWithError error: Error) {
		print(error.localizedDescription)
	}
	
}
