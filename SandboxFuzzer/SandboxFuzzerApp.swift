import SwiftUI

@main
struct SandboxFuzzerApp: App {
    @StateObject private var fuzzManager = FuzzManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fuzzManager)
        }
    }
}

class FuzzManager: ObservableObject {
    @Published var iterations: UInt64 = 0
    @Published var isRunning = false

    private var timer: Timer?
    private let corpusPath: String

    init() {
        // Setup Documents/corpus
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
        let corpusURL = docs.appendingPathComponent("corpus")
        corpusPath = corpusURL.path

        try? fm.createDirectory(at: corpusURL, withIntermediateDirectories: true)

        // Copy bundled seeds if missing
        for seed in ["seed1.jpg", "seed2.png"] {
            if let src = Bundle.main.url(forResource: seed, withExtension: nil) {
                let dst = corpusURL.appendingPathComponent(seed)
                if !fm.fileExists(atPath: dst.path) {
                    try? fm.copyItem(at: src, to: dst)
                }
            }
        }
    }

    func startFuzz() {
        guard !isRunning else { return }
        isRunning = true

        // Poll iteration count
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.iterations = atomicLoadIterationCount()
            }
        }

        // Launch harness
        DispatchQueue.global(qos: .background).async {
            let exitCode = FuzzerHarness(self.corpusPath)
            print("🔚 Fuzzer exited with code: \(exitCode)")
            DispatchQueue.main.async {
                self.isRunning = false
                self.timer?.invalidate()
            }
        }
    }

    func stopFuzz() {
        // No built‑in stop; just stop UI updates
        timer?.invalidate()
        isRunning = false
    }
}
