//
//  LargeButton.swift
//
//
//  Created by Bean John on 12/3/2024.
//

import SwiftUI

public struct LargeButton: View {

	public init(_ label: String, color: Color = Color.accentColor, action: @escaping () -> Void) {
		self.label = label
		self.color = color
		self.action = action
	}
	
	public init(label: String, color: Color = Color.accentColor, action: @escaping () -> Void) {
		self.label = label
		self.color = color
		self.action = action
	}
	
	public var label: String
	public var color: Color
	public var action: () -> Void
	
	public var body: some View {
		Text(label)
			.bold()
			.padding(8)
			.background {
				RoundedRectangle(cornerRadius: 8)
					.fill(color)
			}
			.padding()
			.onTapGesture {
				action()
			}
	}
	
}

#Preview {
	LargeButton("Press Me") {
		print("Pressed")
	}
}
