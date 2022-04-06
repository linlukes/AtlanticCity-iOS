//
//  WalkThorughController.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 26/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class WalkThorughController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
    var loginBtn = UIButton()
    var SignUp = UIButton()
    var nextBtn = UIButton()
    var prevBtn = UIButton()
    
    var timer = Timer()
    var bottomView = UIView()
    var imageView: UIImageView?
    // MARK: UIPageViewControllerDataSource
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "FirstViewController"),
                self.newVc(viewController: "SecondViewController"),self.newVc(viewController: "ThirdViewController"),self.newVc(viewController: "FourthViewController")]
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    //MARK: settings a background for uipageview & controllers
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
       imageView = UIImageView(image: UIImage(named: "walkbg")!)
        imageView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView!.contentMode = .scaleAspectFill
       view.insertSubview(imageView!, at: 0)
       if let firstViewController = orderedViewControllers.first {
           setViewControllers([firstViewController],
                              direction: .forward,
                              animated: true,
                              completion: nil)
           
       }
       self.configurePageControl()
   
   }
   //MARK: configure page UI control Items for screen
    func configurePageControl() {
        
        
        bottomView = UIView(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 220,width: UIScreen.main.bounds.width,height: 220))
    
        bottomView.layer.shadowOffset = CGSize(width: 0,height :0)
        bottomView.layer.shadowOpacity = 0.5
        self.view.addSubview(bottomView)

        

        pageControl = UIPageControl(frame: CGRect(x: 0,y: (15+20)-40,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green))
        self.bottomView.addSubview(pageControl)
        
        nextBtn = UIButton(frame : CGRect(x: self.view.frame.width-130,y:(15+20)-30,width: 100,height: 30))
        nextBtn.layer.cornerRadius = 2.0
        nextBtn.layer.masksToBounds = true
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        nextBtn.addTarget(self, action: #selector(nextBtnAction(_:)), for: .touchUpInside)
        self.bottomView.addSubview(nextBtn)
        
        prevBtn = UIButton(frame : CGRect(x: 30,y:(15+20)-30,width: 100,height: 30))
        prevBtn.layer.cornerRadius = 2.0
        prevBtn.layer.masksToBounds = true
        prevBtn.setTitleColor(UIColor.white, for: .normal)
        prevBtn.setTitle("Skip", for: .normal)
        prevBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        prevBtn.addTarget(self, action: #selector(previousBtnAction(_:)), for: .touchUpInside)

        self.bottomView.addSubview(prevBtn)
        
        
        loginBtn = UIButton(frame : CGRect(x: (self.bottomView.frame.width/2)-150,y:pageControl.frame.origin.y+pageControl.frame.size.height+20,width: 300,height: 50))
        loginBtn.layer.masksToBounds = true
        loginBtn.setTitleColor(Helpers.UIColorFromHex(rgbValue: UInt32(Helpers.green)), for: .normal)
        loginBtn.setTitle("Get Started", for: .normal)
        loginBtn.layer.cornerRadius = 25
        loginBtn.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        loginBtn.addTarget(self, action: #selector(LoginBtnAction(_:)), for: .touchUpInside)
        loginBtn.backgroundColor = Helpers.UIColorFromHex(rgbValue:UInt32(Helpers.white))
        self.bottomView.addSubview(loginBtn)
        
        
        SignUp = UIButton(frame : CGRect(x: (self.bottomView.frame.width/2)-150,y:loginBtn.frame.origin.y+50+30,width: 300,height: 50))
        SignUp.layer.cornerRadius = 25
        SignUp.layer.masksToBounds = true
        SignUp.setTitleColor(UIColor.white, for: .normal)
        SignUp.setTitle("Login", for: .normal)
        SignUp.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18)
        SignUp.addTarget(self, action: #selector(signUpAction(_:)), for: .touchUpInside)
        SignUp.backgroundColor = Helpers.UIColorFromHex(rgbValue:UInt32(Helpers.green))
        self.bottomView.addSubview(SignUp)
        
        
        
    }
    func nextAction(){
         guard let currentViewController = self.viewControllers?.first else { return }
         guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
         setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
         // self.pageControl.currentPage = orderedViewControllers.index(of: currentViewController)!+1
     }
     
     @objc func LoginBtnAction(_ sender:UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignupController") as! SignupController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
      }
    func moveToLogin(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
    
      @objc func signUpAction(_ sender:UIButton){
         moveToLogin()
      }
     
    @objc func nextBtnAction(_ sender:UIButton){
        if(prevBtn.titleLabel?.text == "Skip"){
            prevBtn.setTitle("Previous", for: .normal)
        }
        if(nextBtn.titleLabel?.text == "Done"){
            moveToLogin()
        }
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        if( orderedViewControllers.firstIndex(of: nextViewController)! == 3){
               sender.setTitle("Done", for: .normal)
        }
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: nextViewController)!
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    @objc func previousBtnAction(_ sender:UIButton){
        nextBtn.setTitle("Next", for: .normal)
        if(sender.titleLabel?.text == "Skip"){
            self.pageControl.currentPage = 3
            setViewControllers([orderedViewControllers[3]], direction: .forward, animated: true, completion: nil)
            nextBtn.setTitle("Done", for: .normal)
            sender.setTitle("Previous", for: .normal)
            return
        }
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        if( orderedViewControllers.firstIndex(of: previousViewController)! == 0){
            prevBtn.setTitle("Skip", for: .normal)
        }
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: previousViewController)!
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
       
    }
     func newVc(viewController: String) -> UIViewController {
         return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
         
     }
     
     
     // MARK: Delegate methords
     func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
         let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
     }
     
     
     // MARK: Data source functions.
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if(nextBtn.titleLabel?.text == "Done"){
            nextBtn.setTitle("Next", for: .normal)
        }
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
             return nil
         }
         if(viewControllerIndex == 0){
            prevBtn.setTitle("Skip", for: .normal)
         }
         let previousIndex = viewControllerIndex - 1
       
         guard previousIndex >= 0 else {
             return nil
         }
         guard orderedViewControllers.count > previousIndex else {
             return nil
         }
         return orderedViewControllers[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if(prevBtn.titleLabel?.text == "Skip"){
            prevBtn.setTitle("Previous", for: .normal)
        }
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
             return nil
         }
         let nextIndex = viewControllerIndex + 1
         let orderedViewControllersCount = orderedViewControllers.count
       
        if(viewControllerIndex == 3){
            nextBtn.setTitle("Done", for: .normal)
        }
        
         guard orderedViewControllersCount > nextIndex else {
             return nil
         }
         
         return orderedViewControllers[nextIndex]
     }

}
