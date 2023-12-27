//
//  TextExtractor.swift
//
//
//  Created by Bean John on 27/12/2023.
//

import Foundation
import PDFKit
import Vision
import os.log
import NaturalLanguage

#if os(macOS)
class TextExtractor {
	
	enum ExtractionError: Error {
		case decodeError
		case unknownFormat
	}
	
	static func extractText(url: URL) async throws -> String {
		// Define result variable
		var extractedText = ""
		// Detect file type and decode format
		do {
			switch url.pathExtension.lowercased() {
				case "txt":
					extractedText = try extractFromTxt(url: url)
				case "rtf":
					extractedText = try extractFromTxt(url: url)
				case "csv":
					extractedText = try extractFromTxt(url: url)
				case "py":
					extractedText = try extractFromTxt(url: url)
				case "swift":
					extractedText = try extractFromTxt(url: url)
				case "doc":
					extractedText = try extractFromDoc(url: url)
				case "docx":
					extractedText = try await extractFromDocx(url: url)
				case "docm":
					extractedText = try await extractFromDocx(url: url)
				case "pages":
					extractedText = try await extractFromPages(url: url)
				case "pptx":
					extractedText = try await extractFromPptx(url: url)
				case "pdf":
					extractedText = try await extractFromPdf(url: url)
				case "png":
					extractedText = try await extractFromImage(url: url)
				case "jpg":
					extractedText = try await extractFromImage(url: url)
				case "bmp":
					extractedText = try await extractFromImage(url: url)
				case "jpeg":
					extractedText = try await extractFromImage(url: url)
				case "tiff":
					extractedText = try await extractFromImage(url: url)
				case "webp":
					extractedText = try await extractFromImage(url: url)
				case "heic":
					extractedText = try await extractFromImage(url: url)
				default:
					extractedText = try extractFromUtf8(url: url)
			}
			// Return result
			return extractedText
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromTxt(url: URL) throws -> String {
		do {
			let txtStr: String = try String(contentsOf: url, encoding: String.Encoding.utf8)
			return txtStr
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromUtf8(url: URL) throws -> String {
		do {
			let txtStr: String = try String(contentsOf: url, encoding: String.Encoding.utf8)
			return txtStr
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromDoc(url: URL) throws -> String {
		do {
			let fileData: NSData =  try NSData(contentsOf: url)
			var fileString: String = ""
			if let tryForString = try? NSAttributedString(data: fileData as Data, options: [
				.documentType: NSAttributedString.DocumentType.docFormat,
				.characterEncoding: String.Encoding.utf8.rawValue
			], documentAttributes: nil) {
				fileString = tryForString.string
			} else {
				fileString = "Data conversion error."
			}
			fileString = fileString.trimmingCharacters(in: .whitespacesAndNewlines)
			return fileString
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromDocx(url: URL) async throws -> String {
		do {
			// Get text
			let fileData: NSData =  try NSData(contentsOf: url)
			var fileString: String = ""
			if let tryForString = try? NSAttributedString(data: fileData as Data, options: [
				.documentType: NSAttributedString.DocumentType.officeOpenXML,
				.characterEncoding: String.Encoding.utf8.rawValue
			], documentAttributes: nil) {
				fileString = tryForString.string
			} else {
				fileString = "Data conversion error."
			}
			fileString = fileString.trimmingCharacters(in: .whitespacesAndNewlines)
			// Get filepath
			let filepath: String = url.posixPath()
			// Make UUID
			let archiveId: UUID = UUID()
			// Run commands to prepare unique directory, unzip the file and get results
			let textExtractorDirUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor")
		FileSystemTools.createDirectory(url: textExtractorDirUrl)
		let textExtractorDirPath: String = textExtractorDirUrl.posixPath()
			let cliResult: String = CliTools.runCommand(command: "cd \"\(textExtractorDirPath)\"; rm -rf \"wordDecodeContents/\(archiveId.uuidString)\"; mkdir -p \"wordDecodeContents/\(archiveId.uuidString)\"; cd \"wordDecodeContents/\(archiveId.uuidString)\"; unzip \"\(filepath)\"")
			// Get images
			let mediaDirUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor").appendingPathComponent("wordDecodeContents").appendingPathComponent(archiveId.uuidString).appendingPathComponent("word").appendingPathComponent("media")
			// Get images availible
			var nsImages: [NSImage] = []
			let mediaFiles: [URL] = FileSystemTools.listDirectory(dirUrl: mediaDirUrl)
			for currFile in FileSystemTools.listDirectory(dirUrl: mediaDirUrl) {
				if TextExtractor.isRecognizedImage(url: currFile) {
					guard let nsImage: NSImage = NSImage(contentsOf: currFile) else { continue }
					nsImages.append(nsImage)
				}
			}
			let sampleImages: [NSImage] = nsImages
			// Get text from images
			DispatchQueue.concurrentPerform(iterations: nsImages.count) { i in
				let nsImage = sampleImages[i]
				do {
					let extractedText: String = try extractFromNSImage(nsImage: nsImage)
					let extractedContent: NSAttributedString = NSAttributedString(string: extractedText)
					// Join text
					DispatchQueue.main.sync {
						fileString += "\n\(extractedContent)"
					}
				} catch {
					os_log("error = %@", error.localizedDescription)
				}
			}
			// Delete unzipped archive folder
			let _ = CliTools.runCommand(command: "rm -rf \"\(textExtractorDirPath)/wordDecodeContents/\(archiveId.uuidString)\"")
			return fileString
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromPptx(url: URL) async throws -> String {
		// Get filepath
		let filepath: String = url.posixPath()
		// Make UUID
		let archiveId: UUID = UUID()
		// Run commands to prepare unique directory, unzip the file and get results
		let textExtractorDirUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor")
		FileSystemTools.createDirectory(url: textExtractorDirUrl)
		let textExtractorDirPath: String = textExtractorDirUrl.posixPath()
		let cliResult: String = CliTools.runCommand(command: "cd \"\(textExtractorDirPath)\"; rm -rf \"pptDecodeContents/\(archiveId.uuidString)\"; mkdir -p \"pptDecodeContents/\(archiveId.uuidString)\"; cd \"pptDecodeContents/\(archiveId.uuidString)\"; unzip \"\(filepath)\"; cd ppt/slides; echo \"-<>-<>-separator-<>-<>-\"; grep -r -h -E -o '<a:t>[^<]*</a:t>' . | sed -E 's/<[^>]*>//g' | grep -v '^./slide.*'")
		// Kill lingering process
		let _ = CliTools.runCommand(command: "killall grep")
		// Check if no error
		if cliResult.contains("-<>-<>-separator-<>-<>-\n") {
			// Process and return results
			var fileText: String = cliResult.components(separatedBy: "-<>-<>-separator-<>-<>-\n")[cliResult.components(separatedBy: "-<>-<>-separator-<>-<>-\n").count - 1]
			// Get image text in ~/Library/Application Support/Magic Sorter/PPT_Decode_Contents/ppt/media
			let mediaDirUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor").appendingPathComponent("pptDecodeContents").appendingPathComponent(archiveId.uuidString).appendingPathComponent("ppt").appendingPathComponent("media")
			// Get images availible
			var nsImages: [NSImage] = []
			let mediaFiles: [URL] = FileSystemTools.listDirectory(dirUrl: mediaDirUrl)
			for currFile in FileSystemTools.listDirectory(dirUrl: mediaDirUrl) {
				if TextExtractor.isRecognizedImage(url: currFile) {
					guard let nsImage: NSImage = NSImage(contentsOf: currFile) else { continue }
					nsImages.append(nsImage)
				}
			}
			let sampleImages: [NSImage] = nsImages
			// Get text from nsImages
			DispatchQueue.concurrentPerform(iterations: sampleImages.count) { i in
				let nsImage: NSImage = sampleImages[i]
				do {
					let extractedText: String = try extractFromNSImage(nsImage: nsImage)
					let extractedContent: NSAttributedString = NSAttributedString(string: extractedText)
					// Join text
					DispatchQueue.main.sync {
						fileText += "\n\(extractedContent)"
					}
				} catch {
					os_log("error = %@", error.localizedDescription)
				}
			}
			// Delete unzipped archive folder
			let _ = CliTools.runCommand(command: "rm -rf \"\(textExtractorDirPath)/pptDecodeContents/\(archiveId.uuidString)\"")
			return fileText
		} else {
			// Delete unzipped archive folder
			let _ = CliTools.runCommand(command: "rm -rf \"\(textExtractorDirPath)/pptDecodeContents/\(archiveId.uuidString)\"")
			// Throw error
			throw ExtractionError.decodeError
		}
	}
	
	private static func extractFromPages(url: URL) async throws -> String {
		// Get filepath
		let filepath: String = url.posixPath()
		// Make UUID
		let archiveId: UUID = UUID()
		// Run commands to prepare unique directory, unzip the file and get results
		let textExtractorDirUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor")
		FileSystemTools.createDirectory(url: textExtractorDirUrl)
		let textExtractorDirPath: String = textExtractorDirUrl.posixPath()
		let cliResult: String = CliTools.runCommand(command: "cd \"\(textExtractorDirPath)\"; rm -rf \"pagesDecodeContents/\(archiveId.uuidString)\"; mkdir -p \"pagesDecodeContents/\(archiveId.uuidString)\"; cd \"pagesDecodeContents/\(archiveId.uuidString)\"; unzip \"\(filepath)\"")
		// Get image text in ~/Library/Application Support/Magic Sorter/pagesDecodeContents/archiveId
		let mediaUrl: URL = FileSystemTools.getAppSupportDirUrl().appendingPathComponent("Text Extractor").appendingPathComponent("pagesDecodeContents").appendingPathComponent(archiveId.uuidString).appendingPathComponent("preview.jpg")
		// Get image
		if TextExtractor.isRecognizedImage(url: mediaUrl) {
			guard let nsImage: NSImage = NSImage(contentsOf: mediaUrl) else { throw ExtractionError.decodeError }
			// Extract text
			do {
				let extractedText: String = try extractFromNSImage(nsImage: nsImage)
				// Delete unzipped archive folder
				let _ = CliTools.runCommand(command: "rm -rf \"\(textExtractorDirPath)/pagesDecodeContents/\(archiveId.uuidString)\"")
				print("extractedText: ", extractedText)
				return extractedText
			} catch {
				os_log("error = %@", error.localizedDescription)
			}
		}
		// Delete unzipped archive folder
		let _ = CliTools.runCommand(command: "rm -rf \"\(textExtractorDirPath)/pagesDecodeContents/\(archiveId.uuidString)\"")
		// Throw error
		throw ExtractionError.decodeError
	}
	
	private static func extractFromPdf(url: URL) async throws -> String {
		// Get pdf document
		if let pdf = PDFDocument(url: url) {
			let pageCount = pdf.pageCount
			let documentContent = NSMutableAttributedString()
			var nsImages: [NSImage] = []
			// Extract contents of each page
			for pageIndex in 0..<pageCount {
				// Get text content
				guard let page: PDFPage = pdf.page(at: pageIndex) else { continue }
				guard let pageContent: NSAttributedString = page.attributedString else { continue }
				// Check if text is reversed
				if pageContent.string.components(separatedBy: " ,").count >= 3 || pageContent.string.components(separatedBy: " .").count >= 5 {
					// If reversed, add reversed string
					documentContent.append(NSAttributedString(string: pageContent.string.reduce("") { "\($1)" + $0 } ))
				} else {
					// If not reversed, add normal string
					documentContent.append(pageContent)
				}
				// Add new line
				documentContent.append(NSAttributedString(string: "\n"))
				// Get image content if time allows
				do {
					let tempNsImages: [NSImage] = try getPdfPageImage(page: page)
					nsImages = nsImages + tempNsImages
				} catch {
					continue
				}
			}
			// Define result
			var result: String = documentContent.string
			// Define dispatch group to run image analysis on different thread
			let dispatchGroup: DispatchGroup = DispatchGroup()
			// If there were images in document
			if !nsImages.isEmpty {
				// Get dominant language for image text extraction
				var dominantLanguage: String = {
					do {
						return try url.lastPathComponent.strDominantLanguage()
					} catch {
						return "en"
					}
				}()
				if (documentContent.string.components(separatedBy: .newlines).count - 1) >= 3 && documentContent.string.replacingOccurrences(of: " ", with: "").count >= 300 {
					// If there is content in text, use content to determine language
					dominantLanguage = {
						do {
							return try documentContent.string.strDominantLanguage()
						} catch {
							return "en"
						}
					}()
				}
				dominantLanguage = dominantLanguage.replacingOccurrences(of: "zh-Hans", with: "zh-cn")
				let sampleImages: [NSImage] = nsImages
				// Get text from nsImages
				DispatchQueue.concurrentPerform(iterations: sampleImages.count) { i in
					let nsImage = sampleImages[i]
					do {
						let extractedText: String = try extractFromNSImage(nsImage: nsImage)
						let extractedContent: NSAttributedString = NSAttributedString(string: extractedText)
						// Join text
						DispatchQueue.main.sync {
							result = "\(result)\n\(extractedContent)"
						}
					} catch {
						os_log("error = %@", error.localizedDescription)
					}
				}
				dispatchGroup.notify(queue: .main) {
					// Return result
					result += documentContent.string
				}
			}
			// Return result
			return result
		} else {
			throw ExtractionError.decodeError
		}
		
	}
	
	private static func getPdfPageImage(page: PDFPage) throws -> [NSImage] {
		// Get page
		guard let cgPdfPage: CGPDFPage = page.pageRef, let dictionary = cgPdfPage.dictionary else {
			throw ExtractionError.decodeError
		}
		var res: CGPDFDictionaryRef?
		guard CGPDFDictionaryGetDictionary(dictionary, "Resources", &res), let resources = res else {
			throw ExtractionError.decodeError
		}
		var xObj: CGPDFDictionaryRef?
		guard CGPDFDictionaryGetDictionary(resources, "XObject", &xObj), let xObject = xObj else {
			throw ExtractionError.decodeError
		}
		
		// Enumerate all of the keys in 'dict', calling the block-function `block' once for each key/value pair.
		var imageKeys = [String]()
		CGPDFDictionaryApplyBlock(xObject, { key, object, _ in
			var stream: CGPDFStreamRef?
			guard CGPDFObjectGetValue(object, .stream, &stream),
				  let objectStream = stream,
				  let streamDictionary = CGPDFStreamGetDictionary(objectStream) else {
				return true
			}
			
			var subtype: UnsafePointer<Int8>?
			guard CGPDFDictionaryGetName(streamDictionary, "Subtype", &subtype), let subtypeName = subtype else {
				return true
			}
			
			if String(cString: subtypeName) == "Image" {
				imageKeys.append(String(cString: key))
			}
			return true
		}, nil)
		
		// Get images
		let allPageImages = imageKeys.compactMap { imageKey -> NSImage? in
			var stream: CGPDFStreamRef?
			guard CGPDFDictionaryGetStream(xObject, imageKey, &stream), let imageStream = stream else {
				return nil
			}
			var format: CGPDFDataFormat = .raw
			guard let data = CGPDFStreamCopyData(imageStream, &format) else {
				// Fall back on converting the entire page to an NSImage
				let pageSize: CGSize = page.bounds(for: .mediaBox).size
				let pdfImage = page.thumbnail(of: pageSize, for: .mediaBox)
				return pdfImage
			}
			guard let image = NSImage(data: data as Data) else {
				// Fall back on converting the entire page to an NSImage
				let pageSize: CGSize = page.bounds(for: .mediaBox).size
				let pdfImage = page.thumbnail(of: pageSize, for: .mediaBox)
				return pdfImage
			}
			return image
		}
		
		return allPageImages
	}
	
	private static func extractFromImage(url: URL) async throws -> String {
		do {
			var resultText: String = ""
			// Build the request handler and perform the request
			let request = VNRecognizeTextRequest { (request, error) in
				let observations = request.results as? [VNRecognizedTextObservation] ?? []
				// Take the most likely result for each chunk, then send them all the stdout
				let obs : [String] = observations.map { $0.topCandidates(1).first?.string ?? ""}
				resultText = obs.joined(separator: "\n")
			}
			request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
			request.usesLanguageCorrection = true
			// Use different requests for different macOS version
			if #available(macOS 13.0, *) {
				request.revision = VNRecognizeTextRequestRevision3
			} else {
				request.revision = VNRecognizeTextRequestRevision2
			}
			// Determine and use language
			let languages: [String] = ["zh-cn", "en"]
			request.recognitionLanguages = languages
			guard let imgRef = NSImage(byReferencing: url).cgImage(forProposedRect: nil, context: nil, hints: nil) else {
				throw ExtractionError.decodeError
			}
			try VNImageRequestHandler(cgImage: imgRef, options: [:]).perform([request])
			return resultText
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	static func extractFromNSImage(nsImage: NSImage) throws -> String {
		do {
			var resultText: String = ""
			// build the request handler and perform the request
			let request = VNRecognizeTextRequest { (request, error) in
				let observations = request.results as? [VNRecognizedTextObservation] ?? []
				// take the most likely result for each chunk, then send them all the stdout
				let obs : [String] = observations.map { $0.topCandidates(1).first?.string ?? ""}
				resultText = obs.joined(separator: "\n")
			}
			request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
			request.usesLanguageCorrection = true
			request.revision = VNRecognizeTextRequestRevision2
			request.recognitionLanguages = ["zh-cn", "en"]
			guard let imgRef = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
				throw ExtractionError.decodeError
			}
			try VNImageRequestHandler(cgImage: imgRef, options: [:]).perform([request])
			return resultText
		} catch {
			throw ExtractionError.decodeError
		}
	}
	
	static func isRecognizedImage(url: URL) -> Bool {
		// Check if the image is in a recognized format
		let recognizedExtensions: [String] = ["png", "bmp", "jpg", "jpeg", "tiff", "webp", "heic"]
		return recognizedExtensions.contains(url.pathExtension)
	}
	
}
#endif
