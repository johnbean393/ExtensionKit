//
//  ChevronButton.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

public struct ChevronButton: View {
	
	public var direction: ArrowDirection
	
	public var body: some View {
		Circle()
			.frame(width: 30)
			.foregroundStyle(.secondary)
			.overlay {
				Image(systemName: "chevron.\(direction.rawValue)")
					.shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
					.foregroundStyle(Color.white)
			}
	}
	
}

public enum ArrowDirection: String, CaseIterable {
	case up, down, left, right
}

#Preview {
	ChevronButton(direction: .right)
}
