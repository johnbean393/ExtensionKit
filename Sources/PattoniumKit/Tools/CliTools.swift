//
//  CliTools.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import AppKit

@available(macOS 12, *)
class CliTools {
	
	// Run a shell script
	static func runCommand(command: String) -> String {
		let task = Process()
		task.launchPath = "/bin/zsh"
		task.arguments = ["-c", command]
		
		let pipe = Pipe()
		task.standardOutput = pipe
		
		task.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8) ?? "No output"
		return output
	}
	
	// Run an AppleScript
	static func runAppleScript(scriptStr: String) {
		if let script = NSAppleScript(source: scriptStr) {
			var error: NSDictionary?
			script.executeAndReturnError(&error)
			if let err = error {
				print(err)
			}
		}
	}
	
	static func relaunch(afterDelay seconds: TimeInterval = 5) -> Never {
		let task = Process()
		task.launchPath = "/bin/zsh"
		task.arguments = ["-c", "sleep \(seconds); open \"\(Bundle.main.bundlePath)\""]
		task.launch()
		
		NSApplication.shared.terminate(self)
		exit(0)
	}
	
	
}
