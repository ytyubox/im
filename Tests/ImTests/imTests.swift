import class Foundation.Bundle
@testable import im
import ImCore
import SnapshotTesting
import XCTest

final class ImTests: XCTestCase {
  @available(macOS 10.13, *)
  func testGet() throws {
    try assertExecute()
    try assertExecute("--show-id")
  }
    
  @available(macOS 10.13, *)
  func testInit() throws {
    try assertExecute("--help")
    try assertExecute("--version")
    try assertExecute()
    try assertExecute("--last")
  }

  func testList() throws {
    try assertExecute("--list")
    try assertExecute("--list-id")
  }

  func testSetIM() throws {
    // Only test on case insensitive, because macOS by default is case insensitive, and I am ok with that
    try assertExecute("Dvorak")
    try assertExecute("com")
    try assertExecute("anyID")
  }
    
  func testLast() throws {
    try assertExecute("--last")
    try assertExecute("Dvorak")
    try assertExecute("--set-last", "Dvorak", namePlus: "ShouldFail-TheSameAsCurrent")
    try assertExecute("--set-last", "AnyNAME")
    try assertExecute("--set-last", "Pinyin")
    try assertExecute("--last", namePlus: "ShouldBePinyin")
  }
    
  // MARK: - Test Helper

  override func setUp() {
    storage.removePersistentDomain(forName: "test.im")
  }

  override func tearDown() {
    storage.removePersistentDomain(forName: "test.im")
  }

  private let storage = UserDefaults(suiteName: "test.im")!
    
  private func assertExecute(_ argv: String...,
                             namePlus: String = "",
                             record recording: Bool = false,
                             file: StaticString = #file,
                             testName: String = #function,
                             line: UInt = #line) throws
  {
#if !targetEnvironment(macCatalyst)

    let im = productsDirectory.appendingPathComponent("im")
        
    let process = Process()
    process.executableURL = im
    let debug = Debug(
      suitName: "test.im",
      current: InputSource(id: "com.ABC", name: "ABC"),
      inputSources: [
        InputSource(id: "com.Dvorak", name: "Dvorak"),
        InputSource(id: "com.Shuangpin", name: "Shuangpin - Traditional"),
        InputSource(id: "com.ABC", name: "ABC"),
        InputSource(id: "com.Zhuyin", name: "Zhuyin - Traditional"),
        InputSource(id: "com.Pinyin", name: "Pinyin - Traditional"),
      ])
    let json = try JSONEncoder().encode(debug)
        
    process.arguments = argv + ["--debug", try XCTUnwrap(String(data: json, encoding: .utf8))]
    let pipe = Pipe()
        
    process.standardOutput = pipe
    process.standardError = pipe
        
    try process.run()
    process.waitUntilExit()
        
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
    let output = String(data: data, encoding: .utf8) ?? ""
    let named: String = argv.joined(separator: " ").emptyWith("none") + namePlus
    assertSnapshot(matching: output, as: .lines, named: named, record: recording, file: file, testName: testName, line: line)
#endif
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
