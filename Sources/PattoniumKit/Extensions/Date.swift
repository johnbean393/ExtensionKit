//
//  Date.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

extension Date {
	
	static public func - (lhs: Date, rhs: Date) -> TimeInterval {
		return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
	}
	
}
