import UIKit
import SwiftUI
import Darwin // for chdir()

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
                try fileManager.createDirectory(at: corpusURL, withIntermediateDirectories: true)
                print("✅ Created corpus directory at: \(corpusURL.path)")
            } catch {
                print("❌ Failed to create corpus directory: \(error)")
            }
        } else {
            print("📂 Corpus directory already exists at: \(corpusURL.path)")
        }

        // Set working directory to Documents folder for libFuzzer relative path usage
        if chdir(documentsURL.path) != 0 {
            print("❌ Failed to change working directory to: \(documentsURL.path)")
        } else {
            print("📁 Working directory set to: \(FileManager.default.currentDirectoryPath)")
        }

        // List corpus files with sizes for debug
        do {
            let corpusFiles = try fileManager.contentsOfDirectory(at: corpusURL, includingPropertiesForKeys: [.fileSizeKey], options: [])
            for fileURL in corpusFiles {
                let size = try fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? -1
                print("📄 \(fileURL.lastPathComponent) - \(size) bytes")
            }
        } catch {
            print("❌ Failed to list corpus files: \(error)")
        }

        // Copy bundled seed files to corpus folder if missing
        copySeedFilesToCorpus(from: fileManager, to: corpusURL)

        // Setup SwiftUI UI
        let contentView = ContentView()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()

        return true
    }

    func copySeedFilesToCorpus(from fileManager: FileManager, to corpusURL: URL) {
        let seedFiles = ["seed1.jpg", "seed2.png"]

        guard let bundleResourcePath = Bundle.main.resourcePath else {
            print("❌ Could not get app bundle resource path")
            return
        }

        do {
            let bundleFiles = try fileManager.contentsOfDirectory(atPath: bundleResourcePath)
            print("🗂️ App bundle resource files: \(bundleFiles)")
        } catch {
            print("❌ Failed to list app bundle resources: \(error)")
        }

        for seedFile in seedFiles {
            if let sourceURL = Bundle.main.url(forResource: seedFile, withExtension: nil) {
                let destURL = corpusURL.appendingPathComponent(seedFile)
                if !fileManager.fileExists(atPath: destURL.path) {
                    do {
                        try fileManager.copyItem(at: sourceURL, to: destURL)
                        print("✅ Copied \(seedFile) to corpus folder")
                    } catch {
                        print("❌ Failed to copy \(seedFile): \(error)")
                    }
                } else {
                    print("ℹ️ \(seedFile) already exists in corpus folder")
                }
            } else {
                print("❌ \(seedFile) not found in app bundle")
            }
        }
    }
}
