//
//  WindowAccessor.swift
//
//
//  Created by Bean John on 14/3/2024.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import SwiftUI

#if canImport(AppKit)
typealias OSWindow = NSWindow
#elseif canImport(UIKit)
typealias OSWindow = UIWindow
#endif

struct WindowAccessor: NSViewRepresentable {
	
	@Binding var window: OSWindow?
	
	func makeNSView(context: Context) -> NSView {
		let view = NSView()
		DispatchQueue.main.async {
			self.window = view.window
		}
		return view
	}
	
	func updateNSView(_ nsView: NSView, context: Context) {}
}
