//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)


var sharedResource = 10
var lock = NSLock()

// Add lock/unlock statements to protect the sharedResource

//: ## Challenge: Make this thread safe

//func doWorkOnMultipleThreads() -> Bool {
//    var x = 5
//    sharedResource *= 10
//    if sharedResource < 1000 {
//        return false
//    } else if sharedResource > 1000 && sharedResource < 1500 {
//        sharedResource *= 2
//        return true
//    } else {
//        sharedResource -= 100
//    }
//    sharedResource += 5
//    return true
//}

//: Solution

func doWorkOnMultipleThreads() -> Bool {
    var x = 5   // no locks required for non-shared state
    lock.lock()
    sharedResource *= 10
    lock.unlock()
    
    lock.lock() // technically we can keep lock from above and avoid relocking
    if sharedResource < 1000 {
        lock.unlock()
        return false
    } else if sharedResource > 1000 && sharedResource < 1500 {
        sharedResource *= 2
        lock.unlock()
        return true
    } else {
        sharedResource -= 100
        lock.unlock()
    }
    // because code can early exit, we need to unlock for all cases
    // and then grab lock again for this next section
    lock.lock()
    sharedResource += 5
    lock.unlock()
    
    return true
}

print("doWork")
doWorkOnMultipleThreads()
print("finish: < 1000")

sharedResource = 1200
doWorkOnMultipleThreads()
print("finish: > 1000 && < 1500")

sharedResource = 2000
doWorkOnMultipleThreads()
print("finish: > 1500")
