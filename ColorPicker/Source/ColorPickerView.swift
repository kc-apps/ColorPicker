//
//  ProjectName  : ColorPicker
//  File Name    : ColorPickerView.swift
//  Created Date : 2020/12/18
//  
//  Copyright © 2019-2020 KC Apps. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate: class {
	func colorPickerView(_ colorPickerView: ColorPickerView, picked color: UIColor)
}

final class ColorPickerView: UIView {
	enum ColorStyle {
		case rgba
		case hsba
	}
	
	@IBOutlet fileprivate var viewCurrent: UIView! {
		didSet {
			viewCurrent.layer.cornerRadius = 10
		}
	}
	
	@IBOutlet fileprivate var viewSelecting: UIView! {
		didSet {
			viewSelecting.layer.cornerRadius = 10
		}
	}
	
	@IBOutlet fileprivate var labelValue1: UILabel!
	@IBOutlet fileprivate var labelValue2: UILabel!
	@IBOutlet fileprivate var labelValue3: UILabel!
	@IBOutlet fileprivate var sliderValue1: UISlider!
	@IBOutlet fileprivate var sliderValue2: UISlider!
	@IBOutlet fileprivate var sliderValue3: UISlider!
	@IBOutlet fileprivate var sliderAlpha: UISlider!
	@IBOutlet fileprivate var layoutBottom: NSLayoutConstraint!
	
	fileprivate var value1: CGFloat {
		return CGFloat(sliderValue1.value)
	}
	
	fileprivate var value2: CGFloat {
		return CGFloat(sliderValue2.value)
	}
	
	fileprivate var value3: CGFloat {
		return CGFloat(sliderValue3.value)
	}
	
	fileprivate var colorAlpha: CGFloat {
		return CGFloat(sliderAlpha.value)
	}
	
	fileprivate let sliderTrackHeight: CGFloat = 10
	fileprivate var colorStyle: ColorStyle!
	
	weak var delegate: ColorPickerViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		if let view = Bundle.main.loadNibNamed("Color-Picker", owner: self, options: nil)?.first as? UIView {
			view.frame = self.bounds
			self.addSubview(view)
		} else {
			fatalError()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func onShow(currentColor: UIColor, style: ColorStyle) {
		viewCurrent.backgroundColor = currentColor
		viewSelecting.backgroundColor = currentColor
		
		colorStyle = style
		
		switch colorStyle {
		case .rgba:
			sliderValue1.setValue(Float(currentColor.redComponent), animated: false)
			sliderValue2.setValue(Float(currentColor.greenComponent), animated: false)
			sliderValue3.setValue(Float(currentColor.blueComponent), animated: false)
			sliderAlpha.setValue(Float(currentColor.alphaComponent), animated: false)
			
			labelValue1.text = "赤"
			labelValue2.text = "緑"
			labelValue3.text = "青"
		case .hsba:
			sliderValue1.setValue(Float(currentColor.hueComponent), animated: false)
			sliderValue2.setValue(Float(currentColor.saturationComponent), animated: false)
			sliderValue3.setValue(Float(currentColor.brightnessComponent), animated: false)
			sliderAlpha.setValue(Float(currentColor.alphaComponent), animated: false)
			
			labelValue1.text = "色相"
			labelValue2.text = "彩度"
			labelValue3.text = "明度"
		default:
			fatalError()
		}
		
		setupValue1Slider()
		setupValue2Slider()
		setupValue3Slider()
		setupAlphaSlider()
		
		onChangeColor()
		
		self.layoutBottom.constant = -self.frame.height
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
			self.layoutBottom.constant = 0

			UIView.animate(withDuration: 0.3) {
				self.layoutIfNeeded()
			}
		}
	}
}

