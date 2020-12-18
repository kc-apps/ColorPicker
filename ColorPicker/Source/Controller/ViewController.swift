//
//  ProjectName  : ColorPicker
//  File Name    : ViewController.swift
//  Created Date : 2020/12/18
//  
//  Copyright © 2019-2020 KC Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet fileprivate var viewColor: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
}

// MARK: - Button
extension ViewController {
	@IBAction fileprivate func onTouchRGBA(_ sender: UIButton) {
		let viewPicker = ColorPickerView(frame: self.view.frame)
		viewPicker.delegate = self
		self.view.addSubview(viewPicker)
		viewPicker.onShow(currentColor: viewColor.backgroundColor!, style: .rgba)
	}
	
	@IBAction fileprivate func onTouchHSBA(_ sender: UIButton) {
		let viewPicker = ColorPickerView(frame: self.view.frame)
		viewPicker.delegate = self
		self.view.addSubview(viewPicker)
		viewPicker.onShow(currentColor: viewColor.backgroundColor!, style: .hsba)
	}
}

// MARK: - ColorPickerViewDelegate
extension ViewController: ColorPickerViewDelegate {
	func colorPickerView(_ colorPickerView: ColorPickerView, picked color: UIColor) {
		viewColor.backgroundColor = color
	}
}
