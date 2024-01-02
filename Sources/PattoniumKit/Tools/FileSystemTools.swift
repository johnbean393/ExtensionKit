//
//  FileSystemTools.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
#if canImport(AppKit)
import AppKit
#endif
import os.log

enum OpenPanelError: Error {
	case noSelection
}

enum AirDropError: Error {
	case fileMissing
	case serviceInitFailed
	case serviceError
}

public class FileSystemTools {
	
	#if os(macOS)
	// Get "~/Desktop/" directory url
	static public func getDesktopUrl() -> URL {
		return FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
	}
	#endif
	
	// Get "~/Downloads/" directory url
	static public func getDownloadsUrl() -> URL {
		return FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
	}
	
	// Get "~/Documents/" directory url
	static public func getDocumentsUrl() -> URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	}
	
	// Get "~/Library/Application Support/" directory url
	static public func getAppSupportDirUrl() -> URL {
		return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
	}
	
	// Open a panel for users to select a file
	#if os(macOS)
	static public func openPanel(url: URL, files: Bool, folders: Bool, dialogTitle: String) throws -> URL {
		// Select a file
		let dialog = NSOpenPanel()
		dialog.directoryURL = url
		dialog.title = dialogTitle
		dialog.message = dialogTitle
		dialog.showsResizeIndicator = false
		dialog.showsHiddenFiles = false
		dialog.canChooseDirectories = folders
		dialog.canCreateDirectories = true
		dialog.allowsMultipleSelection = false
		dialog.canChooseFiles = files
		// If user clicked OK
		if dialog.runModal() == .OK {
			return dialog.urls.first!
		}
		throw OpenPanelError.noSelection
	}
	#endif
	
	// Make a new directory
	static public func createDirectory(url: URL) {
		var dirPath: String = ""
		if #available(macOS 13.0, iOS 16.0, macCatalyst 13.0, *) {
			dirPath = url.path(percentEncoded: false)
		} else {
			dirPath = url.path.removingPercentEncoding!
		}
		if !FileManager.default.fileExists(atPath: dirPath) {
			do {
				try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
			} catch {
				os_log("error = %@", error.localizedDescription)
			}
		}
	}
	
	// List contents of a directory
	static public func listDirectory(dirUrl: URL) -> [URL] {
		do {
			let dirContents: [URL] = try FileManager.default.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: [])
			let filteredDirContents: [URL] = dirContents.filter { !$0.lastPathComponent.hasPrefix(".") && !$0.lastPathComponent.hasPrefix("~$") }
			return filteredDirContents
		} catch {
			return []
		}
	}
	
	static public func moveFile(fromUrl: URL, toUrl: URL) {
		// Move file to toUrl
		do {
			// Move file
			try FileManager.default.moveItem(at: fromUrl, to: toUrl.appendingPathComponent(fromUrl.lastPathComponent))
		} catch {
			os_log("error = %@", error.localizedDescription)
		}
	}
	
	#if os(macOS)
	static public func moveFileWithReplace(fromUrl: URL, toUrl: URL) -> Bool {
		// Move file to destination url
		do {
			// If file doesn't exist at final path
			if !FileManager.default.fileExists(atPath: toUrl.appendingPathComponent(fromUrl.lastPathComponent).posixPath()) {
				// Move file
				try FileManager.default.moveItem(at: fromUrl, to: toUrl.appendingPathComponent(fromUrl.lastPathComponent))
				return true
			} else {
				Task {
					var response: Bool = false
					response = try await MainActor.run { () -> Bool in
						let alert = NSAlert()
						alert.messageText = "Replace \"\(fromUrl.lastPathComponent)\" in \"\(toUrl.lastPathComponent)\" with new file?"
						alert.addButton(withTitle: "OK")
						alert.addButton(withTitle: "Cancel")
						if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn {
							// Replace item
							let _ = try FileManager.default.replaceItemAt(toUrl.appendingPathComponent(fromUrl.lastPathComponent), withItemAt: fromUrl)
							return true
						} else {
							// Remove item from fromUrl
							FileSystemTools.moveFile(fromUrl: fromUrl, toUrl: FileSystemTools.getDesktopUrl())
							return false
						}
					}
					return response
				}
			}
		} catch {
			os_log("error = %@", error.localizedDescription)
			return false
		}
		return true
	}
	#endif
	
	static public func copyFile(fromUrl: URL, toUrl: URL) {
		// Move file to destination url
		do {
			// Move file
			try FileManager.default.copyItem(at: fromUrl, to: toUrl.appendingPathComponent(fromUrl.lastPathComponent))
		} catch {
			os_log("error = %@", error.localizedDescription)
		}
	}
	
	#if os(macOS)
	static public func copyFileWithReplace(fromUrl: URL, toUrl: URL, filename: String) async -> Bool {
		// Move file to destination url
		do {
			// If file doesn't exist at final path
			if !FileManager.default.fileExists(atPath: toUrl.appendingPathComponent("\(filename).\(fromUrl.pathExtension)").posixPath()) {
				// Move file
				try FileManager.default.copyItem(at: fromUrl, to: toUrl.appendingPathComponent("\(filename).\(fromUrl.pathExtension)"))
				return true
			} else {
				let response: Bool =  try await MainActor.run { () -> Bool in
					let alert = NSAlert()
					alert.messageText = "Replace \"\(filename).\(fromUrl.pathExtension)\" in \"\(toUrl.lastPathComponent)\" with new file?"
					alert.addButton(withTitle: "OK")
					alert.addButton(withTitle: "Cancel")
					if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn {
						try FileManager.default.removeItem(atPath: toUrl.appendingPathComponent("\(filename).\(fromUrl.pathExtension)").posixPath())
						let _ = try FileManager.default.copyItem(at: fromUrl, to: toUrl.appendingPathComponent("\(filename).\(fromUrl.pathExtension)"))
						return true
					}
					return false
				}
				return response
			}
		} catch {
			os_log("error = %@", error.localizedDescription)
		}
		return false
	}
	#endif
	
	// Open directory in Finder
	#if os(macOS)
	static public func openDirectory(url: URL) {
		if #available(macOS 13.0, *) {
			NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path(percentEncoded: false))
		} else {
			NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path.removingPercentEncoding!)
		}
	}
	#endif
	
	// Open window to AirDrop a file
	#if os(macOS)
	static public func airDropFiles(urls: [URL]) throws {
		// Throw error if any file is non-existent
		if urls.map({ $0.fileExists() }).contains(false) {
			throw AirDropError.fileMissing
		}
		// Start NSSharingService
		guard let service: NSSharingService = NSSharingService(named: .sendViaAirDrop) else {
			// Throw error for failure to establish service
			throw AirDropError.serviceInitFailed
		}
		// Open window to share file
		if service.canPerform(withItems: urls) {
			service.perform(withItems: urls)
		}  else {
			throw AirDropError.serviceError
		}
	}
	#endif
	
	// Function to make alias
	#if os(macOS)
	public func makeAlias(dirUrl: URL, atUrl: URL, aliasName: String = "New Alias") throws {
		do {
			let data: Data = try dirUrl.bookmarkData(options: [URL.BookmarkCreationOptions.suitableForBookmarkFile], includingResourceValuesForKeys: nil, relativeTo: nil)
			try URL.writeBookmarkData(data, to: atUrl.appendingPathComponent(aliasName))
		} catch {
			print(error)
		}
	}
	#endif
	
	// Function to make alias with icon
	#if os(macOS)
	@available(macOS 14, *)
	public func makeAliasWithIcon(dirUrl: URL, atUrl: URL, aliasName: String = "New Alias", iconName: String) throws {
		do {
			let data: Data = try dirUrl.bookmarkData(options: [URL.BookmarkCreationOptions.suitableForBookmarkFile], includingResourceValuesForKeys: nil, relativeTo: nil)
			try URL.writeBookmarkData(data, to: atUrl.appendingPathComponent(aliasName))
			NSWorkspace.shared.setIcon(NSImage(resource: ImageResource(name: iconName, bundle: Bundle.main)), forFile: atUrl.appendingPathComponent(aliasName).posixPath())
		} catch {
			print(error)
		}
	}
	#endif
	
}
