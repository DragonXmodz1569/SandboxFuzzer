// SandboxFuzzerApp.swift

import SwiftUI

@main
struct SandboxFuzzerApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .task {
          for _ in 0..<ProcessInfo.processInfo.processorCount {
            DispatchQueue.global(qos:.background).async {
              let base = [
                "SandboxFuzzer",
                "-max_len=4096", "-timeout=2",
                "-keep_going=1",
                "-artifact_prefix=/var/mobile/Documents/crashes/",
                "-merge=1",
                "/var/mobile/Documents/corpus/"
              ]
              let args = base + ["-seed=\(arc4random_uniform(UInt32.max - 1) + 1)"]
              runFuzzer(args)
            }
          }
        }
    }
  }

    func runFuzzer(_ args: [String]) {
        let argc = Int32(args.count)
        let cstrs = args.map { strdup($0) } + [nil]
        let argv = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: cstrs.count)
        argv.initialize(from: cstrs, count: cstrs.count)
        _ = FuzzerMain
        // never returns
    }
}
