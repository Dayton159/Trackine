//
//  TabBarViewController.swift
//  Trackine
//
//  Created by Dayton on 22/04/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    fileprivate func configureTabBar() {
        self.tabBar.clipsToBounds = false
        self.tabBar.tintColor = .white
        self.tabBar.accessibilityIgnoresInvertColors = true
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor(named: "appColor1")
    }
    
    fileprivate func configureViewControllers() {
        // Configure the tabBar viewControllers
        guard let intraday = UIImage(systemName: "note.text") else { return }
        guard let dailyAdjusted = UIImage(systemName: "calendar") else { return }
       
        
        let tools = navigationControllerTemplate(
            tag: 0,
            title: "Tools",
            tabBarIcon: intraday,
            ToolsViewController()
        )
    
        let friends = navigationControllerTemplate(
            tag: 1,
            title: "Friends",
            tabBarIcon: dailyAdjusted,
            FriendsViewController()
        )
    
        viewControllers = [tools, friends]
    }
    
    fileprivate func navigationControllerTemplate(tag: Int, title: String, tabBarIcon: UIImage,_ rootViewController: UIViewController) -> UINavigationController {
        
        // add navigationController to every tabBarController viewControllers
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = tabBarIcon
        navigation.tabBarItem.title = title
        return navigation
    }
    
}
