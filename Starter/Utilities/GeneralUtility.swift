//
//  GeneralUtility.swift
//  Starter
//
//  Created by Nikhil Patel on 08/02/23.
//

import Foundation
import UIKit
import MobileCoreServices
import SafariServices
import SVProgressHUD

struct GeneralUtility {
    
    typealias EmptyClosure = (()->())
    typealias BooleanClosure = ((Bool)->())
    
    static var currentViewController: UIViewController? {
        var currentVC: UIViewController?
        let rootVC = AppConstant.appDelegate.window?.rootViewController
        if let navController = rootVC as? UINavigationController  {
            currentVC = navController.topViewController
        } else {
            currentVC = rootVC
        }
        return currentVC
    }
    
    static var fileManager: FileManager = {
        let manager = FileManager.default
        return manager
    }()
    
}

extension GeneralUtility {
    
    enum AlertActionButton: Int, Equatable {
        
        case ok = 1
        case cancel
        case yes
        case no
        
        var title: String {
            switch self {
            case .ok:       return "OK"
            case .cancel:   return "CANCEL"
            case .yes:      return "Yes"
            case .no:       return "No"
            }
        }
        
    }
    
}

extension GeneralUtility {
    
    static func showProcessing(withFrame frame: CGRect = AppConstant.appDelegate.window!.bounds, message:String? = nil) {
        DispatchQueue.mainQueue {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setBackgroundColor(.white)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setFont(UIFont.font(.OpenSansRegular, fontSize: 15))
            SVProgressHUD.setForegroundColor(UIColor.black)

            if message?.count ?? 0 > 0{
                SVProgressHUD.show(withStatus: message)
            }
            else{
                SVProgressHUD.show()
            }
        }
    }
    
    static func endProcessing(completion: (()->())? = nil) {
        DispatchQueue.mainQueue {
            SVProgressHUD.dismiss() {
                completion?()
            }
        }
    }
    
}

extension GeneralUtility {
    
    static func showAlert(onVC vc: UIViewController? = GeneralUtility.currentViewController, withTitle title: String? = nil, message: String, alertActionButtons: [AlertActionButton] = [AlertActionButton.ok], completion: ((AlertActionButton)->())? = nil) {
//        let npAlertController = NPAlertController()
//        npAlertController.presentAlertController(withTitle: title, message: message, alertActionButtons: alertActionButtons.unique())
//        npAlertController.completion = completion
//        vc?.present(npAlertController, animated: true)
    }
    
    static func showDefaultAlert(onVC vc: UIViewController? = GeneralUtility.currentViewController, withTitle title: String? = nil, message: String, alertActionButtons:[AlertActionButton] = [AlertActionButton.ok], completion: ((AlertActionButton)->())? = nil) {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if alertActionButtons.count > 0 {
            let filterArray = alertActionButtons.unique()
            for alertActionButton in filterArray {
                alertController.addAction(GeneralUtility.getAlertAction(for: alertActionButton, completion: completion))
            }
        } else {
            alertController.addAction(GeneralUtility.getAlertAction(for: AlertActionButton.ok, completion: completion))
        }
        vc?.present(alertController, animated: true) {
        }
        
    }
    
    static fileprivate func getAlertAction(for alertActionButton: AlertActionButton, completion: ((AlertActionButton)->())?) -> UIAlertAction {
        switch alertActionButton {
        case .no:
            return UIAlertAction.init(title: alertActionButton.title, style: .destructive) { (_) in
                completion?(alertActionButton)
            }
        case .cancel:
            return UIAlertAction.init(title: alertActionButton.title, style: .cancel) { (_) in
                completion?(alertActionButton)
            }
        default:
            return UIAlertAction.init(title: alertActionButton.title, style: .default) { (_) in
                completion?(alertActionButton)
            }
        }
    }
    
}

extension GeneralUtility {
    
