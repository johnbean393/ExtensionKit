//
//  URL.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation

enum ListDirectoryError: Error {
	case notDirectory
}

enum FileAttributesError: Error {
	case accessError
}

extension URL {
	
	// Get posix path of URL
	public func posixPath() -> String {
		if #available(macOS 13.0, iOS 16.0, macCatalyst 13.0, *) {
			return self.path(percentEncoded: false)
		} else {
			return self.path.removingPercentEncoding!
		}
	}
	
	public func containsItem(itemUrl: URL) -> Bool {
		// Do checks
		let fileExists: Bool = FileManager.default.fileExists(atPath: itemUrl.posixPath())
		let dirContains: Bool = itemUrl.posixPath().hasPrefix(self.posixPath())
		// Return result
		return fileExists && dirContains
	}
	
	// List URLs of files in directory
	public func listDirectory() throws -> [URL] {
		let url: URL = self
		// Throw error if URL is not directory
		if url.hasDirectoryPath {
			// Use directory enumerator for better performance
			let dirFiles: [URL] = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil)?.allObjects as? [URL] ?? []
			return dirFiles
		} else {
			throw ListDirectoryError.notDirectory
		}
	}
	
	public func lastModifiedDate() throws -> Date {
		do {
			let attributes: [FileAttributeKey:Any] = try FileManager.default.attributesOfItem(atPath: self.posixPath())
			return (attributes[FileAttributeKey.modificationDate] as? Date)!
		} catch {
			throw FileAttributesError.accessError
		}
	}
	
	// Calculate size of directory
	public func directorySize() -> Int64 {
		let contents: [URL]
		do {
			contents = try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey])
		} catch {
			return 0
		}
		var size: Int64 = 0
		for url in contents {
			let isDirectoryResourceValue: URLResourceValues
			do {
				isDirectoryResourceValue = try url.resourceValues(forKeys: [.isDirectoryKey])
			} catch {
				continue
			}
			if isDirectoryResourceValue.isDirectory == true {
				size += url.directorySize()
			} else {
				let fileSizeResourceValue: URLResourceValues
				do {
					fileSizeResourceValue = try url.resourceValues(forKeys: [.fileSizeKey])
				} catch {
					continue
				}
				size += Int64(fileSizeResourceValue.fileSize ?? 0)
			}
		}
		return size
	}
	
	// Check if file exists
	public func fileExists() -> Bool {
		return FileManager.default.fileExists(atPath: self.posixPath())
	}
	
	// Total capacity of a volume
	var volumeTotalCapacity: Int {
		(try? resourceValues(forKeys: [.volumeTotalCapacityKey]))?.volumeTotalCapacity ?? 0
	}
	
	// Total capacity of a volume for important usage
	var volumeAvailableCapacityForImportantUsage: Int64 {
		(try? resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]))?.volumeAvailableCapacityForImportantUsage ?? 0
	}
	
	// Total capacity of a volume for not too important usage
	var volumeAvailableCapacityForOpportunisticUsage: Int64 {
		(try? resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]))?.volumeAvailableCapacityForOpportunisticUsage ?? 0
	}
	
	// Name of a volume
	var name: String {
		(try? resourceValues(forKeys: [.nameKey]))?.name ?? "null"
	}
	
	// Name of a volume
	var volumeName: String {
		(try? resourceValues(forKeys: [.volumeNameKey]))?.volumeName ?? "null"
	}
	
	// Check if the URL is a directory and if it is reachable
	public func isDirectoryAndReachable() throws -> Bool {
		guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
			return false
		}
		return try checkResourceIsReachable()
	}
	
	// Returns total allocated size of a directory including its subfolders or not
	public func directoryTotalAllocatedSize(includingSubfolders: Bool = false) throws -> Int? {
		guard try isDirectoryAndReachable() else { return nil }
		if includingSubfolders {
			guard
				let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
			return try urls.lazy.reduce(0) {
				(try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0) + $0
			}
		}
		return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy.reduce(0) {
			(try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
				.totalFileAllocatedSize ?? 0) + $0
		}
	}
	
}
