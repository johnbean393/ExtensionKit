//
//  WindowAccessor.swift
//
//
//  Created by Bean John on 14/3/2024.
//

import Foundation
import AppKit
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
	
	@Binding var window: NSWindow?
	
	func makeNSView(context: Context) -> NSView {
		let view = NSView()
		DispatchQueue.main.async {
			self.window = view.window
		}
		return view
	}
	
	func updateNSView(_ nsView: NSView, context: Context) {}
}
