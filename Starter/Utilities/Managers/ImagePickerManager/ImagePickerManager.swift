//
//  ImagePickerManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import UIKit
import MobileCoreServices
import CropViewController

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias MediaPickingCompletionBlock = ((UIImage?)->())
    typealias MediaPickingCancelBlock = (()->())
    
//    static let shared: ImagePickerManager = {
//        let instance = ImagePickerManager.init()
//        return instance
//    }()
    
    //Initializer access level change
    fileprivate override init(){}
    
    fileprivate var didFinishPickingMedia: MediaPickingCompletionBlock?
    fileprivate var didCancelPickingMedia: MediaPickingCancelBlock?
    
    fileprivate var allowsEditing: Bool = false

}

// MARK:- Dependency injection
protocol ImagePickerManagerInjection {
    var imagePickerManager: ImagePickerManager {get}
}

fileprivate var sharedManager: ImagePickerManager? = ImagePickerManager.init()

extension ImagePickerManagerInjection {
    
    var imagePickerManager: ImagePickerManager {
        if sharedManager == nil {
            self.reinitImagePickerManager()
        }
        return sharedManager!
    }
    
    fileprivate func reinitImagePickerManager() {
        sharedManager = ImagePickerManager.init()
    }
    
    func purgeImagePickerManager() {
        sharedManager = nil
    }
    
}

extension ImagePickerManager {
    
    @discardableResult
    func presentUIImagePickerController(on view: UIView, withSourceType sourceType: UIImagePickerController.SourceType = .camera, allowsEditing: Bool = false, mediaTypes: [CFString] = [kUTTypeImage], cancelPicking: MediaPickingCancelBlock? = nil, finishPicking: MediaPickingCompletionBlock?) -> Bool {
        
        self.allowsEditing = allowsEditing
        if ((sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) || (sourceType == .photoLibrary && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary))) {
            let imagePickerController = UIImagePickerController.init()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.videoQuality = .typeHigh
            imagePickerController.sourceType = sourceType
            imagePickerController.mediaTypes = mediaTypes.map({$0 as String})//[kUTTypeMovie as String, kUTTypeImage as String]
            self.didCancelPickingMedia = cancelPicking
            self.didFinishPickingMedia = finishPicking
            
            //            imagePickerController.modalPresentationStyle = .popover
            
            if let popoverController = imagePickerController.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = view.bounds
                popoverController.permittedArrowDirections = [.up, .down]
            }
            
            GeneralUtility.currentViewController?.present(imagePickerController, animated: true, completion: {
            })
            
            return true
            
        } else {
            return false
        }
        
    }
    
    func presentUIImagePickerControllerSourceTypeActionSheet(on view: UIView, allowsEditing: Bool = false, mediaTypes: [CFString] = [kUTTypeImage], cancelPicking: MediaPickingCancelBlock? = nil, finishPicking: MediaPickingCompletionBlock?) {
        
        self.allowsEditing = allowsEditing
        let alertController = UIAlertController.init(title: "Choose source type", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let actionCamera = UIAlertAction.init(title: "Camera", style: UIAlertAction.Style.default) { (alertAction) in
            self.presentUIImagePickerController(on: view, withSourceType: UIImagePickerController.SourceType.camera, allowsEditing: allowsEditing, mediaTypes: mediaTypes, cancelPicking: cancelPicking, finishPicking: finishPicking)
        }
        let actionPhotoLibrary = UIAlertAction.init(title: "Photo library", style: UIAlertAction.Style.default) { (alertAction) in
            self.presentUIImagePickerController(on: view, withSourceType: UIImagePickerController.SourceType.photoLibrary, allowsEditing: allowsEditing, mediaTypes: mediaTypes, cancelPicking: cancelPicking, finishPicking: finishPicking)
        }
        let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.default) { (alertAction) in
        }
        
        alertController.addAction(actionCamera)
        alertController.addAction(actionPhotoLibrary)
        alertController.addAction(actionCancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
            popoverController.permittedArrowDirections = [.up, .down]
        }
        
        GeneralUtility.currentViewController?.present(alertController, animated: true, completion: {
        })
        
    }
    
}

extension ImagePickerManager: CropViewControllerDelegate {

    fileprivate func presentCropVC(withImage image: UIImage) {
        let cropVC = CropViewController.init(image: image)
        cropVC.delegate = self
        cropVC.aspectRatioPreset = .presetSquare
        cropVC.aspectRatioLockEnabled = true
        cropVC.aspectRatioPickerButtonHidden = true
        cropVC.resetButtonHidden = true
        GeneralUtility.currentViewController?.present(cropVC, animated: true, completion: nil)
    }

    internal func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.didCancelPickingMedia?()
        }
    }

    internal func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.didFinishPickingMedia?(image)
        }
    }

    internal func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.didFinishPickingMedia?(image)
        }
    }

}

extension ImagePickerManager {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            if self.allowsEditing == true {
                if image != nil {
                    self.presentCropVC(withImage: image!)
                    return
                }
            }
            self.didFinishPickingMedia?(image)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.didCancelPickingMedia?()
        }
    }
    
}
