//
//  WindowModifier.swift
//
//
//  Created by Bean John on 14/3/2024.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Unsupported platform")
#endif
import SwiftUI
import Foundation

#if canImport(UIKit)
typealias Window = UIWindow
#elseif canImport(AppKit)
typealias Window = NSWindow
#else
#error("Unsupported platform")
#endif


class WindowObserver: ObservableObject {
	
	@Published
	public private(set) var isKeyWindow: Bool = false
	
	private var becomeKeyobserver: NSObjectProtocol?
	private var resignKeyobserver: NSObjectProtocol?
	
	weak var window: Window? {
		didSet {
			self.isKeyWindow = window?.isKeyWindow ?? false
			guard let window = window else {
				self.becomeKeyobserver = nil
				self.resignKeyobserver = nil
				return
			}
			
			self.becomeKeyobserver = NotificationCenter.default.addObserver(
				forName: Window.didBecomeKeyNotification,
				object: window,
				queue: .main
			) { (n) in
				self.isKeyWindow = true
			}
			
			self.resignKeyobserver = NotificationCenter.default.addObserver(
				forName: Window.didResignKeyNotification,
				object: window,
				queue: .main
			) { (n) in
				self.isKeyWindow = false
			}
		}
	}
}

extension EnvironmentValues {
	struct IsKeyWindowKey: EnvironmentKey {
		static var defaultValue: Bool = false
		typealias Value = Bool
	}
	
	fileprivate(set) var isKeyWindow: Bool {
		get {
			self[IsKeyWindowKey.self]
		}
		set {
			self[IsKeyWindowKey.self] = newValue
		}
	}
}

struct WindowObservationModifier: ViewModifier {
	
	@StateObject var windowObserver: WindowObserver = WindowObserver()
	
	func body(content: Content) -> some View {
		content.background(
			HostingWindowFinder { [weak windowObserver] window in
				windowObserver?.window = window
			}
		).environment(\.isKeyWindow, windowObserver.isKeyWindow)
	}
}

#if canImport(UIKit)
struct HostingWindowFinder: UIViewRepresentable {
	var callback: (Window?) -> ()
	
	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		DispatchQueue.main.async { [weak view] in
			self.callback(view?.window)
		}
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
	}
}
#elseif canImport(AppKit)
struct HostingWindowFinder: NSViewRepresentable {
	var callback: (Window?) -> ()
	
	func makeNSView(context: Self.Context) -> NSView {
		let view = NSView()
		view.translatesAutoresizingMaskIntoConstraints = false
		DispatchQueue.main.async { [weak view] in
			self.callback(view?.window)
		}
		return view
	}
	func updateNSView(_ nsView: NSView, context: Context) {}
}
#else
#error("Unsupported platform")
#endif

extension View {
	
	public func window() -> some View {
		ModifiedContent(content: self, modifier: WindowObservationModifier())
	}
	
}
