//
//  ColorPicker.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

@available(iOS 16, macOS 13.0, *)
public struct ColorPicker: View {
	
	public init(colors: [Color] = [Color.red, Color.orange, Color.green, Color.blue, Color.purple, Color.pink], lineColor: Binding<Color>) {
		self.colors = colors
		self._lineColor = lineColor
	}
	
	public var colors: [Color] = [Color.red, Color.orange, Color.green, Color.blue, Color.purple, Color.pink]
	@Binding var lineColor: Color
	
	public var body: some View {
		HStack {
			
			ForEach(colors, id: \.self) { color in
				Image(systemName: lineColor == color ? Constants.Icons.recordCircleFill : Constants.Icons.circleFill)
					.foregroundStyle(color)
					.font(.system(size: 19))
					.background(Circle().foregroundStyle(Color.white))
					.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
					.onTapGesture {
						lineColor = color
					}
			}
			
		}
		.padding(5)
		.background {
			RoundedRectangle(cornerRadius: 11)
				.foregroundStyle(Color.secondary)
				.opacity(0.7)
		}
	}
}

private struct Constants {
	
	struct Icons {
		static let plusCircle = "plus.circle"
		static let line3HorizontalCircleFill = "line.3.horizontal.circle.fill"
		static let circle = "circle"
		static let circleInsetFilled = "circle.inset.filled"
		static let exclaimationMarkCircle = "exclamationmark.circle"
		static let recordCircleFill = "record.circle.fill"
		static let trayCircleFill = "tray.circle.fill"
		static let circleFill = "circle.fill"
	}
	
}

#Preview {
	if #available(iOS 16, macOS 13, *) {
		ColorPicker(lineColor: .constant(Color.blue))
	} else {
		// Fallback on earlier versions
		Text("Update your dang OS!")
	}
}
