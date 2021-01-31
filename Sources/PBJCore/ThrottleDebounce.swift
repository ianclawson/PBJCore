//
//  ThrottleDebounce.swift
//  PBJCore
//
//  Created by Ian Clawson on 4/27/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

private extension TimeInterval {

    /**
     Checks if `since` has passed since `self`.
     
     - Parameter since: The duration of time that needs to have passed for this function to return `true`.
     - Returns: `true` if `since` has passed since now.
     */
    func hasPassed(since: TimeInterval) -> Bool {
        return Date().timeIntervalSinceReferenceDate - self > since
    }

}

class Throttler {
    
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
   
    /**
    Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
    
    - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
    - Parameter queue: The queue to perform the action on. Defaults to the main queue.
    - Parameter action: A function to throttle.
    
    - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
    */
    func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
        
        return { [weak self] in
            guard let self = self else { return }
            guard self.currentWorkItem == nil else { return }
            self.currentWorkItem = DispatchWorkItem {
                action()
                self.lastFire = Date().timeIntervalSinceReferenceDate
                self.currentWorkItem = nil
            }
            delay.hasPassed(since: self.lastFire) ? queue.async(execute: self.currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
        }
    }
}

class Debouncer {
    
    var currentWorkItem: DispatchWorkItem?
    
    /**
    Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.
    
    - Parameter delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
    - Parameter queue: The queue to perform the action on. Defaults to the main queue.
    - Parameter action: A function to debounce. Can't accept any arguments.
    
    - Returns: A new function that will only call `action` if `delay` time passes between invocations.
    */
    func debounce(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
        return {  [weak self] in
            guard let self = self else { return }
            self.currentWorkItem?.cancel()
            self.currentWorkItem = DispatchWorkItem { action() }
            queue.asyncAfter(deadline: .now() + delay, execute: self.currentWorkItem!)
        }
    }
}
