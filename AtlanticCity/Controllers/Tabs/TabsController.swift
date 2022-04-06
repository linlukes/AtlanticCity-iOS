//
//  TabsController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit
import SideMenu

protocol isDrawerOpen {
    func openDrawer();
}

class TabsController: UITabBarController,UITabBarControllerDelegate,isDrawerOpen {
    
    var new_entry_status = "0"
    var isSet = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.backgroundColor = UIColor(red: 17.0/255.0, green: 70.0/255.0, blue: 95.0/255.0, alpha: 0.5)

        
        guard let vcs = viewControllers, !vcs.isEmpty else {
            return
        }
        if let navVC = vcs[4] as? HomeController {
            navVC.delegate = self
        }
        self.selectedIndex = 4
        // Do any additional setup after loading the view.
    }

    func openDrawer() {
        print("called")
        //self.performSegue(withIdentifier: "menu", sender: self)
        setUpSideBar()
    }
    func setUpSideBar(){
        let menu = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        menu?.presentationStyle = .menuSlideIn
        menu?.menuWidth = 300
        menu?.statusBarEndAlpha = 0
        present(menu!, animated: true, completion: nil)
    }
   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == tabBarController.viewControllers![4] {
          let navController = tabBarController.viewControllers![4] as? HomeController
            navController!.delegate = self
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Home"){
            if(HomeController.dealsarray.count != 0 || SplashController.dealsarray.count != 0){
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentView") as! PageViewController
                vc.modalPresentationStyle = .fullScreen
                if(SplashController.dealsarray.count == 0){
                     vc.pages = HomeController.dealsarray
                }else{
                     vc.pages = SplashController.dealsarray
                }
                self.present(vc, animated: true, completion: nil)
            }

        }

    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!

        return true
    }
}
