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
	
	func posixPath() -> String {
		if #available(macOS 13.0, iOS 16.0, macCatalyst 13.0, *) {
			return self.path(percentEncoded: false)
		} else {
			return self.path.removingPercentEncoding!
		}
	}
	
	func containsItem(itemUrl: URL) -> Bool {
		// Do checks
		let fileExists: Bool = FileManager.default.fileExists(atPath: itemUrl.posixPath())
		let dirContains: Bool = itemUrl.posixPath().hasPrefix(self.posixPath())
		// Return result
		return fileExists && dirContains
	}
	
	// List URLs of files in directory
	func listDirectory() throws -> [URL] {
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
	
	func lastModifiedDate() throws -> Date {
		do {
			let attributes: [FileAttributeKey:Any] = try FileManager.default.attributesOfItem(atPath: self.posixPath())
			return (attributes[FileAttributeKey.modificationDate] as? Date)!
		} catch {
			throw FileAttributesError.accessError
		}
	}
	
	// Calculate size of directory
	func directorySize() -> Int64 {
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
	func fileExists() -> Bool {
		return FileManager.default.fileExists(atPath: self.posixPath())
	}
	
}
