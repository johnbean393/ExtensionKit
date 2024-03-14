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
typealias OSView = NSView
typealias OSViewRepresentable = NSViewRepresentable
#elseif canImport(UIKit)
typealias OSWindow = UIWindow
typealias OSView = UIView
typealias OSViewRepresentable = UIViewRepresentable
#endif

struct WindowAccessor: OSViewRepresentable {
	
	@Binding var window: OSWindow?
	
	#if os(macOS)
	func makeNSView(context: Context) -> OSView {
		let view = OSView()
		DispatchQueue.main.async {
			self.window = view.window
		}
		return view
	}
	
	func updateNSView(_ nsView: OSView, context: Context) {}
	#elseif os(iOS)
	func makeUIView(context: Context) -> OSView {
		let view = OSView()
		DispatchQueue.main.async {
			self.window = view.window
		}
		return view
	}
	
	func updateUIView(_ nsView: OSView, context: Context) {}
	#endif
}
