import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Access the Documents directory
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let corpusURL = documentsURL.appendingPathComponent("corpus")

        // Create "corpus" directory if it doesn't exist
        if !fileManager.fileExists(atPath: corpusURL.path) {
            do {
                try fileManager.createDirectory(at: corpusURL, withIntermediateDirectories: true)
                print("✅ Created corpus directory at: \(corpusURL.path)")
            } catch {
                print("❌ Failed to create corpus directory: \(error)")
            }
        }

        // Change working directory to Documents so "./corpus/" works
        if chdir(documentsURL.path) != 0 {
            print("❌ Failed to change working directory to: \(documentsURL.path)")
        } else {
            print("📂 Working directory set to: \(documentsURL.path)")
        }

        return true
    }
}
