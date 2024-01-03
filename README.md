# ExtensionKit

**ExtensionKit** is a Swift Package with additional functionality for Swift and SwiftUI.

# Installation

To install **ExtensionKit**, simply add it as a dependency to your Swift project using the Swift Package Manager. I recommend using the Xcode method personally via:

`File` → `Add Packages...` → `Search or Enter Package Url` → `https://github.com/johnbean393/ExtensionKit.git`

# Usage(Non-exhaustive)

To use ExtensionKit in your project, first import the framework:
```Swift
import ExtensionKit
```

### Array
```Swift
// Maps array in parallel
func parallelMap<T>(_ transform: (Element) -> T) -> [T]
```

### Color
```Swift
// Get intermediate color
func incrementColor(toColor: Color, percentage: Float) -> Color

// Example usage
let color: Color = Color.red.incrementColor(toColor: .green, percentage: 0.5) // Gives 50-50 mix between the colors red and green
```
When ExtensionKit is imported, Color automatically conforms to `Codable`

### Date
```Swift
// Init date from date components
init(month: Int, day: Int, year: Int, hour: Int = 0, minute: Int = 0, second: Int = 0)
```

### Double
```Swift
// Add leading and trailing zeros
func addZeros(wholeNumTarget: Int, fractionalTarget: Int) -> String

// Example usage
let price: Double = 9.9
print(price.addZeros(wholeNumTarget: 2)) // "09.9"
print(price.addZeros(wholeNumTarget: 2, fractionalTarget: 2)) // "09.90"
```

### Int
```Swift
// Add leading zeros
func addLeadingZeros(target: Int = 2) -> String

// Example usage
let serialNum: Double = 9
print(serialNum.addLeadingZeros()) // 09
print(serialNum.addLeadingZeros(target: 3)) // "009"
```

### ProcessInfo
```Swift
// Get processor architecture
var machineHardwareName: String?

// Example usage on Intel
print(ProcessInfo.processInfo.machineHardwareName!) // "x86_64"

// Example usage on Apple Silicon
print(ProcessInfo.processInfo.machineHardwareName!) // "arm64"
```

### String
```Swift
// Check if string is number
var isNumber: Bool

// Get lines in a string
var lines: [String]

// Convert camel case to words
func camelCaseToWords() -> String

// Example usage
let camelCase: String = "ExtensionKitIsTheBest"
print(camelCase.camelCaseToWords()) // "Pattonium Kit Is The Best"

// Wildcard match
func wildcard(pattern: String) -> Bool

// Example usage
print("201.93.92.123".wildcard(pattern: "201.93.9[23].???")) // true
print("201.93.93.001".wildcard(pattern: "201.93.9[23].???")) // true
print("docs.github.com".wildcard(pattern: "*.github.com")) // true

// Identify dominant language
func strDominantLanguage() throws -> String

// Example usage
print(try? "Hello, World".strDominantLanguage()) // "en"
```

### URL
```Swift
// Get POSIX filepath
func posixPath() -> String

// Example usage
let desktopUrl: URL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
print(desktopUrl.posixPath()) // "/Users/username/Desktop/"

// Check if directory contains item
func containsItem(itemUrl: URL) -> Bool

// Example usage
let desktopUrl: URL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
let item1Url: URL = desktopUrl.appendingPathComponent("test.txt")
let item2Url: URL = desktopUrl.appendingPathComponent("New Folder").appendingPathComponent("test.txt")
print(desktopUrl.containsItem(itemUrl: item1Url)) // true
print(desktopUrl.containsItem(itemUrl: item2Url)) // true

// List URLs of files in directory
func listDirectory() throws -> [URL]

// Get last modified date of file
func lastModifiedDate() throws -> Date

// Calculate size of directory in bits
func directorySize() -> Int64

// Check if file exists
func fileExists() -> Bool
```

### View
```Swift
// Apply a modifier conditionally
@ViewBuilder public func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View

// Example usage
struct ContentView: View {
	
	@State private var showBorder: Bool = false
	
    var body: some View {
        VStack {
		    Button("\(!showBorder ? "Show" : "Hide") Border") {
		        showBorder.toggle()
		    }
		    Circle()
		        .if(showBorder) { view in
		            view.border(Color.black)
		        }
        }
	}
	
}
```

