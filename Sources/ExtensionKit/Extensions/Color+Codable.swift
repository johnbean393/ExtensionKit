//
//  Color+Codable.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

#if os(iOS)
typealias PlatformColor = UIColor
extension Color {
	init(platformColor: PlatformColor) {
		self.init(uiColor: platformColor)
	}
}
#elseif os(macOS)
typealias PlatformColor = NSColor
extension Color {
	init(platformColor: PlatformColor) {
		self.init(nsColor: platformColor)
	}
}
#endif

let color = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)

func encodeColor() throws -> Data {
	let platformColor = PlatformColor(color)
	return try NSKeyedArchiver.archivedData(
		withRootObject: platformColor,
		requiringSecureCoding: true
	)
}

func decodeColor(from data: Data) throws -> Color {
	guard let platformColor = try NSKeyedUnarchiver
		.unarchiveTopLevelObjectWithData(data) as? PlatformColor
	else {
		throw DecodingError.wrongType
	}
	return Color(platformColor: platformColor)
}

enum DecodingError: Error {
	case wrongType
}
