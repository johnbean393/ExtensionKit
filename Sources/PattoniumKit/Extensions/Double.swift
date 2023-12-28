//
//  Double.swift
//
//
//  Created by Bean John on 28/12/2023.
//

import Foundation

extension Double {
	
	// Add zeros to a double
	public func addZeros(wholeNumTarget: Int, fractionalTarget: Int) -> String {
		// Get whole number with leading zeros
		let wholeNum: Int = Int(self)
		let wholeNumStr: String = String(repeating: "0", count: wholeNumTarget - String(wholeNum).count) + String(wholeNum)
		// Get fraction with leading zeros
		let rawFractionalStr: String = String(self.description.split(separator: ".").last ?? "0")
		let fractionalStr: String = rawFractionalStr + String(repeating: "0", count: fractionalTarget - rawFractionalStr.count)
		return "\(wholeNumStr).\(fractionalStr)"
	}
	
}
