//
//  CollectionViewExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit
import SVPullToRefresh

extension UICollectionView {
    
    /**
     Method to reload collectionview on main thread
     */
    func reloadInMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    /**
     Method to reload specfied rows on main thread
     - parameter indexPaths: Represent row/items indexes
     */
    func reloadItemsInMainQueue(at indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.reloadItems(at: indexPaths)
        }
    }
    
    /**
     Method to register cell for collectionview
     - parameter identifier: Represent cell identifier
     */
    func registerCell(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    /**
     Method to register reusable view for collectionview
     - parameter supplementaryViewOfKind: Represent view kind
     - parameter identifier: Represent cell identifier
     */
    func registerResuableView(forSupplementaryViewOfKind supplementaryViewOfKind: String, identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: identifier)
    }
    
}

extension UICollectionView {
    
    func initPullToRefresh(withPullTitle pullTitle: String = "", releaseTitle: String = "", loadingTitle: String = "", color: UIColor = UIColor.blue, completion: @escaping (()->())) {
        
        self.addPullToRefresh {
            completion()
        }
        self.pullToRefreshView.arrowColor = color
        self.pullToRefreshView.tintColor = color
        self.pullToRefreshView.textColor = color
        self.pullToRefreshView.setTitle(pullTitle, forState: UInt(SVPullToRefreshStateStopped))
        self.pullToRefreshView.setTitle(releaseTitle, forState: UInt(SVPullToRefreshStateTriggered))
        self.pullToRefreshView.setTitle(loadingTitle, forState: UInt(SVPullToRefreshStateLoading))
        
        for view in self.pullToRefreshView.subviews {
            if view is UIActivityIndicatorView {
                (view as! UIActivityIndicatorView).color = color
            }
        }
        
    }
    
    func performPullToRefresh() {
        if self.pullToRefreshView != nil {
            self.triggerPullToRefresh()
        }
    }
    
    func stopAnimatingPullToRefresh() {
        if self.pullToRefreshView != nil {
            self.pullToRefreshView.stopAnimating()
        }
    }
    
    func setPullToRefreshEnable(_ isEnable: Bool) {
        self.showsPullToRefresh = isEnable
    }
    
    func initLoadMore(withColor color: UIColor = UIColor.blue, completion: @escaping (()->())) {
        
        self.addInfiniteScrolling {
            completion()
        }
        self.infiniteScrollingView.tintColor = color
        
        for view in self.infiniteScrollingView.subviews {
            if view is UIActivityIndicatorView {
                (view as! UIActivityIndicatorView).color = color
            }
        }
        
    }
    
    func performLoadMore() {
        if self.infiniteScrollingView != nil {
            self.triggerInfiniteScrolling()
        }
    }
    
    func stopAnimatingLoadMore() {
        if self.infiniteScrollingView != nil {
            self.infiniteScrollingView.stopAnimating()
        }
    }
    
    func setLoadMoreEnable(_ isEnable: Bool) {
        self.showsInfiniteScrolling = isEnable
    }
    
}

