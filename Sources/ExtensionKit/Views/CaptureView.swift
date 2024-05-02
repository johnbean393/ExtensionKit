//
//  CaptureView.swift
//
//
//  Created by Bean John on 2/5/2024.
//

import SwiftUI

#if os(macOS)
@available(macOS 13.0, *)
public struct CaptureView<Content: View>: View {

	@Binding var productDir: URL
	@Binding var filename: String
	var content: () -> Content
	
	public var body: some View {
		VStack {
			VStack(content: content)
			Button("Render") {
				Task {
					// Correct filename if needed
					if !filename.hasSuffix(".png") {
						filename = filename + ".png"
					}
					// Render and save image
					let renderer: ImageRenderer = ImageRenderer(content: VStack(content: content))
					if let image = renderer.nsImage {
						print(image.size)
						saveNSImage(filepath: productDir.posixPath() + filename, image: image)
					}
				}
			}
		}
	}
	
	func saveNSImage(filepath: String, image: NSImage) {
		let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
		let pngData = imageRepresentation?.representation(using: .png, properties: [:])
		do {
			try pngData!.write(to: URL(fileURLWithPath: filepath))
		} catch {
			print(error)
		}
	}
	
}

#endif
