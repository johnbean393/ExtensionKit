//
//  ProgressIndicatorView.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

public struct ProgressIndicatorView: View {
	
	public var arr: [Any]
	public var switchOnTapp: Bool
	@Binding var index: Int
	
	public var body: some View {
		HStack(spacing: 7) {
			ForEach(0..<arr.count, id: \.self) { currIndex in
				Circle()
					.frame(width: 10)
					.foregroundStyle(Color.white)
					.scaleEffect(index == currIndex ? 1.4 : 1.0)
					.onTapGesture {
						if switchOnTapp {
							withAnimation(.spring()) {
								index = currIndex
							}
						}
					}
				
			}
		}
		.padding(6)
		.background(Capsule().foregroundStyle(Color.gray))
	}
}

#Preview {
	ProgressIndicatorView(
		arr: [0, 1, 2, 3, 4],
		switchOnTapp: false,
		index: .constant(0)
	)
}
