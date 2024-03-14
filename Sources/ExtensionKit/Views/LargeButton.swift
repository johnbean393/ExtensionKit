//
//  LargeButton.swift
//
//
//  Created by Bean John on 12/3/2024.
//

import SwiftUI

struct LargeButton: View {

	init(_ label: String, color: Color = Color.accentColor, action: @escaping () -> Void) {
		self.label = label
		self.color = color
		self.action = action
	}
	
	init(label: String, color: Color = Color.accentColor, action: @escaping () -> Void) {
		self.label = label
		self.color = color
		self.action = action
	}
	
	var label: String
	var color: Color
	var action: () -> Void
	
	var body: some View {
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