extension ColorPickerView {
	fileprivate func setupValue1Slider() {
		let layerGradient = CAGradientLayer()
		let frame = CGRect.init(x:0, y:0, width: sliderValue1.frame.width, height: sliderTrackHeight)
		layerGradient.frame = CGRect(x: 0, y: 0, width: sliderAlpha.frame.width - 1, height: sliderTrackHeight - 1)
		
		switch colorStyle {
		case .rgba:
			layerGradient.colors = [UIColor(red: 0, green: value2, blue: value3, alpha: 1).cgColor,
									UIColor(red: 1, green: value2, blue: value3, alpha: 1).cgColor]
		case .hsba:
			var colors: [CGColor] = []
			
			for i in 0...20 {
				let hue = 0.05 * CGFloat(i)
				colors.append(UIColor(hue: hue, saturation: value2, brightness: value3, alpha: 1).cgColor)
			}
			
			layerGradient.colors = colors
		default:
			fatalError()
		}
		
		layerGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
		layerGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		
		let rectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: sliderValue1.frame.width, height: sliderTrackHeight))
		UIColor.lightGray.setStroke()
		rectangle.lineWidth = 0.5
		rectangle.stroke()
		
		UIGraphicsGetCurrentContext()!.translateBy(x: 0.5, y: 0.5)
		layerGradient.render(in: UIGraphicsGetCurrentContext()!)
		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			self.sliderValue1.setMaximumTrackImage(image, for: .normal)
			self.sliderValue1.setMinimumTrackImage(image, for: .normal)
		}
	}
	
	fileprivate func setupValue2Slider() {
		let layerGradient = CAGradientLayer()
		let frame = CGRect.init(x:0, y:0, width: sliderValue2.frame.width, height: sliderTrackHeight)
		layerGradient.frame = CGRect(x: 0, y: 0, width: sliderAlpha.frame.width - 1, height: sliderTrackHeight - 1)
		
		switch colorStyle {
		case .rgba:
			layerGradient.colors = [UIColor(red: value1, green: 0, blue: value3, alpha: 1).cgColor,
									UIColor(red: value1, green: 1, blue: value3, alpha: 1).cgColor]
		case .hsba:
			layerGradient.colors = [UIColor(hue: value1, saturation: 0, brightness: value3, alpha: 1).cgColor,
									UIColor(hue: value1, saturation: 1, brightness: value3, alpha: 1).cgColor]
		default:
			fatalError()
		}
		
		layerGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
		layerGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		
		let rectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: sliderValue1.frame.width, height: sliderTrackHeight))
		UIColor.lightGray.setStroke()
		rectangle.lineWidth = 0.5
		rectangle.stroke()
		
		UIGraphicsGetCurrentContext()!.translateBy(x: 0.5, y: 0.5)
		layerGradient.render(in: UIGraphicsGetCurrentContext()!)
		
		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			self.sliderValue2.setMaximumTrackImage(image, for: .normal)
			self.sliderValue2.setMinimumTrackImage(image, for: .normal)
		}
	}
	
	fileprivate func setupValue3Slider() {
		let layerGradient = CAGradientLayer()
		let frame = CGRect.init(x:0, y:0, width: sliderValue3.frame.width, height: sliderTrackHeight)
		layerGradient.frame = CGRect(x: 0, y: 0, width: sliderAlpha.frame.width - 1, height: sliderTrackHeight - 1)
		
		switch colorStyle {
		case .rgba:
			layerGradient.colors = [UIColor(red: value1, green: value2, blue: 0, alpha: 1).cgColor,
									UIColor(red: value1, green: value2, blue: 1, alpha: 1).cgColor]
		case .hsba:
			layerGradient.colors = [UIColor(hue: value1, saturation: value2, brightness: 0, alpha: 1).cgColor,
									UIColor(hue: value1, saturation: value2, brightness: 1, alpha: 1).cgColor]
		default:
			fatalError()
		}
		
		layerGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
		layerGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		let rectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: sliderValue1.frame.width, height: sliderTrackHeight))
		UIColor.lightGray.setStroke()
		rectangle.lineWidth = 0.5
		rectangle.stroke()
		
		UIGraphicsGetCurrentContext()!.translateBy(x: 0.5, y: 0.5)
		layerGradient.render(in: UIGraphicsGetCurrentContext()!)

		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			self.sliderValue3.setMaximumTrackImage(image, for: .normal)
			self.sliderValue3.setMinimumTrackImage(image, for: .normal)
		}
	}
	
	fileprivate func setupAlphaSlider() {
		let layerGradient = CAGradientLayer()
		let frame = CGRect(x: 0, y: 0, width: sliderAlpha.frame.width, height: sliderTrackHeight)
		layerGradient.frame = CGRect(x: 0, y: 0, width: sliderAlpha.frame.width - 1, height: sliderTrackHeight - 1)

		layerGradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
								UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]

		
		layerGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
		layerGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
		
		let rectangle = UIBezierPath(rect: CGRect(x: 0, y: 0, width: sliderValue1.frame.width, height: sliderTrackHeight))
		UIColor.lightGray.setStroke()
		rectangle.lineWidth = 0.5
		rectangle.stroke()
		
		UIGraphicsGetCurrentContext()!.translateBy(x: 0.5, y: 0.5)
		layerGradient.render(in: UIGraphicsGetCurrentContext()!)
		
		if let image = UIGraphicsGetImageFromCurrentImageContext() {
			UIGraphicsEndImageContext()
			
			self.sliderAlpha.setMaximumTrackImage(image, for: .normal)
			self.sliderAlpha.setMinimumTrackImage(image, for: .normal)
		}
	}
	
	fileprivate func onChangeColor() {
		switch colorStyle {
		case .rgba:
			viewSelecting.backgroundColor = UIColor(red: value1, green: value2, blue: value3, alpha: colorAlpha)
			sliderValue1.thumbTintColor = UIColor(red: value1, green: value2, blue: value3, alpha: colorAlpha)
			sliderValue2.thumbTintColor = UIColor(red: value1, green: value2, blue: value3, alpha: colorAlpha)
			sliderValue3.thumbTintColor = UIColor(red: value1, green: value2, blue: value3, alpha: colorAlpha)
		case .hsba:
			viewSelecting.backgroundColor = UIColor(hue: value1, saturation: value2, brightness: value3, alpha: colorAlpha)
			sliderValue1.thumbTintColor = UIColor(hue: value1, saturation: value2, brightness: value3, alpha: colorAlpha)
			sliderValue2.thumbTintColor = UIColor(hue: value1, saturation: value2, brightness: value3, alpha: colorAlpha)
			sliderValue3.thumbTintColor = UIColor(hue: value1, saturation: value2, brightness: value3, alpha: colorAlpha)
		default:
			fatalError()
		}
	}
}

