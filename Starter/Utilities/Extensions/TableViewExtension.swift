//
//  TableViewExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import UIKit
import SVPullToRefresh

extension UITableView {
    
    func reloadInMainQueue() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func reloadSectionInMainQueue(indexSet: IndexSet) {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.beginUpdates()
                self.reloadSections(indexSet, with: UITableView.RowAnimation.none)
                self.endUpdates()
            }
        }
    }
    
    func reloadRowsInMainQueue(indexPaths: [IndexPath], animation: Bool = true) {
        if animation == true {
            DispatchQueue.main.async {
                self.reloadRows(at: indexPaths, with: UITableView.RowAnimation.none)
            }
        } else {
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.reloadRows(at: indexPaths, with: UITableView.RowAnimation.none)
                }
            }
        }
    }
    
    func registerCell(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterView(identifier: String) {
        self.register(UINib.init(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func removeExtraTopSpaceForGroupedTableView() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        self.tableHeaderView = UIView(frame: frame)
    }
    
}

extension UITableView {
    
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
