//
//  File.swift
//  
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

class ProcessorTools {
	
	// Check if processor is arm64
	static func isArmProcessor() -> Bool {
		let cpuArchitecture: String = ProcessInfo.processInfo.machineHardwareName ?? "null"
		return cpuArchitecture == "arm64"
	}
	
	// Get processor core count
	static func getCoreCount() -> Int {
		if isArmProcessor() {
			// Return core count
			return ProcessInfo.processInfo.processorCount
		} else {
			// Return double for Intel hyper-threading
			return ProcessInfo.processInfo.processorCount * 2
		}
	}
	
	
	
}
