//
//  PageViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController {
    
    // MARK: Properties
 
    var pages: [DealsDetail] = []
    
    @IBOutlet var hotel_view: UIView!
    @IBOutlet var show_views: UIView!
    @IBOutlet var wheel_view: UIView!
    @IBOutlet var invite_view: UIView!
    @IBOutlet var home_view: UIView!
    
    lazy var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for i in 0 ..< pages.count {
            let vc = makeChildViewController(at: i)
            vc.pageIndex = i
            vc.items = pages
            
            viewControllers.append(vc)
        }
        return viewControllers
    }()
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        isInfiniteScrollEnabled = true
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
//                               UIColor.black.withAlphaComponent(0.0).cgColor]
//        //gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.frame = wheel_view.frame
//        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
//        wheel_view.layer.insertSublayer(gradientLayer, at: 0)
        
        //applyGradient(view: hotel_view)
        //applyGradient(view: show_views)
        //applyGradient(view: wheel_view)
        //applyGradient(view: invite_view)
        //applyGradient(view: home_view)

            
        let hoteltap = UITapGestureRecognizer(target: self, action: #selector(self.hotel(_:)))
        hotel_view.addGestureRecognizer(hoteltap)

        let showtap = UITapGestureRecognizer(target: self, action: #selector(self.shows(_:)))
        show_views.addGestureRecognizer(showtap)

        let spintap = UITapGestureRecognizer(target: self, action: #selector(self.spin(_:)))
        wheel_view.addGestureRecognizer(spintap)

        let invitetap = UITapGestureRecognizer(target: self, action: #selector(self.invite(_:)))
        invite_view.addGestureRecognizer(invitetap)
    }
    func applyGradient(view:UIView){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                               UIColor.black.withAlphaComponent(0.0).cgColor]
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    @objc func hotel(_ sender: UITapGestureRecognizer){
         self.performSegue(withIdentifier: "hotel", sender: self)
         
     }
     @objc func shows(_ sender: UITapGestureRecognizer){
         self.performSegue(withIdentifier: "show", sender: self)
     }
     @objc func spin(_ sender: UITapGestureRecognizer){
         self.performSegue(withIdentifier: "spin", sender: self)
     }
     @objc func invite(_ sender: UITapGestureRecognizer){
         self.performSegue(withIdentifier: "invite", sender: self)
     }
     func home(_ sender: UITapGestureRecognizer){
         
     }
    override func viewWillAppear(_ animated: Bool) {
        print("page view vc called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "hotel"){
            let destinationVC = segue.destination as! UINavigationController
            let newVC = destinationVC.viewControllers.first as! HotelsController
            newVC.id = 1
         }
        if(segue.identifier == "show"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! ShowsController
           newVC.id = 1
        }
        if(segue.identifier == "spin"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! SpinWheelsController
           newVC.id = 1
        }
        if(segue.identifier == "invite"){
           let destinationVC = segue.destination as! UINavigationController
           let newVC = destinationVC.viewControllers.first as! InvitesController
           newVC.id = 1
        }
    }
    // MARK: Actions
    
    @objc func nextPage(_ sender: UIBarButtonItem) {
        scrollToPage(.next, animated: true)
    }
    
    @objc func previousPage(_ sender: UIBarButtonItem) {
        scrollToPage(.previous, animated: true)
    }
    
   
    
    // MARK: View Controllers
    
    func makeChildViewController(at index: Int?) -> PreViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "PreView") as! PreViewController
    }
}

// MARK: PageboyViewControllerDataSource
extension PageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        let count = viewControllers.count
        return count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        guard viewControllers.isEmpty == false else {
            return nil
        }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

// MARK: PageboyViewControllerDelegate
extension PageViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
//        print("willScrollToPageAtIndex: \(index)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didCancelScrollToPageAt index: PageboyViewController.PageIndex,
                               returnToPageAt previousIndex: PageboyViewController.PageIndex) {
//        print("didCancelScrollToPageAt: \(index), returnToPageAt: \(previousIndex)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPosition: \(position)")
                
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPageAtIndex: \(index)")

        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageIndex) {
    }
}

