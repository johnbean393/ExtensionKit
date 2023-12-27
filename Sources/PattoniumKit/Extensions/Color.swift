//
//  Color.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import SwiftUI

extension Color {
	
	// Get intermediate color
	@available(macOS 14, iOS 17, *)
	func incrementColor(toColor: Color, percentage: Float) -> Color {
		let environment = EnvironmentValues()
		let redDiff: Float = (toColor.resolve(in: environment).red - self.resolve(in: environment).red) * percentage
		let greenDiff: Float = (toColor.resolve(in: environment).green - self.resolve(in: environment).green) * percentage
		let blueDiff: Float = (toColor.resolve(in: environment).blue - self.resolve(in: environment).blue) * percentage
		let redVal: Float = self.resolve(in: environment).red + redDiff
		let greenVal: Float = self.resolve(in: environment).green + greenDiff
		let blueVal: Float = self.resolve(in: environment).blue + blueDiff
		return Color(red: Double(redVal), green: Double(greenVal), blue: Double(blueVal))
	}
	
}
