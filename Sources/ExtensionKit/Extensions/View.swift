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
	
	public func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
		self
			.overlay(self.blur(radius: radius / 6))
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
			.shadow(color: color, radius: radius / 3)
	}
	
	public func innerShadow<S: Shape>(using shape: S, angle: Angle = .degrees(0), color: Color = .black, width: CGFloat = 6, blur: CGFloat = 6) -> some View {
		let finalX = CGFloat(cos(angle.radians - .pi / 2))
		let finalY = CGFloat(sin(angle.radians - .pi / 2))
		return self
			.overlay(
				shape
					.stroke(color, lineWidth: width)
					.offset(x: finalX * width * 0.6, y: finalY * width * 0.6)
					.blur(radius: blur)
					.mask(shape)
			)
	}
	
}
