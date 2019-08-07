//
//  main.swift
//  iOS7-LockContention
//
//  Created by Paul Solt on 8/7/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import Foundation

var sharedResource = 0
let lock = NSLock()
let group = DispatchGroup()

let numberOfIterations = 20_000 // 20000

var startTime = Date()

for _ in 0..<numberOfIterations {
    group.enter()
    DispatchQueue.global().async {
        // Do work here
        lock.lock()
        
        sharedResource += 1
        //print(sharedResource)
        lock.unlock()
        
        group.leave()
        
    }
    
}
group.wait()    // This is a blocking call, no code below executes until this finishes (which depends on our enter/leave being balanced)


var endTime = Date()
var elapsedTime = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate

print("Time elapsed to add \(numberOfIterations): \(elapsedTime) seconds")


sharedResource = 0

let myQueue = DispatchQueue(label: "Shared Access Queue")
//print("Global qos: \(DispatchQueue.global().qos)")
//print("myQueue.qos: \(myQueue.qos)")

startTime = Date()

for _ in 0..<numberOfIterations {
    group.enter()
    
    // async
    myQueue.async {
//    DispatchQueue.global().async {

        sharedResource += 1
        group.leave()
    }
    
}

//print("waiting")
group.wait()
//print("done")

endTime = Date()

elapsedTime = endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate

print("Time elapsed to add \(numberOfIterations): \(elapsedTime) seconds")




//exit(20)  0 = Success, Anything else is failure

// Don't exit my app, keep it alive
RunLoop.current.run()
