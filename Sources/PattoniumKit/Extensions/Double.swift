//
//  Double.swift
//
//
//  Created by Bean John on 28/12/2023.
//

import Foundation

extension Double {
	
	// Add zeros to a double
	public func addZeros(wholeNumTarget: Int = -1, fractionalTarget: Int = -1) -> String {
		// Get whole number with leading zeros
		let wholeNum: Int = Int(self)
		var wholeNumStr: String = String(wholeNum)
		if wholeNumTarget != -1 {
			wholeNumStr = String(repeating: "0", count: wholeNumTarget - String(wholeNum).count) + String(wholeNum)
		}
		// Get fraction with leading zeros
		let rawFractionalStr: String = String(self.description.split(separator: ".").last ?? "0")
		var fractionalStr: String = rawFractionalStr
		if fractionalTarget != -1 {
			fractionalStr = rawFractionalStr + String(repeating: "0", count: fractionalTarget - rawFractionalStr.count)
		}
		return "\(wholeNumStr).\(fractionalStr)"
	}
	
}
