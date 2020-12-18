//
//  ProjectName  : ColorPicker
//  File Name    : UIColor+Extension.swift
//  Created Date : 2020/12/18
//  
//  Copyright © 2019-2020 KC Apps. All rights reserved.
//

import UIKit

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
