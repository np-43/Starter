//
//  TextFieldExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit

extension UITextField {
    
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setHorizontalPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    @IBInspectable
    var rightImage: UIImage? {
        get {
            return ((self.rightView as? UIStackView)?.arrangedSubviews.first(where: {$0 is UIImageView}) as? UIImageView)?.image
        }
        set {
            self.setRightImage(newValue)
        }
    }
    
    func setRightImage(_ image: UIImage?, size: CGFloat = 14, padding: CGFloat = 0) {
        
        if image == nil {
            return
        }
        
        let stackView = UIStackView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: size + padding, height: size)))
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        let imageView = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: size, height: size)))
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(imageView)
        
        if padding > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
            paddingView.addConstraint(NSLayoutConstraint.init(item: paddingView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: padding))
            stackView.addArrangedSubview(paddingView)
        }
        
        self.rightViewMode = .always
        self.rightView = stackView
        
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        get {
            return ((self.leftView as? UIStackView)?.arrangedSubviews.first(where: {$0 is UIImageView}) as? UIImageView)?.image
        }
        set {
            self.setLeftImage(newValue)
        }
    }
    
    /**
     Method set left image tp textfield
     - parameter image: Represent image to set
     */
    func setLeftImage(_ image: UIImage?, size: CGFloat = 14, padding: CGFloat = 0) {
        
        if image == nil {
            return
        }
        
        let stackView = UIStackView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: size + padding, height: size)))
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        if padding > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
            paddingView.addConstraint(NSLayoutConstraint.init(item: paddingView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: padding))
            stackView.addArrangedSubview(paddingView)
        }
        
        let imageView = UIImageView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: size, height: size)))
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(imageView)
        
        self.leftViewMode = .always
        self.leftView = stackView
        
    }
    
    func setRightView(_ view: UIView?, size: CGSize, padding: CGFloat = 0) {
        
        if view == nil {
            return
        }
        
        self.addHeightWidthConstraints(in: view!, size: size)
        
//        let stackView = UIStackView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: size.width + padding, height: size.height)))
        let stackView = UIStackView.init()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(view!)
        
        if padding > 0 {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
            paddingView.addConstraint(NSLayoutConstraint.init(item: paddingView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: padding))
            stackView.addArrangedSubview(paddingView)
        }
        
        self.rightViewMode = .always
        self.rightView = stackView
        
    }
    
    fileprivate func addHeightWidthConstraints(in view: UIView, size: CGSize) {
        view.addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: size.width))
        view.addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: size.height))
    }
}
