import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: FuzzManager
    var body: some View {
        VStack(spacing: 20) {
            Text("Iterations: \(manager.iterations)")
                .font(.title2)
            if manager.isRunning {
                Button("Stop") { manager.stopFuzz() }
                    .padding().background(Color.red).foregroundColor(.white).cornerRadius(8)
            } else {
                Button("Start") { manager.startFuzz() }
                    .padding().background(Color.green).foregroundColor(.white).cornerRadius(8)
            }
        }
        .padding()
    }
}
