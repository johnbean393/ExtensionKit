//
//  Scene.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import SwiftUI

#if os(macOS)
extension Scene {
	
	@available(macOS 12, *)
	public func windowResizabilityContentSize() -> some Scene {
		if #available(macOS 13.0, *) {
			return windowResizability(.contentSize)
		} else {
			return self
		}
	}
	
	@available(macOS 12, *)
	public func defaultPositionTopLeading() -> some Scene {
		if #available(macOS 13.0, *) {
			return defaultPosition(.topLeading)
		} else {
			return self
		}
	}
	
	@available(macOS 12, *)
	public func defaultPositionCenter() -> some Scene {
		if #available(macOS 13.0, *) {
			return defaultPosition(.center)
		} else {
			return self
		}
	}
	
}
#endif
