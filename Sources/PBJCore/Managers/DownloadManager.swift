// Copyright 2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/snippets/ios/urlsession-background-downloads/

//
//  AppDelegate.swift
//  stars2apples
//
//  Created by Ian Clawson on 1/27/18.
//  Copyright © 2018 Ian Clawson Apps. All rights reserved.
//

import Foundation

class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static var shared = DownloadManager()
    
    private var session: URLSession?
    var activeDownloadTasks: [URLSessionDownloadTask] = []
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "\(Bundle.main.bundleIdentifier!).background-queue"
        queue.qualityOfService = QualityOfService.background
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    #if !os(macOS)
    typealias ProgressHandler = (Float) -> ()
    typealias EndHandler = (Data?, Error?) -> ()
    var onProgress : ProgressHandler?
    var onFinish : EndHandler?
    #endif
    
    private override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func start(_ url: URL) {
        downloadQueue.addOperation {
            print("<><><><><><><><><><><> - start")
            guard let downloadTask = self.session?.downloadTask(with: url) else { return }
            self.activeDownloadTasks.append(downloadTask)
            downloadTask.resume()
        }
    }
    
    func cancel() {
        print("<><><><><><><><><><><> - cancel")
        activeDownloadTasks.forEach({ $0.cancel() })
        self.onProgress = nil
        self.onFinish = nil
    }
    
    // HELPERS
    
    private func calculateProgress(session : URLSession, completionHandler : @escaping (Float) -> ()) {
        print("<><><><><><><><><><><> - calculateProgress")
        session.getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            let progress = downloads.map({ (task) -> Float in
                if task.countOfBytesExpectedToReceive > 0 {
                    return Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                } else {
                    return 0.0
                }
            })
            completionHandler(progress.reduce(0.0, +))
        }
    }
    
    // DELEGATE METHODS
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        #if !os(macOS)
        
        if totalBytesExpectedToWrite > 0 {
            if let onProgress = onProgress {
                calculateProgress(session: session, completionHandler: onProgress)
            }
            print("<><><><><><><><><><><> - \(downloadTask) \(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))")
        }
        #endif
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        #if !os(macOS)
        do {
            let downloadedData = try Data(contentsOf: location)
            DispatchQueue.main.async(execute: {
                print("<><><><><><><><><><><> - INSIDE DispatchQueue.main.async execute")
                print(downloadedData)
                
                if let onFinish = self.onFinish {
                    print("<><><><><><><><><><><> - INSIDE ON FINISHE")
                    onFinish(downloadedData, nil)
                } else {
                    print("<><><><><><><><><><><> - on finish not ready? :( ")
                }
                
                // invalidate handlers
                self.cancel()
            })
        } catch {
            print(error.localizedDescription)
        }
        #endif
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("<><><><><><><><><><><> Task completed: \(task), error: \(error)")
            print(error)
            if let onFinish = self.onFinish {
                onFinish(nil, error)
            }
        }
    }
    
    #if !os(macOS)
//    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        DispatchQueue.main.async {
//            self.savedCompletionHandler?()
//            self.savedCompletionHandler = nil
//        }
//    }
    #endif
    
}
