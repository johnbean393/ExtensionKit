//
//  Color+Codable.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

extension Color {
	static func fromString(_ colorStr: String) -> Color {
		/***
		 Meant to be used as a return to Color after storing a color using Color.description
		 from Color.'enum'.description - for example Color.pink.description = "pink"
		 or if you assign a 'var' to Color.pink, var.description = "pink"
		 -or-
		 from Color.description format of "#xxxxxxxx"
		 -or-
		 from a return of ColorPicker with the following starting values split by spaces
		 UIExtendedSRGBColorSpace (5 values)
		 kCGColorSpaceModelMonochrome (3 values)
		 kCGColorSpaceModelRGB (5 values)
		 kCGColorSpaceModelCMYK (6 values)
		 where values are separated by spaces
		 */
		var red = 0.8, green = 0.8, blue = 0.8, opacity = 1.0 //defaults to gray on errors
		switch colorStr {
				//Color enums
			case "black": return Color.black
			case "blue": return Color.blue
			case "brown": return Color.brown
			case "clear": return Color.clear
			case "cyan": return Color.cyan
			case "gray": return Color.gray
			case "green": return Color.green
			case "indigo": return Color.indigo
			case "mint": return Color.mint
			case "orange": return Color.orange
			case "pink": return Color.pink
			case "purple": return Color.purple
			case "red": return Color.red
			case "teal": return Color.teal
			case "white": return Color.white
			case "yellow": return Color.yellow
			default:
				
				if (colorStr.count == 9) && (colorStr.first == "#") {
					//Color.description from Color(red:green:blue:opacity)
					red = Double(UInt32(String(Array(colorStr)[1...2]), radix: 16) ?? 0) / 255.0
					green = Double(UInt32(String(Array(colorStr)[3...4]), radix: 16) ?? 0) / 255.0
					blue = Double(UInt32(String(Array(colorStr)[5...6]), radix: 16) ?? 0) / 255.0
					opacity = Double(UInt32(String(Array(colorStr)[7...8]), radix: 16) ?? 0) / 255.0
				} else {
					let values = colorStr.split(separator: " ")
					if values.count == 6 {
						//CMYK - Not an exact match, but ok for choosing control colors
						let cyan = (1.0 - (Double(values[1]) ?? 0.0))
						let magenta = (1.0 - (Double(values[2]) ?? 0.0))
						let yellow = (1.0 - (Double(values[3]) ?? 0.0))
						let black = (1.0 - (Double(values[4]) ?? 0.0))
						red = (cyan * black)
						green = (magenta * black)
						blue = (yellow * black)
						opacity = (Double(values[5]) ?? 0.0)
					} else {
						if values.count == 3 {
							//Monochrome
							red = (Double(values[1]) ?? 0.0)
							green = red
							blue = red
							opacity = (Double(values[2]) ?? 0.0)
						} else {
							if values.count == 5 {
								//RGB
								red = (Double(values[1]) ?? 0.0)
								green = (Double(values[2]) ?? 0.0)
								blue = (Double(values[3]) ?? 0.0)
								opacity = (Double(values[4]) ?? 0.0)
							}
						}
					}
				}
				return Color(red: red, green: green, blue: blue, opacity: opacity)
				
		}
	}
}
