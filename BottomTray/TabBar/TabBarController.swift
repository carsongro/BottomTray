//
//  TabBarController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let libraryVC = LibraryViewController()
        let browseVC = BrowseViewController()
        
        libraryVC.navigationItem.largeTitleDisplayMode = .automatic
        browseVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: libraryVC)
        let nav2 = UINavigationController(rootViewController: browseVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "music.note.list"),
            tag: 1
        )
        
        nav2.tabBarItem = UITabBarItem(
            title: "Browse",
            image: UIImage(systemName: "music.note.house.fill"),
            tag: 2
        )
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        [libraryVC, browseVC].forEach {
            $0.additionalSafeAreaInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 60,
                right: 0
            )
        }
        
        setViewControllers(
            [nav1, nav2],
            animated: true
        )
        
        let miniPlayer = MiniPlayerViewController()
        addChild(miniPlayer)
        view.addSubview(miniPlayer.view)
        miniPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.didMove(toParent: self)
        NSLayoutConstraint.activate([
            miniPlayer.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            miniPlayer.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18),
            miniPlayer.view.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),
            miniPlayer.view.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}

#Preview {
    TabBarController()
}
