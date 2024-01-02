//
//  View.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

extension View {
	
	@ViewBuilder public func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
		if conditional {
			content(self)
		} else {
			self
		}
	}
	
}

