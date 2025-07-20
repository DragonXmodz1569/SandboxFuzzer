import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFileSystem()
        return true
    }
    
    func setupFileSystem() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("ERROR: Documents directory not found")
            return
        }
        
        // Create SandboxFuzzer directory
        let appDirectory = documentsURL.appendingPathComponent("SandboxFuzzer")
        do {
            try fileManager.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        } catch {
            print("ERROR creating app directory: \(error)")
        }
        
        // Create corpus directory
        let corpusDirectory = appDirectory.appendingPathComponent("corpus")
        do {
            try fileManager.createDirectory(at: corpusDirectory, withIntermediateDirectories: true)
            print("Created corpus directory: \(corpusDirectory.path)")
        } catch {
            print("ERROR creating corpus directory: \(error)")
        }
        
        // Copy bundle corpus to Documents
        if let bundleCorpusURL = Bundle.main.url(forResource: "corpus", withExtension: nil) {
            copyBundleCorpus(from: bundleCorpusURL, to: corpusDirectory)
        }
    }
    
    func copyBundleCorpus(from source: URL, to destination: URL) {
        let fileManager = FileManager.default
        
        do {
            // Get list of files in bundle corpus
            let bundleFiles = try fileManager.contentsOfDirectory(atPath: source.path)
            
            for file in bundleFiles {
                let sourceFile = source.appendingPathComponent(file)
                let destFile = destination.appendingPathComponent(file)
                
                // Remove existing file if present
                if fileManager.fileExists(atPath: destFile.path) {
                    try fileManager.removeItem(at: destFile)
                }
                
                // Copy new file
                try fileManager.copyItem(at: sourceFile, to: destFile)
                print("Copied: \(file)")
            }
        } catch {
            print("ERROR copying corpus: \(error)")
        }
    }
}
