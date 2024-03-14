//
//  XDRBoostModifier.swift
//
//
//  Created by Bean John on 14/3/2024.
//

#if os(macOS)
import Foundation
import AppKit
import SwiftUI

extension View {
	
	public func xdrBoost(initMsg: String = "XDR") -> some View {
		ModifiedContent(content: self, modifier: XDRBoostModifier(initMsg: initMsg))
	}
	
}

struct XDRBoostModifier: ViewModifier {
	
	@State private var nsWindow: NSWindow?
	
	var initMsg: String
	
	func body(content: Content) -> some View {
		return content
			.background(WindowAccessor(window: $nsWindow))
			.onAppear {
				startXdr()
			}
	}
	
	private func startXdr() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
			if let view = nsWindow?.contentView {
				// The MTKView instance
				var metalView: MetalView!
				metalView = MetalView(frame: view.bounds, frameRate: 1, contrast: 1.0, brightness: 1.0, initMsg: initMsg)
				metalView.autoresizingMask = [.width, .height]
				view.addSubview(metalView)
			} else {
				startXdr()
			}
		}
	}
	
}
#endif
