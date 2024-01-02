# PattoniumKit

**PattoniumKit** is a Swift Package with additional functionality for Swift and SwiftUI.

# Installation

To install **PattoniumKit**, simply add it as a dependency to your Swift project using the Swift Package Manager. I recommend using the Xcode method personally via:

`File` → `Add Packages...` → `Search or Enter Package Url` → `https://github.com/johnbean393/PattoniumKit.git`

# Usage (Non-exhaustive)

To use PattoniumKit in your project, first import the framework:
```Swift
import PattoniumKit
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
When PattoniumKit is imported, Color automatically conforms to `Codable`

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
let camelCase: String = "pattoniumKitIsTheBest"
print(camelCase.camelCaseToWords()) // "Pattonium Kit Is The Best"

// Wildcard match
func wildcard(pattern: String) -> Bool

// Example usage
print("201.93.92.123".wildcard("201.93.9[23].???")) // true
print("201.93.93.001".wildcard("201.93.9[23].???")) // true
print("docs.github.com".wildcard("*.github.com")) // true

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

### CliTools (macOS only)
```Swift
// Run a command in the terminal
func runCommand(command: String) -> String

// Example usage
print(runCommand(command: "echo 'Hello, World!'")) // "Hello, World!"

// Relaunch app after 'n' seconds
func relaunch(afterDelay seconds: TimeInterval = 5) -> Never
```

### FileSystemTools
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

### TextExtractor (macOS only)
```Swift
// Extract text from a file
// Supported file formats include txt, rtf, csv, py, swift, doc, docx, docm, pages, pptx, pdf, png, jpg, bmp, jpeg, tiff, webp, heic, and any other file that uses UTF8 encoding
func extractText(url: URL) async throws -> String

// Example usage
let text: String = await try? TextExtractor.extractText(url: URL(filePath: "/Users/username/Desktop/test.txt"))
print(text) // "Text in file" 
```