    /**
     Method to get document diectory path
     - returns String
     */
    static func documentDirectoryPath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        return documentDirectory!
    }
    
    /**
     Method to get download directory path and create Downloads directory if not present
     - returns String
     */
    static func downloadDirectoryPath() -> String {
        let documentDirectory = GeneralUtility.documentDirectoryPath()
        let downloadDirectory = documentDirectory.appending("/Downloads")
        if !(GeneralUtility.fileManager.fileExists(atPath: downloadDirectory)) {
            do {
                try GeneralUtility.fileManager.createDirectory(atPath: downloadDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory: \(error)")
            }
        }
        return downloadDirectory
    }
    
    /**
     Method to get image directory path and create Images directory if not present
      */
    static func imageDirectoryPath() -> String {
        let documentDirectory = GeneralUtility.documentDirectoryPath()
        let imageDirectory = documentDirectory.appending("/Images")
        if !(GeneralUtility.fileManager.fileExists(atPath: imageDirectory)) {
            do {
                try GeneralUtility.fileManager.createDirectory(atPath: imageDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory: \(error)")
            }
        }
        return imageDirectory
    }
    
    static func findFile(containingText: String, inURL url: URL) -> String? {
        if GeneralUtility.fileManager.fileExists(atPath: url.path) {
            guard let enumerator = GeneralUtility.fileManager.enumerator(atPath: url.path) else {return nil}
            let filePath = enumerator.allObjects.compactMap({$0 as? String}).first(where: {$0.contains(containingText)})
            print(filePath ?? "")
            return filePath
        }
        return nil
    }
    
    /**
     Method to delete file from directory path
     - parameter url: Represent path URL string from file to delete
     - parameter completion: Represent callback for delete completion
     */
    static func deleteFile(at url: URL, completion: ((Bool, String)->())) {
        if GeneralUtility.fileManager.fileExists(atPath: url.path) {
            do {
                try GeneralUtility.fileManager.removeItem(at: url)
                completion(true, "")
            } catch {
                print("Error ---- \(error)")
                completion(false, error.localizedDescription)
            }
        } else {
            completion(true, "")
        }
    }
    
    /**
     Method to delete file from directory path with specified extension
     - parameter url: Represent path URL string from file to delete
     - parameter ext: Represent file extension
     - parameter completion: Represent callback for delete completion
     */
    static func deleteFile(at url: URL, withExtension ext: String, completion: ((Bool, String)->())) {
        let finalURL = url.appendingPathExtension(ext)
        if GeneralUtility.fileManager.fileExists(atPath: finalURL.path) {
            do {
                try GeneralUtility.fileManager.removeItem(at: finalURL)
                completion(true, "")
            } catch {
                print("Error ---- \(error)")
                completion(false, error.localizedDescription)
            }
        } else {
            completion(false, "File doesn't exists.")
        }
    }
    
    static func getFileSize(at url: URL, completion: ((Bool, String, UInt64)->())) {
        if GeneralUtility.fileManager.fileExists(atPath: url.path) {
            do {
                let dictionary = try GeneralUtility.fileManager.attributesOfItem(atPath: url.path)
                let fileSize = dictionary[FileAttributeKey.size] as! UInt64
                completion(true, "", fileSize)
            } catch {
                print("Error ---- \(error)")
                completion(false, error.localizedDescription, 0)
            }
        }
    }
    
    static func getUniqueFilename() -> String {
        let uniqueName = Date.stringDate(fromDate: Date.init(), dateFormat: DateFormat.uniqueString)
        return uniqueName!
    }
    
}

extension GeneralUtility {
    
    static func openMail(withSenderEmail to: String, subject: String?, body: String?) {
        let stringURL = "mailto:\(to)?subject=\(subject ?? "")&body=\(body ?? "")"
        if let url = URL.init(string: stringURL.encodedURLQuery()) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (_) in
                }
            }
        }
    }
    
    static func shareURL(_ stringURL: String?, sourceView: UIView?) {
        if stringURL?.count ?? 0 > 0 {
            let activityViewController = UIActivityViewController.init(activityItems: [stringURL ?? ""], applicationActivities: nil)
            activityViewController.excludedActivityTypes = nil
            activityViewController.popoverPresentationController?.sourceView = sourceView ?? GeneralUtility.currentViewController?.view
            if sourceView != nil {
                activityViewController.popoverPresentationController?.sourceRect = sourceView!.bounds
            }
            activityViewController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
            GeneralUtility.currentViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    static func sharePDF(from: UIViewController, fileURL: URL?, sourceView: UIView?, completion: ((Bool)->())? = nil) {
        if fileURL != nil {
            guard let data = try? Data.init(contentsOf: fileURL!) else {return}
            let activityViewController = UIActivityViewController.init(activityItems: [data], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = sourceView ?? from.view
            if sourceView != nil {
                activityViewController.popoverPresentationController?.sourceRect = (sourceView ?? from.view).bounds
            }
            activityViewController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
            activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                completion?(completed)
            }
            from.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}

extension GeneralUtility {
    
    static func isNonEmptyString(_ text: String?, includingSpace: Bool = false) -> Bool {
        if includingSpace == true {
            return (text?.trimmed().count ?? 0) > 0
        }
        return (text?.count ?? 0) > 0
    }
    
    static func isValidEmail(_ email: String?) -> Bool {
        if (email?.count ?? 0) > 0 {
            let regexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            do {
                let regex = try NSRegularExpression.init(pattern: regexPattern, options: NSRegularExpression.Options.caseInsensitive)
                let regexMatches = regex.numberOfMatches(in: email!, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: email!.count))
                if regexMatches == 0 {
                    return false
                } else {
                    return true
                }
            } catch {
                print(error)
            }
        }
        return false
    }
    
    static func isValidPhone(_ phone: String?) -> Bool {
        if phone?.count ?? 0 > 0 {
            let regexPattern = "^[0-9]\\d{9}$"
            do {
                let regex = try NSRegularExpression.init(pattern: regexPattern, options: NSRegularExpression.Options.caseInsensitive)
                let regexMatches = regex.numberOfMatches(in: phone!, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: phone!.count))
                if regexMatches == 0 {
                    return false
                } else {
                    return true
                }
            } catch {
                print(error)
            }
        }
        return false
    }
    
    static func validateNumberWith2DecimalTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, max: Double? = nil) -> Bool {
        
        if string.count > 0 && string != "." && Double.init(string) == nil {
            return false
        }
        if textField.text?.contains(".") ?? false {
            if string == "." {
                return false
            }
            let afterDecimal = textField.text!.components(separatedBy: ".").last ?? ""
            if afterDecimal.count > 1 && string.count > 0 {
                return false
            }
        }
        if textField.text?.count ?? 0 == 0 && (string == "." || string == "0") {
            textField.text = "0."
            return false
        }
        if textField.text == "0." && string.count == 0 {
            textField.text = ""
            return false
        }
        if max != nil {
            var enteredAmountStr = textField.text
            if string.count > 0 {
                enteredAmountStr?.append(string)
            } else {
                enteredAmountStr?.removeSubrange(Range.init(range, in: textField.text ?? "")!)
            }
            let enteredAmt = enteredAmountStr?.toDouble() ?? 0
            return (enteredAmt <= max!)
        }
        return true
        
    }
    
    static func validateOnlyNumberTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 {
            return true
        } else if let _ = Int(string) {
            return true
        }
        return false
    }
    
}


