//
//  File.swift
//  
//
//  Created by Bean John on 12/3/2024.
//

import Foundation
import SwiftUI

extension View {
	
	func glowOnHover(
		color: Color = Color.accentColor,
		radius: CGFloat = 10
	) -> some View {
		ModifiedContent(content: self, modifier: HoverEffectModifier(glowColor: color, glowRadius: radius))
	}
	
}

struct HoverEffectModifier: ViewModifier {
	
	var glowColor: Color
	var glowRadius: CGFloat
	@State private var isHovering: Bool = false
	
	func body(content: Content) -> some View {
		return Group {
			if isHovering {
				content
					.glow(color: glowColor, radius: glowRadius)
					.onHover { hovering in
						isHovering = hovering
					}
			} else {
				content
					.onHover { hovering in
						isHovering = hovering
					}
			}
		}
	}
	
}

