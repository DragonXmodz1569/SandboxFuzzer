import UIKit
import SwiftUI
import Darwin  // for chdir()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let corpusURL = documentsURL.appendingPathComponent("corpus")

        // Create corpus directory if missing
        if !fileManager.fileExists(atPath: corpusURL.path) {
            do {
                try fileManager.createDirectory(at: corpusURL, withIntermediateDirectories: true, attributes: nil)
                print("✅ Created corpus directory at: \(corpusURL.path)")
            } catch {
                print("❌ Failed to create corpus directory: \(error)")
            }
        }

        // Set working directory to Documents
        if chdir(documentsURL.path) != 0 {
            print("❌ Failed to change working directory to: \(documentsURL.path)")
        } else {
            print("📂 Working directory set to: \(documentsURL.path)")
        }

        // Log contents of corpus directory
        do {
            let files = try fileManager.contentsOfDirectory(atPath: corpusURL.path)
            print("📁 Corpus directory contains: \(files)")
        } catch {
            print("❌ Failed to list corpus directory: \(error)")
        }

        // Copy built-in seeds from bundle into corpus
        copySeedFilesToCorpus(from: fileManager, to: corpusURL)

        // Show UI
        let contentView = ContentView()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()

        return true
    }

    func copySeedFilesToCorpus(from fileManager: FileManager, to corpusURL: URL) {
        let seedImageNames = ["seed1.jpg", "seed2.png"]

        for imageName in seedImageNames {
            if let bundleURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
                let destURL = corpusURL.appendingPathComponent(imageName)
                if !fileManager.fileExists(atPath: destURL.path) {
                    do {
                        try fileManager.copyItem(at: bundleURL, to: destURL)
                        print("✅ Copied \(imageName) to corpus folder")
                    } catch {
                        print("❌ Failed to copy \(imageName): \(error)")
                    }
                } else {
                    print("ℹ️ \(imageName) already exists in corpus folder")
                }
            } else {
                print("❌ \(imageName) not found in app bundle")
            }
        }
    }
}
