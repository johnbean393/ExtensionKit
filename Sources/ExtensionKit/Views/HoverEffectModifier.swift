//
//  File.swift
//  
//
//  Created by Bean John on 12/3/2024.
//

import Foundation
import SwiftUI

extension View {
	
	public func glowOnHover(
		animateIn: Double = 0.5,
		color: Color = Color.accentColor,
		radius: CGFloat = 10
	) -> some View {
		ModifiedContent(content: self, modifier: HoverEffectModifier(animateIn: animateIn, glowColor: color, glowRadius: radius))
	}
	
}

struct HoverEffectModifier: ViewModifier {
	
	var animateIn: Double
	var glowColor: Color
	var glowRadius: CGFloat
	@State private var isHovering: Bool = false
	
	func body(content: Content) -> some View {
		return Group {
			if isHovering {
				content
					.shadow(color: glowColor, radius: glowRadius / 3)
					.shadow(color: glowColor, radius: glowRadius / 3)
					.shadow(color: glowColor, radius: glowRadius / 3)
					.onHover { hovering in
						if isHovering != hovering {
							withAnimation(.smooth(duration: animateIn)) {
								isHovering = hovering
							}
						}
					}
			} else {
				content
					.onHover { hovering in
						if isHovering != hovering {
							withAnimation(.smooth(duration: animateIn)) {
								isHovering = hovering
							}
						}
					}
			}
		}
	}
	
}

