//
//  Sequence.swift
//
//
//  Created by Bean John on 7/2/2024.
//

import Foundation

extension Sequence {
	
	/// Maps through the elements one by one,
	/// executing the closure for each of them one at a time.
	public func asyncMap<T>(
		_ closure: @Sendable (Element) async throws -> T
	) async rethrows -> [T] {
		var array: [T] = []
		array.reserveCapacity(self.underestimatedCount)
		for element in self {
			array.append(try await closure(element))
		}
		return array
	}
	
	/// Maps through the elements concurrently,
	/// executing the closure for all the elements at the same time.
	/// Keeps the order of the elements with the help of the id.
	public func concurrentMap<T, ID>(
		id identifyingClosure: (Element) -> ID,
		_ closure: @escaping @Sendable (Element) async throws -> T
	) async rethrows -> [T] where ID: Equatable {
		try await withThrowingTaskGroup(of: (value: T, id: ID).self) { group in
			let withIdentifiers = self.map({ (element: $0, id: identifyingClosure($0)) })
			for (element, id) in withIdentifiers {
				group.addTask {
					try await (value: closure(element), id: id)
				}
			}
			var array: [(value: T, id: ID)] = []
			array.reserveCapacity(self.underestimatedCount)
			for try await valueWithId in group {
				array.append(valueWithId)
			}
			array.sort(by: { lhs, rhs in
				withIdentifiers.firstIndex(where: { $0.id == lhs.id })! <
					withIdentifiers.firstIndex(where: { $0.id == rhs.id })!
			})
			return array.map(\.value)
		}
	}
}

extension Sequence where Element: Equatable {
	
	/// Maps through the elements concurrently,
	/// executing the closure for all the elements at the same time.
	/// Keeps the order of the elements.
	public func concurrentMap<T>(
		_ closure: @escaping @Sendable (Element) async throws -> T
	) async rethrows -> [T] {
		try await self.concurrentMap(id: { $0 }, closure)
	}
}
