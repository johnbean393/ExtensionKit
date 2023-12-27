//
//  Scene.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import SwiftUI

extension Scene {
	
	@available(macOS 12, *)
	func windowResizabilityContentSize() -> some Scene {
		if #available(macOS 13.0, *) {
			return windowResizability(.contentSize)
		} else {
			return self
		}
	}
	
	@available(macOS 12, *)
	func defaultPositionTopLeading() -> some Scene {
		if #available(macOS 13.0, *) {
			return defaultPosition(.topLeading)
		} else {
			return self
		}
	}
	
	@available(macOS 12, *)
	func defaultPositionCenter() -> some Scene {
		if #available(macOS 13.0, *) {
			return defaultPosition(.center)
		} else {
			return self
		}
	}
	
}
