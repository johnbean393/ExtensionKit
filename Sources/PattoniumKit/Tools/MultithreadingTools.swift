//
//  MultithreadingTools.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

class MultithreadingTools {
	
	// Loop through array and execute actions for each concurrently
	static func parallelForEach(array: Array<Any>, action: (_ currElement: Any) -> Void) {
		DispatchQueue.concurrentPerform(iterations: array.count) { index in
			let currElement: Any = array[index]
			action(currElement)
		}
	}
	
}
