func setupFileSystem() {
    let fileManager = FileManager.default

    guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        print("ERROR: Documents directory not found")
        return
    }

    let corpusDirectory = documentsURL.appendingPathComponent("corpus")

    do {
        try fileManager.createDirectory(at: corpusDirectory, withIntermediateDirectories: true)
        print("✅ Created or verified corpus directory at: \(corpusDirectory.path)")
    } catch {
        print("ERROR creating corpus directory: \(error)")
        return
    }

    // This version ensures you access the *blue* corpus folder
    guard let bundleCorpusURL = Bundle.main.url(forResource: "corpus", withExtension: nil) else {
        print("⚠️ WARNING: Bundle 'corpus' folder not found")
        return
    }

    do {
        let bundleFiles = try fileManager.contentsOfDirectory(at: bundleCorpusURL, includingPropertiesForKeys: nil)
        for file in bundleFiles {
            let dest = corpusDirectory.appendingPathComponent(file.lastPathComponent)

            if fileManager.fileExists(atPath: dest.path) {
                try fileManager.removeItem(at: dest)
            }

            try fileManager.copyItem(at: file, to: dest)
            print("📁 Copied \(file.lastPathComponent) to /Documents/corpus")
        }
    } catch {
        print("ERROR copying bundle corpus files: \(error)")
    }
}
