import SwiftUI

struct ContentView: View {
    @State private var logMessages: [String] = []
    
    var body: some View {
        VStack {
            Text("Sandbox Fuzzer")
                .font(.title)
                .padding()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(logMessages, id: \.self) { message in
                        Text(message)
                            .font(.system(size: 12, design: .monospaced))
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.green)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            // Capture print output
            captureConsoleOutput()
        }
    }
    
    func captureConsoleOutput() {
        // This is a simplified approach - in a real app you'd use a logger
        // that pipes to SwiftUI. For demo purposes, we'll just show static info.
        logMessages = [
            "Sandbox Fuzzer v1.0",
            "iOS \(UIDevice.current.systemVersion)",
            "Device: \(UIDevice.current.model)",
            "Corpus path: \(getCorpusPath() ?? "N/A")"
        ]
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
