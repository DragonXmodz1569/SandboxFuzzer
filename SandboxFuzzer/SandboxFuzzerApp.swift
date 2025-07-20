import SwiftUI

@main
struct SandboxFuzzerApp: App {
    @StateObject private var manager = FuzzManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
                .onAppear { manager.startFuzz() }
        }
    }
}

class FuzzManager: ObservableObject {
    @Published var iterations: UInt64 = 0
    @Published var isRunning = false

    private var timer: Timer?
    private let corpusPath: String

    init() {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let corpus = docs.appendingPathComponent("corpus")
        corpusPath = corpus.path
        try? fm.createDirectory(at: corpus, withIntermediateDirectories: true)
        for seed in ["seed1.jpg","seed2.png"] {
            if let src = Bundle.main.url(forResource: seed, withExtension: nil) {
                let dst = corpus.appendingPathComponent(seed)
                if !fm.fileExists(atPath: dst.path) {
                    try? fm.copyItem(at: src, to: dst)
                }
            }
        }
    }

    func startFuzz() {
        guard !isRunning else { return }
        isRunning = true
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.iterations = atomicLoadIterationCount()
            }
        }
        DispatchQueue.global(qos:.background).async {
            print("🔍 [Swift] calling FuzzerHarness at \(self.corpusPath)")
            let code = FuzzerHarness(self.corpusPath)
            print("🔚 [Swift] harness exited \(code)")
            DispatchQueue.main.async {
                self.isRunning = false
                self.timer?.invalidate()
            }
        }
    }

    func stopFuzz() {
        timer?.invalidate(); isRunning = false
    }
}