// MARK: - Button
extension ColorPickerView {
	@IBAction fileprivate func onTouchCancel(_ sender: UIButton) {
		self.removeFromSuperview()
	}
	
	@IBAction fileprivate func onTouchDone(_ sender: UIButton) {
		delegate?.colorPickerView(self, picked: viewSelecting.backgroundColor!)
		self.removeFromSuperview()
	}
}

// MARK: - Slider
extension ColorPickerView {
	@IBAction fileprivate func onSlideValue1(_ sender: UISlider) {
		setupValue2Slider()
		setupValue3Slider()
		
		onChangeColor()
	}
	
	@IBAction fileprivate func onSlideValue2(_ sender: UISlider) {
		setupValue1Slider()
		setupValue3Slider()
		
		onChangeColor()
	}
	
	@IBAction fileprivate func onSlideValue3(_ sender: UISlider) {
		setupValue1Slider()
		setupValue2Slider()
		
		onChangeColor()
	}
	
	@IBAction fileprivate func onSlideAlpha(_ sender: UISlider) {
		onChangeColor()
	}
}

extension UIColor {
	var redComponent: CGFloat {
		return rgbaComponent(at: 0)
	}
	
	var greenComponent: CGFloat {
		return rgbaComponent(at: 1)
	}

	var blueComponent: CGFloat {
		return rgbaComponent(at: 2)
	}
	
	var alphaComponent: CGFloat {
		return rgbaComponent(at: 3)
	}

	private func rgbaComponent(at index: Int) -> CGFloat {
		var red: CGFloat = -1
		var green: CGFloat = -1
		var blue: CGFloat = -1
		var alpha: CGFloat = -1

		getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		let rgba: [CGFloat] = [red, green, blue, alpha]

		return rgba[index]
	}

	var hueComponent: CGFloat {
		return hsbComponent(at: 0)
	}

	var saturationComponent: CGFloat {
		return hsbComponent(at: 1)
	}

	var brightnessComponent: CGFloat {
		return hsbComponent(at: 2)
	}

	private func hsbComponent(at index: Int) -> CGFloat {
		var hue: CGFloat = -1
		var saturation: CGFloat = -1
		var brightness: CGFloat = -1
		var alpha: CGFloat = -1

		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

		let hsb: [CGFloat] = [hue, saturation, brightness]

		return hsb[index]
	}
}
