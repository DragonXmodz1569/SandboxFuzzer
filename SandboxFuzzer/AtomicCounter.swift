import Foundation

public final class AtomicCounter {
    private var count = 0
    private let lock = NSLock()
    
    public func increment() {
        lock.withLock {
            count += 1
        }
    }
    
    public var value: Int {
        lock.withLock {
            count
        }
    }
}

extension NSLock {
    func withLock<T>(_ body: () -> T) -> T {
        lock()
        defer { unlock() }
        return body()
    }
}
