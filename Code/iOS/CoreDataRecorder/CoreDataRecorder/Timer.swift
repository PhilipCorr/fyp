//import CoreFoundation
// Usage:    var timer = RunningTimer.init()
// Start:    timer.start() to restart the timer
// Stop:     timer.stop() returns the time and stops the timer
// Duration: timer.duration returns the time
// May also be used with print(" \(timer) ")

//struct RunningTimer: CustomStringConvertible {
//
//}


//
//  timer.swift
//  CoreDataRecorder
//
//  Created by Student on 14/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation
import CoreFoundation

class Timer {
    
    var begin = 0.0
    var end = 0.0
    
//    init() {
//        begin = 0
//        end = 0
//    }
    func start() -> Double {
        return Double(CFAbsoluteTimeGetCurrent())
    }
    func stop() -> Double {
        if (end == 0) { end = CFAbsoluteTimeGetCurrent() }
        return Double(end - begin)
    }
    var duration:CFAbsoluteTime {
        get {
            if (end == 0) { return CFAbsoluteTimeGetCurrent() - begin }
            else { return end - begin }
        }
    }
    var description:String {
        let time = duration
        if (time > 100) {return " \(time/60) min"}
        else if (time < 1e-6) {return " \(time*1e9) ns"}
        else if (time < 1e-3) {return " \(time*1e6) µs"}
        else if (time < 1) {return " \(time*1000) ms"}
        else {return " \(time) s"}
    }
}
//    let startTime:CFAbsoluteTime
//    var endTime:CFAbsoluteTime?
//    
//    init() {
//        startTime = CFAbsoluteTimeGetCurrent()
//    }
//    
//    func stop() -> CFAbsoluteTime {
//        endTime = CFAbsoluteTimeGetCurrent()
//        
//        return duration!
//    }
//    
//    var duration:CFAbsoluteTime? {
//        if let endTime = endTime {
//            return endTime - startTime
//        } else {
//            return nil
//        }
//    }

