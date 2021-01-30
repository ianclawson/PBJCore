//
//  StartupManager.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/27/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

import Foundation

public typealias StartupManagerTask = () -> ()

public class StartupManager {
    
    public static let shared = StartupManager()
    
    var blocks: [StartupManagerTask] = []
    var startupFinished = false
    
    public func markStartupFinished() {
        if !startupFinished {
            startupFinished = true
            executeTasks()
        }
    }
    
    // Enqueues the task if startup sequence is in process
    // If startup is over, executes immediatly
    public func enqueueTask(_ task: @escaping StartupManagerTask) {
        guard startupFinished == false else { return task() }
        blocks.append(task)
    }
    
    func executeTasks() {
        blocks.forEach { (block) in
            block()
        }
        blocks.removeAll()
    }
}
