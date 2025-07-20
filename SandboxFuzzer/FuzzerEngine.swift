import Foundation

class FuzzerEngine {
    func run(withCorpusPath corpusPath: String) async {
        print("FuzzerEngine started")

        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: corpusPath, isDirectory: &isDirectory)

        guard exists && isDirectory.boolValue else {
            print("ERROR: Corpus directory not found at \(corpusPath)")
            return
        }

        do {
            let files = try fileManager.contentsOfDirectory(atPath: corpusPath)
            print("Found \(files.count) corpus files")

            for file in files {
                let filePath = (corpusPath as NSString).appendingPathComponent(file)
                print("Corpus file found: \(filePath)")
                await processFile(at: filePath)
            }
        } catch {
            print("Error reading corpus: \(error)")
        }
    }

    private func processFile(at path: String) async {
        print("Processing: \((path as NSString).lastPathComponent)")

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            print("File size: \(data.count) bytes")

            // Simulate processing time
            await Task.sleep(100_000_000) // 0.1 seconds

        } catch {
            print("Error processing file: \(error)")
        }
    }
}
