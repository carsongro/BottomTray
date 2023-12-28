//
//  BrowseViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit
import SwiftUI
import MusicKit

class BrowseViewController: UIViewController {
    
    private var swiftUIHomeSearchController: UIHostingController<BrowseSearchView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let searchController = UIHostingController(rootView: BrowseSearchView())
        addChild(searchController)
        searchController.didMove(toParent: self)
        view.addSubview(searchController.view)
        searchController.view.frame = view.frame
        
        swiftUIHomeSearchController = searchController
    }
}
