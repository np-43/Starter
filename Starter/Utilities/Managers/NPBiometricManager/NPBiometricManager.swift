//
//  NPBiometricManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit
import LocalAuthentication

class NPBiometricManager: NSObject {
    
//    static let shared: NPBiometricManager = {
//        let instance = NPBiometricManager.init()
//        return instance
//    }()
    
    //Initializer access level change
    fileprivate override init(){}
    
    fileprivate var context = LAContext()

}

// MARK:- Dependency injection
protocol NPBiometricManagerInjection {
    var biometricManager: NPBiometricManager {get}
}

fileprivate var sharedManager: NPBiometricManager? = NPBiometricManager.init()

extension NPBiometricManagerInjection {
    
    var biometricManager: NPBiometricManager {
        if sharedManager == nil {
            self.reinitNPBiometricManager()
        }
        return sharedManager!
    }
    
    fileprivate func reinitNPBiometricManager() {
        sharedManager = NPBiometricManager.init()
    }
    
    func purgeNPBiometricManager() {
        sharedManager = nil
    }
    
}

extension LAContext {
    
    enum BiometricType {
        
        case none
        case touchID
        case faceID
        
        var displayText: String {
            switch self {
            case .none: return "None"
            case .touchID: return "Touch ID"
            case .faceID: return "Face ID"
            }
        }
        
        var errorMessage: String {
            switch self {
            case .none: return "No biometric option configured."
            case .touchID: return "Touch ID not configured/available."
            case .faceID: return "Face ID not configured/available."
            }
        }
        
    }

    fileprivate var biometricType: BiometricType {
        
        var error: NSError?
        
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch self.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
        
    }
    
}

extension NPBiometricManager {
    
    func isBiometricOptionAvailable(forType biometricType: LAContext.BiometricType) -> Bool {
        if biometricType != self.context.biometricType {
            return false
        }
        return true
    }
    
    func authenticateBiometric(forType biometricType: LAContext.BiometricType, _ completion: @escaping ((Bool, String)->())) {
        if biometricType != self.context.biometricType {
            completion(false, biometricType.errorMessage)
            return
        }
        self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please use your \(biometricType.displayText) to proceed further.") { (status, error) in
        var errorMessage: String = ""
            if status != true {
                errorMessage = error?.localizedDescription ?? "Unknown error raised"
                print(errorMessage)
            }
            completion(status, errorMessage)
        }
    }
    
}
