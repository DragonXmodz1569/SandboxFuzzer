import UIKit
import SwiftUI
import Darwin  // for chdir()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Setup SwiftUI root view
        let contentView = ContentView()

        // Create UIWindow and set rootViewController to UIHostingController hosting ContentView
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let corpusURL = documentsURL.appendingPathComponent("corpus")

        if !fileManager.fileExists(atPath: corpusURL.path) {
            do {
                try fileManager.createDirectory(at: corpusURL, withIntermediateDirectories: true, attributes: nil)
                print("✅ Created corpus directory at: \(corpusURL.path)")
            } catch {
                print("❌ Failed to create corpus directory: \(error)")
            }
        }

        if !fileManager.fileExists(atPath: documentsURL.path) {
            print("❌ Documents directory does not exist: \(documentsURL.path)")
        } else if chdir(documentsURL.path) != 0 {
            print("❌ Failed to change working directory to: \(documentsURL.path)")
        } else {
            print("📂 Working directory set to: \(documentsURL.path)")
            print("ℹ️ Current working directory is now: \(FileManager.default.currentDirectoryPath)")
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: corpusURL.path)
            print("📁 Corpus directory contains: \(files)")
        } catch {
            print("❌ Failed to list corpus directory: \(error)")
        }

        copySeedFilesToCorpus(from: fileManager, to: corpusURL)

        return true
    }

    func copySeedFilesToCorpus(from fileManager: FileManager, to corpusURL: URL) {
        if let resourcePath = Bundle.main.resourcePath {
            print("App bundle resource path: \(resourcePath)")
            do {
                let files = try fileManager.contentsOfDirectory(atPath: resourcePath)
                print("Files in bundle resource path: \(files)")
            } catch {
                print("Failed to list bundle resource path: \(error)")
            }
        }

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