### CliTools (Simple tools for the CLI) (macOS only)
```Swift
// Run a command in the terminal
func runCommand(command: String) -> String

// Example usage
print(runCommand(command: "echo 'Hello, World!'")) // "Hello, World!"

// Relaunch app after 'n' seconds
func relaunch(afterDelay seconds: TimeInterval = 5) -> Never
```

### FileSystemTools (Simple tools to manipulate the file system)
```Swift
// Example usage for FileSystemTools
FileSystemTools.functionName(parameters)


// Get "~/Desktop/" directory url (macOS only)
func getDesktopUrl() -> URL

// Get "~/Downloads/" directory url
func getDownloadsUrl() -> URL

// Get "~/Documents/" directory url
func getDocumentsUrl() -> URL

// Get "~/Library/Application Support/" directory url
func getAppSupportDirUrl() -> URL

// Open a panel for users to select a file (macOS only)
func openPanel(url: URL, files: Bool, folders: Bool, dialogTitle: String) throws -> URL

// Create a new directory
func createDirectory(url: URL)

// List contents of a directory
func listDirectory(dirUrl: URL) -> [URL]

// Open directory in Finder (macOS only)
func openDirectory(url: URL)

// Open window to AirDrop a file (macOS only)
func airDropFiles(urls: [URL]) throws
```

### ProcessorTools
```Swift
// Example usage for ProcessorTools
ProcessorTools.functionName(parameters)

// Check if processor if arm64
func isArmProcessor() -> Bool

// Get processor core count
func getCoreCount() -> Int
```

### TextExtractor (Extracts text from files) (macOS only)
```Swift
// Extract text from a file
// Supported file formats include txt, rtf, csv, py, swift, doc, docx, docm, pages, pptx, pdf, png, jpg, bmp, jpeg, tiff, webp, heic, and any other file that uses UTF8 encoding
func extractText(url: URL) async throws -> String

// Example usage
let text: String = try? await TextExtractor.extractText(url: URL(filePath: "/Users/username/Desktop/test.txt"))
print(text) // "Text in file" 
```

### ValueDataModel (Quick Data Models)
```Swift
// Example usage for ValueDataModel


//  Balloon.swift

import Foundation
import SwiftUI
import ExtensionKit

// Custom Balloon struct
struct Balloon: Identifiable, Codable, Equatable {
	
	var id: UUID = UUID()
	var color: Color
	var size: BalloonSize
	
	static func random() -> Balloon {
		let color: Color = [Color.red, Color.blue, Color.green, Color.orange, Color.pink].randomElement()!
		let size: BalloonSize = [.small, .medium, .large].randomElement()!
		return Balloon(color: color, size: size)
	}
	
}

enum BalloonSize: String, CaseIterable, Codable {
	case small, medium, large
}


//  BalloonData.swift


import Foundation
import ExtensionKit

// Inherit data model boilerplate code from ValueDataModel
class BalloonData: ValueDataModel<Balloon> {
	
	required init(appDirName: String = Bundle.main.applicationName ?? Bundle.main.description, datastoreName: String = "\(Bundle.main.applicationName ?? Bundle.main.description)Data") {
		super.init(appDirName: appDirName, datastoreName: datastoreName)
	}
	
	// Add new static property
	static let shared: BalloonData = BalloonData(appDirName: "ValueDataModel Test", datastoreName: "valueDataModelTest")
	
	// Add new method
	func deleteRandom() {
		if !values.isEmpty {
			print(0..<values.count)
			let randIndex: Int = Int.random(in: 0..<values.count)
			let _ = values.remove(at: randIndex)
		}
	}
	
}


//  ValueDataModel_DemoApp.swift


@main
struct ValueDataModel_DemoApp: App {
	
	// Use the object in your app
	@StateObject private var balloonData: BalloonData = BalloonData()
	
    var body: some Scene {
        WindowGroup {
			ContentView()
				.environmentObject(balloonData)
        }
    }
}


//  ContentView.swift


import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var balloonData: BalloonData
	
    var body: some View {
		VStack(alignment: .leading) {
			Button("Add Balloon") {
				withAnimation(.spring()) {
					balloonData.add(Balloon.random())
				}
			}
			Button("Pop a Balloon") {
				withAnimation(.spring()) {
					balloonData.deleteRandom()
				}
			}
			ForEach(balloonData.values) { balloon in
				BalloonView(balloon: balloon)
			}
		}
    }
}

#Preview {
    ContentView()
}
// 

```
