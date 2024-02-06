//
//  DBSCAN.swift
//
//
//  Created by Bean John on 7/2/2024.
//

import Foundation

public class DBSCAN<Value: Hashable> {
	
	public var id: [UUID]
	public var data: [Value]
	public var label: [Value: String]
	
	public init(id: [UUID], data: [Value])  {
		self.id = id
		self.data = data
		self.label = [Value: String]()
		for point in self.data {
			self.label[point] = "undefined"
		}
		
	}
	
	public func cluster(distance: (Value, Value) -> Double, epsilon: Double, minPoints: Int) {
		
		var count: Int = 0
		
		for point in self.data {
			
			if self.label[point] != "undefined" {
				continue
			}
			
			var neighbours: [Value] = self.rangeQuery(distance: distance, neighbour: point, epsilon: epsilon)
			
			if neighbours.count < minPoints  {
				
				self.label[point] = "noise"
				continue
			}
			
			count += 1
			
			self.label[point] = "\(count)"
			
			for neighbour in neighbours {
				
				if self.label[neighbour] == "noise" {
					self.label[neighbour] = "\(count)"
				}
				
				if self.label[neighbour] != "undefined" {
					continue
				}
				
				label[neighbour] = "\(count)"
				
				let furtherNeighbours: [Value] = self.rangeQuery(distance: distance, neighbour: neighbour, epsilon: epsilon)
				
				if furtherNeighbours.count >= minPoints  {
					neighbours.append(contentsOf:  furtherNeighbours)
					continue
				}
			}
		}
	}
	
	private func rangeQuery(distance: (Value, Value) -> Double, neighbour: Value, epsilon: Double) -> [Value] {
		
		var neighbors = [Value]()
		for point in self.data {
			if distance(neighbour, point) <= epsilon {
				neighbors.append(point)
			}
		}
		return neighbors
		
	}
	
}

// Example use

//let input: [[Double]] = [
//	[0, 10, 20],
//	[0, 11, 21],
//	[0, 12, 20],
//	[20, 33, 59],
//	[21, 32, 56],
//	[59, 77, 101],
//	[58, 79, 100],
//	[58, 76, 102],
//	[300, 70, 20],
//	[500, 300, 202],
//	[500, 302, 204]
//]

// Define distance func
//func euclideanDistance(first: [Double], second: [Double]) -> Double  {
//	guard first.count == second.count else {
//		fatalError("Vector space is not the same")
//	}
//	var result: Double = 0
//	for i in 0..<first.count {
//		result += pow(first[i] - second[i], 2.0)
//	}
//	return sqrt(result)
//}

// Init object
//let dbScan: DBSCAN = DBSCAN(data: input)
// Run cluster
//dbScan.cluster(distance: euclideanDistance, epsilon: 10, minPoints: 2)

// Print results
//for (index, currData) in dbScan.data.enumerated() {
//	print("\(currData) -> \(dbScan.label[currData] ?? "")")
//}

