import XCTest
import class Foundation.Bundle
import SnapshotTesting
import ImCore

final class ImTests: XCTestCase {
    @available(macOS 10.13, *)
    func test() throws {
#if !targetEnvironment(macCatalyst)
        try assertExecute()
        try assertExecute("--list")
        try assertExecute("--list-id")
        try assertExecute("--help")
        try assertExecute("--toggle")
        //Only test on case insensitive, because macOS by default is case insensitive, and I am ok with that
        try assertExecute("Dvorak")
        try assertExecute("com")
        try assertExecute("anyID")
#endif
    }
    override class func tearDown() {
        let im = InputSourceManager()
        im.initialize()
        try! im.select(id: "Dvorak")
    }
    // MARK: - Test Helper
    private func assertExecute(_ argv: String...,
                         file: StaticString = #file,
                               testName: String = #function,
                         line: UInt = #line
    ) throws {
        let im = productsDirectory.appendingPathComponent("im")
        
        let process = Process()
        process.executableURL = im
        process.arguments = argv
        let pipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        let output =  String(data: data, encoding: .utf8) ?? ""
        let named: String = argv.joined(separator: " ").emptyWith("none")
        assertSnapshot(matching: output, as: .lines, named: named, file: file,testName: testName,  line: line)
    }
}

private extension String {
    func emptyWith(_ string: String) -> String {
        self.isEmpty ? string : self
    }
}

/// Returns path to the built products directory.
var productsDirectory: URL {
#if os(macOS)
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
        return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError("couldn't find the products directory")
#else
    return Bundle.main.bundleURL
#endif
}
