import Foundation

// Shared Resource
var x = 42
var xLock = NSLock()

DispatchQueue.concurrentPerform(iterations: 100) { _ in
    // Lock around the region of interest
    xLock.lock()
    var localCopy = x   // Read
    localCopy += 1      // Increment
    x = localCopy       // Write
    
    //print("x: \(x)")
    
    // Unlock after we finish the work
    xLock.unlock() // Deadlock if we forget to unlock the door!

}

print("end: \(x)") // What value will print?

// Race conditions lead to non-deterministic behaviors
// We cannot determine what will happen by looking at the code
// It may be different everytime it runs


// Create your own helper library of extensions or frameworks

extension NSLock {
    func withLock(_ work: () -> Void) {
        lock()
        work()
        unlock()
    }
}

DispatchQueue.concurrentPerform(iterations: 100) { _ in

    xLock.withLock {
        var localCopy = x   // Read
        localCopy += 1      // Increment
        x = localCopy       // Write
    }
}

print("withLock: \(x)")


//: [Next](@next)
