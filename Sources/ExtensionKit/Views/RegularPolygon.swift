//
//  SwiftUIView.swift
//  
//
//  Created by Bean John on 29/3/2024.
//

import SwiftUI

public struct RegularPolygon: Shape {
	
	var sides: Int
	
	public func path(in rect: CGRect) -> Path {
		var path: Path = Path()
		let limitingEdge: CGFloat = min(rect.width, rect.height)
		var radius: CGFloat = limitingEdge / 2
		let center: CGPoint = CGPoint(
			x: rect.midX,
			y: rect.midY
		)
		let angles: [Angle] = Array(1...sides).map({ Angle(degrees: Double($0) * 360.0 / Double(sides) + 180) })
		let rawPoints: [CGPoint] = angles.map { angle in
			let xOffset: CGFloat = sin(angle.radians) * radius
			let yOffset: CGFloat = cos(angle.radians) * radius
			return CGPoint(x: xOffset + center.x, y: yOffset + center.y)
		}
		let lowestY: CGFloat = rawPoints.map({ $0.y }).max()!
		let yOffset: CGFloat = (rect.maxY - lowestY) / 2
		let points: [CGPoint] = rawPoints.map { point in
			return CGPoint(x: point.x, y: point.y + yOffset)
		}
		path.move(to: points.first!)
		for (index, point) in Array(points.dropFirst()).enumerated() {
			path.addLine(to: point)
		}
		path.closeSubpath()
		return path
	}
	
}
