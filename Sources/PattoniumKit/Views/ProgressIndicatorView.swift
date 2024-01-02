//
//  ProgressIndicatorView.swift
//
//
//  Created by Bean John on 2/1/2024.
//

import SwiftUI

public struct ProgressIndicatorView: View {
	
	public init(arr: [Any], switchOnTap: Bool = true, index: Binding<Int>) {
		self.arr = arr
		self.switchOnTap = switchOnTap
		self._index = index
	}
	
	public var arr: [Any]
	public var switchOnTap: Bool
	@Binding var index: Int
	
	public var body: some View {
		HStack(spacing: 7) {
			ForEach(0..<arr.count, id: \.self) { currIndex in
				Circle()
					.frame(width: 10)
					.foregroundStyle(Color.white)
					.scaleEffect(index == currIndex ? 1.4 : 1.0)
					.onTapGesture {
						if switchOnTap {
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
		switchOnTap: false,
		index: .constant(0)
	)
}
