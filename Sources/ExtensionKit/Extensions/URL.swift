//
//  URL.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import QuickLookThumbnailing
import AppKit

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
	
	// Check if directory is empty
	public func isEmpty() -> Bool {
		do {
			let dirContents: [URL] = try self.listDirectory()
			return dirContents.isEmpty
		} catch {
			return true
		}
	}
	
	// Get last modified date of file
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
	public var volumeTotalCapacity: Int {
		(try? resourceValues(forKeys: [.volumeTotalCapacityKey]))?.volumeTotalCapacity ?? 0
	}
	
	// Total capacity of a volume for important usage
	public var volumeAvailableCapacityForImportantUsage: Int64 {
		(try? resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]))?.volumeAvailableCapacityForImportantUsage ?? 0
	}
	
	// Total capacity of a volume for not too important usage
	public var volumeAvailableCapacityForOpportunisticUsage: Int64 {
		(try? resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]))?.volumeAvailableCapacityForOpportunisticUsage ?? 0
	}
	
	// Name of a volume
	public var name: String {
		(try? resourceValues(forKeys: [.nameKey]))?.name ?? "null"
	}
	
	// Name of a volume
	public var volumeName: String {
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
	
	public func thumbnail(size: CGSize, scale: CGFloat, completion: @escaping (CGImage) -> Void) {
		let request = QLThumbnailGenerator.Request(fileAt: self, size: size, scale: scale, representationTypes: .lowQualityThumbnail)
		QLThumbnailGenerator.shared.generateRepresentations(for: request) { (thumbnail, type, error) in
			DispatchQueue.main.async {
				if thumbnail == nil || error != nil {
					// Handle the error case gracefully.
					let nsImage: NSImage = NSWorkspace.shared.icon(forFile: self.posixPath())
					var rect: NSRect = NSRect(origin: CGPoint(x: 0, y: 0), size: nsImage.size)
					let result: CGImage = nsImage.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)!
					completion(result)
				} else {
					// Display the thumbnail that you created.
					let result: CGImage = thumbnail!.cgImage
					completion(result)
				}
			}
		}
	}
	
}
