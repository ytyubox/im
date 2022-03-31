import XCTest
import class Foundation.Bundle
import SnapshotTesting

final class ImTests: XCTestCase {
    @available(macOS 10.13, *)
    func test() throws {
        
        #if !targetEnvironment(macCatalyst)
        assertSnapshot(matching: try execute(), as: .lines, named: "none")
        assertSnapshot(matching: try execute("--list"), as: .lines, named: "--list")
        assertSnapshot(matching: try execute("--help"), as: .lines, named: "--help")
        #endif
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
    private func execute(_ argv: String...) throws -> String {
        let im = productsDirectory.appendingPathComponent("im")
        
        let process = Process()
        process.executableURL = im
        process.arguments = argv
        let pipe = Pipe()
        process.standardOutput = pipe
        
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

