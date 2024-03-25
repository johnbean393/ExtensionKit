//
//  LoupeModifier.swift
//
//
//  Created by Bean John on 25/3/2024.
//

import Foundation
import SwiftUI

@available(macOS 14.0, iOS 17.0, *)
extension View {
	
	public func loupe() -> some View {
		ModifiedContent(content: self, modifier: LoupeModifier())
	}
	
}

@available(macOS 14.0, iOS 17.0, *)
struct LoupeModifier: ViewModifier {
	
	@State private var touch: CGPoint = CGPoint(x: -1000, y: -1000)
	@State private var isHovering: Bool = false
	
	func body(content: Content) -> some View {
		return content
			.visualEffect { ui, geometryProxy in
				ui
					.layerEffect(
						ShaderLibrary.loupe(
							.float2(geometryProxy.size),
							.float2(touch)
						),
						maxSampleOffset: .zero,
						isEnabled: isHovering
					)
			}
			.gesture(
				DragGesture(minimumDistance: 0)
					.onChanged({ touch = $0.location })
			)
			.onHover { hovering in
				isHovering = hovering
			}
	}
	
}

