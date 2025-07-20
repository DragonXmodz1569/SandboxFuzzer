import SwiftUI

@main
struct SandboxFuzzerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let fm = FileManager.default
                    guard let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        fatalError("Unable to locate Documents directory")
                    }
                    let corpus = docs.appendingPathComponent("corpus")
                    if !fm.fileExists(atPath: corpus.path) {
                        do {
                            try fm.createDirectory(at: corpus, withIntermediateDirectories: true, attributes: nil)
                            print("🗂 Created corpus at \(corpus.path)")
                        } catch {
                            print("❌ Failed to create corpus directory: \(error)")
                        }
                    }

                    do {
                        let files = try fm.contentsOfDirectory(atPath: corpus.path)
                        print("Corpus folder contains: \(files)")
                    } catch {
                        print("❌ Failed to list corpus folder: \(error)")
                    }

                    let args = [
                        "SandboxFuzzer",
                        "--corpus-path=\(corpus.path)",
                    ]

                    // Allocate argv properly
                    let cstrs = args.map { strdup($0) }
                    let argc = Int32(cstrs.count)

                    let argv = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: cstrs.count)
                    for i in 0..<cstrs.count {
                        argv[i] = cstrs[i]
                    }

                    let exitCode = FuzzerMain(argc, argv)
                    print("🔚 FuzzerMain exited: \(exitCode)")

                    for ptr in cstrs { free(ptr) }
                    argv.deallocate()
                }
        }
    }
}
