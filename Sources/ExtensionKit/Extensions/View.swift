//
//  View.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

extension View {
	
	@ViewBuilder public func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
		if conditional {
			content(self)
		} else {
			self
		}
	}
	
	func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
		self
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
	}
	
}
