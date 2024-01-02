//
//  Date.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

extension Date {
	
	public init(month: Int, day: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
		var dateComponents = DateComponents()
		dateComponents.month = month
		dateComponents.day = day
		dateComponents.year = year
		dateComponents.hour = hour
		dateComponents.minute = minute
		dateComponents.second = second
		dateComponents.timeZone = .current
		dateComponents.calendar = .current
		self = Calendar.current.date(from: dateComponents) ?? Date()
	}
	
	static public func - (lhs: Date, rhs: Date) -> TimeInterval {
		return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
	}
	
}
