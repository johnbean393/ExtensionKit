//
//  Array.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

extension Array {
	
	// Map array with multithreading
	public func parallelMap<T>(_ transform: (Element) -> T) -> [T] {
		var result = Array<T?>(repeating: nil, count: count)
		let queue = DispatchQueue(label: "com.pattonium.scripts.parallelMap", attributes: .concurrent)
		
		DispatchQueue.concurrentPerform(iterations: count) { i in
			let transformed = transform(self[i])
			queue.sync {
				result[i] = transformed
			}
		}
		
		return result.compactMap { $0 }
	}
	
}
