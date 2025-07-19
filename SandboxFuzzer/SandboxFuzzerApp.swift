// SandboxFuzzerApp.swift

import SwiftUI

@main
struct SandboxFuzzerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
              .task {
                // Kick off the fuzzer *once*:
                DispatchQueue.global(qos: .userInitiated).async {
                    let args = ["SandboxFuzzer",
                                "-max_len=4096",
                                // point at your corpus directory if you have one:
                                //"corpus/"
                    ]
                    let argc = Int32(args.count)
                    let cStrings = args.map { strdup($0) } + [nil]
                    let argv = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: cStrings.count)
                    argv.initialize(from: cStrings, count: cStrings.count)
                    _ = FuzzerMain(argc, argv)
                    // (This call never returns until the app quits or you manually exit.)
                }
              }
        }
    }
}
