import SwiftUI

@main
struct SandboxFuzzerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    startFuzzing()
                }
        }
    }
    
    func startFuzzing() {
        Task {
            guard let corpusPath = getCorpusPath() else {
                print("ERROR: Corpus path not found")
                return
            }
            
            print("Starting fuzzer with corpus: \(corpusPath)")
            
            // Initialize and run fuzzer
            let fuzzer = FuzzerEngine()
            await fuzzer.run(withCorpusPath: corpusPath)
        }
    }
    
    func getCorpusPath() -> String? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentsURL
            .appendingPathComponent("SandboxFuzzer")
            .appendingPathComponent("corpus")
            .path
    }
}
