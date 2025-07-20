import SwiftUI

struct ContentView: View {
    @EnvironmentObject var fuzzManager: FuzzManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Fuzz iterations: \(fuzzManager.iterations)")
                .font(.title2)
                .padding()

            if fuzzManager.isRunning {
                Button("Stop Fuzzer") {
                    fuzzManager.stopFuzz()
                }
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            } else {
                Button("Start Fuzzer") {
                    fuzzManager.startFuzz()
                }
                .padding()
                .background(Color.green.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
