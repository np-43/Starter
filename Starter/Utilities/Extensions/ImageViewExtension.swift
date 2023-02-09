//
//  ImageViewExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func downloadImage(fromURL stringURL: String?, placeHolderImage: UIImage? = nil, completion: ((Bool, UIImage?, Error?, URL?)->())? = nil) {
        // Default cache option is memory
        print("Downloading Image:\n\(stringURL ?? "")")
        if stringURL?.count ?? 0 <= 0 {
            self.image = placeHolderImage
            completion?(false, nil, nil, nil)
            return
        }
        let url = stringURL?.encodedURLLastPathComponent().toURL()
        self.sd_setImage(with: url, placeholderImage: placeHolderImage, options: SDWebImageOptions.refreshCached) { (image, error, imageCacheType, url) in
            var status = false
            if image != nil && error == nil {
                status = true
            } else {
                self.image = placeHolderImage
                print("Error downloading image:\n\(stringURL ?? "")\nError: \(error?.localizedDescription ?? "")")
            }
            completion?(status, image, error, url)
        }
        
    }
    
}

extension UIImage {
    
    class func createTabSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineHeight), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func downloadImage(fromURL stringURL: String?, progress: ((Int, Int, URL?)->())? = nil, completion:@escaping ((Bool, UIImage?, Error?, Data?)->())) {
        if stringURL?.count ?? 0 <= 0 {
            completion(false, nil, nil, nil)
            return
        }
        let url = stringURL?.encodedURLLastPathComponent().toURL()
        SDWebImageManager.shared.imageLoader.requestImage(with: url, options: SDWebImageOptions.refreshCached, context: nil, progress: { (receivedSize, expectedSize, targetURL) in
            progress?(receivedSize, expectedSize, targetURL)
        }) { (image, data, error, status) in
            completion(status, image, error, data)
        }
    }
    
    func savePNG(at path: String, completion: ((Bool, String, Data?)->())? = nil) {
        if let data = self.pngData() {
            do {
                try data.write(to: URL.init(fileURLWithPath: path))
                completion?(true, path, data)
            } catch {
                print("\n*************** Saving image error ***************\n\(error.localizedDescription)\n**************************************************\n")
                completion?(false, error.localizedDescription, nil)
            }
        }
    }
    
    func saveJPEG(withCompressionRatio compressionRatio: CGFloat, at path: String, completion: ((Bool, String, Data?)->())? = nil) {
        if let data = self.jpegData(compressionQuality: compressionRatio) {
            do {
                try data.write(to: URL.init(fileURLWithPath: path))
                completion?(true, path, data)
            } catch {
                print("\n*************** Saving image error ***************\n\(error.localizedDescription)\n**************************************************\n")
                completion?(false, error.localizedDescription, nil)
            }
        }
    }
    
}

extension UIButton {
    
    func downloadImage(fromURL stringURL: String?, placeHolderImage: UIImage? = nil, controlState: UIControl.State = .normal, completion: ((Bool, UIImage?, Error?, URL?)->())? = nil) {
        // Default cache option is memory
        print("Downloading Image:\n\(stringURL ?? "")")
        if stringURL?.count ?? 0 <= 0 {
            self.setImage(placeHolderImage, for: controlState)
            completion?(false, nil, nil, nil)
            return
        }
        let url = stringURL?.encodedURLLastPathComponent().toURL()
        self.sd_setImage(with: url, for: controlState, placeholderImage: placeHolderImage, options: SDWebImageOptions.refreshCached, progress: nil) { (image, error, imageCacheType, url) in
            var status = false
            if image != nil && error == nil {
                status = true
            } else {
                self.setImage(placeHolderImage, for: controlState)
                print("Error downloading image:\n\(stringURL ?? "")\nError: \(error?.localizedDescription ?? "")")
            }
            completion?(status, image, error, url)
        }
    }
    
}
