//
//  XDRBoostModifier.swift
//
//
//  Created by Bean John on 14/3/2024.
//

import Foundation
import SwiftUI

extension View {
	
	public func xdrBoost() -> some View {
		ModifiedContent(content: self, modifier: XDRBoostModifier())
	}
	
}

struct XDRBoostModifier: ViewModifier {
	
	@State private var nsWindow: NSWindow?
	
	func body(content: Content) -> some View {
		return content
			.background(WindowAccessor(window: $nsWindow))
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
					if let view = nsWindow?.contentView {
						// The MTKView instance
						var metalView: MetalView!
						metalView = MetalView(frame: view.bounds, frameRate: 1, contrast: 1.0, brightness: 1.0)
						metalView.autoresizingMask = [.width, .height]
						view.addSubview(metalView)
					}
				}
			}
	}
	
}
