//
//  Int.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

extension Int {
	
	// Add leading zeros to an integer
	func addLeadingZeros(target: Int = 2) -> String {
		return String(repeating: "0", count: target - String(self).count) + String(self)
	}
	
}
