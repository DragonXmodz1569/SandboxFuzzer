import SwiftUI

@main
struct SandboxFuzzerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // 1) Ensure corpus folder exists in the app’s Documents
                    let fm = FileManager.default
                    guard let docs = fm.urls(
                            for: .documentDirectory,
                            in: .userDomainMask
                          ).first else {
                        fatalError("Unable to locate Documents directory")
                    }
                    let corpus = docs.appendingPathComponent("corpus")
                    if !fm.fileExists(atPath: corpus.path) {
                        try! fm.createDirectory(
                            at: corpus,
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                        print("🗂 Created corpus at \(corpus.path)")
                    }

                    // 2) Build C-style argv, passing corpus path
                    let args = [
                        "SandboxFuzzer",
                        "--corpus-path=\(corpus.path)",
                        // you can also append "--harness=imtranscoder" or similar if desired
                    ]
                    let cstrs = args.map { strdup($0) }
                    let argc = Int32(cstrs.count)
                    let argv = UnsafeMutablePointer(mutating:
                        cstrs.withUnsafeBufferPointer { $0.baseAddress! }
                    )

                    // 3) Call the shim, which runs libFuzzer
                    let exitCode = FuzzerMain(argc, argv)
                    print("🔚 FuzzerMain exited: \(exitCode)")

                    // 4) Free memory
                    for ptr in cstrs { free(ptr) }
                    argv.deallocate()
                }
        }
    }
}
