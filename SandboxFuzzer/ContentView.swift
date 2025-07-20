import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    
    // Assuming AtomicCounter is implemented somewhere else and works correctly.
    // Or replace with a simple counter for demo.
    let atomicLoadIterationCount = AtomicCounter()

    private let updates = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            Text("Fuzz iterations: \(atomicLoadIterationCount.value)")
                .font(.title2)
                .padding()

            Button("Download Crashes") {
                // implement a tiny HTTP server or use Files app
            }
            .padding()
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
        }
        .onReceive(updates) { _ in
            atomicLoadIterationCount.increment()
        }
        .alert("Escape Found!", isPresented: $showAlert) {
          Button("OK") {}
        } message: {
          Text("A sandbox bypass was detected. Check /Documents/crashes/")
        }
    }
}
