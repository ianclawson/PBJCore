//
//  UIViewController+Ext.swift
//  stars2apples
//
//  Created by Ian Clawson on 2/15/20.
//  Copyright © 2020 Ian Clawson Apps. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIViewController {
    
    func dismissOrPop(animated: Bool, fireCompletionConcurrently: Bool = true, completion: (() -> Void)? = nil) {
        if self.navigationController?.canNavPop ?? false {
            self.navigationController?.popViewController(animated: true)
            completion?()
        } else {
            if fireCompletionConcurrently {
                self.dismiss(animated: true)
                completion?()
            } else {
                self.dismiss(animated: true, completion: completion)
            }
        }
    }
    
    func showAlert(title: String? = nil, message: String? = nil, error: Error? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: (error != nil)
                ? error?.localizedDescription
                : message,
            preferredStyle: .alert
        )
        if let handler = handler {
            alert.addAction(.ok(handler: handler))
        } else {
            alert.addAction(.ok)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    var topBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var isDarkTheme: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
    
    func frame(for view: UIView?) -> CGRect {
        return view?.convert(view?.bounds ?? CGRect.zero, to: nil) ?? CGRect.zero
    }

//    func buttons(for view: UIView?, buttons: inout [UIView]) {
//        for subview in view?.subviews ?? [] {
//            if (subview is UIControl) {
//                buttons.append(subview)
//            } else {
//                self.buttons(for: subview, buttons: &buttons)
//            }
//        }
//    }
//
//    func buttons(for view: UIView?) -> [UIControl]? {
//        var buttons: [UIView] = []
//        self.buttons(for: view, buttons: &buttons)
//
////        if SYSTEM_VERSION_LESS_THAN("11.0") {
////            buttons = (buttons as NSArray).sortedArray(comparator: { obj1, obj2 in
////                if (obj1?.frame.origin.x ?? 0.0) > (obj2?.frame.origin.x ?? 0.0) {
////                    return .orderedDescending
////                } else if (obj1?.frame.origin.x ?? 0.0) < (obj2?.frame.origin.x ?? 0.0) {
////                    return .orderedAscending
////                }
////                return .orderedSame
////            }) as? [AnyHashable] ?? buttons
////        }
//
//        return buttons as? [UIControl]
//    }
//
//
//    func frame(forNavBarItem item: UIBarButtonItem?) -> CGRect {
//
//        var items: [AnyHashable] = []
//        if let leftBarButtonItems = navigationItem.leftBarButtonItems {
//            items.append(contentsOf: leftBarButtonItems)
//        }
//        if let all = ((navigationItem.rightBarButtonItems as NSArray?)?.reverseObjectEnumerator())?.allObjects as? [AnyHashable] {
//            items.append(contentsOf: all)
//        }
//
//        var index: Int? = nil
//        if let item = item {
//            index = items.firstIndex(of: item) ?? NSNotFound
//        }
//
//        if let buttons = self.buttons(for: navigationController?.navigationBar) {
//            if (index ?? 0) < buttons.count {
//                let view = buttons[index ?? 0]
//                return frame(for: view)
//            }
//        }
//
//        // return the frame of the navigation bar as a fallback
//        return frame(for: navigationController?.navigationBar)
//    }
//
//    func frame(forToolbarItem item: UIBarButtonItem?, flexibleSpaceItem: UIBarButtonItem?) -> CGRect {
//
//        var toolbarItems: [UIBarButtonItem]? = nil
//        if let selfToolbarItems = self.toolbarItems {
//            toolbarItems = selfToolbarItems
//        }
//        var itemsToRemove: [AnyHashable] = []
//        for barButtonItem in toolbarItems ?? [] {
//            if barButtonItem == flexibleSpaceItem {
//                itemsToRemove.append(barButtonItem)
//            }
//        }
//        toolbarItems = toolbarItems?.filter({ !itemsToRemove.contains($0) })
//
//        var index: Int? = nil
//        if let item = item {
//            index = toolbarItems?.firstIndex(of: item) ?? NSNotFound
//        }
//
//        if let buttons = self.buttons(for: navigationController?.toolbar) {
//            if (index ?? 0) < buttons.count {
//                let view = buttons[index ?? 0]
//                return frame(for: view)
//            }
//        }
//
//        return frame(for: navigationController?.toolbar)
//    }
    
    func dismissSearch(_ searchController: UISearchController, completion: (() -> Void)? = nil) {
        searchController.searchBar.text = ""
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                completion?()
            }
        } else {
            completion?()
        }
    }

}

extension UISearchResultsUpdating where Self: UIViewController {
    func setupSearchController(_ searchController: UISearchController, searchPlaceholderText: String?, withSearchResultsController: Bool = false, searchScopes: [String] = [], showsScopeBar: Bool? = nil) {
//        navigationController?.navigationBar.prefersLargeTitles = true // idk
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = withSearchResultsController
        searchController.obscuresBackgroundDuringPresentation = withSearchResultsController
        searchController.dimsBackgroundDuringPresentation = withSearchResultsController
        if let searchPlaceholderText = searchPlaceholderText {
            searchController.searchBar.placeholder = searchPlaceholderText
        }
        if !searchScopes.isEmpty {
            if let showsScopeBar = showsScopeBar {
                searchController.searchBar.showsScopeBar = showsScopeBar
            }
            searchController.searchBar.scopeButtonTitles = searchScopes
        }
        navigationItem.searchController = searchController
    }
}
#endif
