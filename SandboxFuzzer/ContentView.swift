import SwiftUI

struct ContentView: View {
    @State private var iterations: UInt64 = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            Text("Fuzz iterations: \(iterations)")
              .font(.title2)
              .padding()

            Button("Quit") {
                exit(0)
            }
            .padding()
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
        }
        .onAppear {
            // Start a timer that fires every 0.1s
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                // Read the C atomic counter
                iterations = UInt64(gFuzzIterationCount)
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}
