//
//  DispatchQueueExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation

extension DispatchQueue {
    
    class func mainQueue(_ block: @escaping (()->())) {
        if Thread.current.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
}
