//
//  ValueDataModel.swift
//
//
//  Created by Bean John on 3/1/2024.
//

import Foundation
import SwiftUI
import os.log

open class ValueDataModel<Value: Codable & Equatable>: ObservableObject {
	
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
		do {
			// Load data
			let rawData: Data = try Data(contentsOf: dataStoreUrl)
			print(rawData.description)
			print(Value.Type.self)
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
	
	public func clearData() {
		// Save current data
		save()
		// Rename old datastore
		do {
			try FileManager.default.moveItem(at: getDataStoreUrl(), to: getDataStoreUrl().deletingLastPathComponent().appendingPathComponent("\(datastoreName)-\(UUID().uuidString).json"))
		} catch {
			// If rename failed, delete old datastore
			do {
				try FileManager.default.removeItem(at: getDataStoreUrl())
			} catch {
				os_log("error = %@", error.localizedDescription)
			}
		}
		// Make new blank datastore
		values = []
		save()
	}
	
}
