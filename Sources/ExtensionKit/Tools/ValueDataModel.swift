//
//  ValueDataModel.swift
//
//
//  Created by Bean John on 3/1/2024.
//

import Foundation
import SwiftUI

open class ValueDataModel<Value>: ObservableObject where Value: Codable & Equatable {
	
	public required init(appDirName: String = Bundle.main.applicationName ?? Bundle.main.description, datastoreName: String = "\(Bundle.main.applicationName ?? Bundle.main.description)Data") {
		// Set path names
		self.appDirName = appDirName
		self.datastoreName = datastoreName
		// Init methods
		checkIfAppDirExists()
		checkIfDataStoreExists()
		load()
	}
	
	public var appDirName: String
	public var datastoreName: String

	@Published public var values: [Value] = [] {
		
		// Autosave after change
		didSet {
			save()
		}
		
	}
	
	public func checkIfAppDirExists() {
		// Get application directory
		let appSupportUrl: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
		let appDirUrl: URL = appSupportUrl.appendingPathComponent(appDirName)
		let appDirPath: String = appDirUrl.posixPath()
		// If app dir does not exist
		if !FileManager.default.fileExists(atPath: appDirPath) {
			// Make dir
			do {
				try FileManager.default.createDirectory(at: appDirUrl, withIntermediateDirectories: true)
			} catch {
				// Failed to make dir, throw fatal error
				fatalError("Failed to initialize application directory.")
			}
		}
	}
	
	public func checkIfDataStoreExists() {
		// Get datastore url
		let datastorePath: String = getDataStoreUrl().posixPath()
		// If app dir does not exist
		if !FileManager.default.fileExists(atPath: datastorePath) {
			// Make datastore by saving blank data
			values = []
			save()
		}
	}
	
	func getAppDirUrl() -> URL {
		// Get application directory
		let appSupportUrl: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
		let appDirUrl: URL = appSupportUrl.appendingPathComponent(appDirName)
		// Return url after checks passed
		return appDirUrl
	}
	
	func getDataStoreUrl() -> URL {
		return getAppDirUrl().appendingPathComponent("\(datastoreName).json")
	}
	
	public func load() {
		// Get datastore url
		let dataStoreUrl: URL = getDataStoreUrl()
		print(getAppDirUrl().posixPath())
		do {
			// Load data
			let rawData: Data = try Data(contentsOf: dataStoreUrl, options: .mappedIfSafe)
			let rawValues: [Value] = try JSONDecoder().decode([Value].self, from: rawData)
			values = rawValues
		} catch {
			print("Failed to load data")
		}
	}
	
	public func save() {
		// Get datastore url
		let dataStoreUrl: URL = getDataStoreUrl()
		do {
			// Save data
			let rawData: Data = try JSONEncoder().encode(values)
			try rawData.write(to: dataStoreUrl, options: .atomic)
		} catch {
			print("Failed to save data")
		}
	}
	
	public func delete(_ value: Binding<Value>) {
		withAnimation(.spring()) {
			values = values.filter { $0 != value as! Value }
		}
	}
	
	public func delete(_ value: Value) {
		withAnimation(.spring()) {
			values = values.filter { $0 != value }
		}
	}
	
	public func add(_ value: Value) {
		withAnimation(.spring()) {
			values.append(value)
		}
	}
	
}
