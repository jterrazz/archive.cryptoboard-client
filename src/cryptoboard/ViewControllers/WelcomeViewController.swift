//
//  FirstTimeViewController.swift
//  cryptoboard
//
//  Created by Jean Baptiste TERRAZZONI on 12/06/2018.
//  Copyright © 2018 terrazzoni. All rights reserved.
//

import UIKit

class WelcomeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradient(colors: UIColor.gradients.purple.cgColors, angle: 135)

        let page1 = WelcomeFirstViewController()
        let page2 = WelcomeFollowViewController()
        let page3 = WelcomeWalletViewController()
        let startIndex = 0
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        setViewController(0)
        
        pageControl.frame = .zero
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = startIndex
        
        view.addSubviewAutoConstraints(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0)
        ])
    }
    
    public func setViewController(_ index: Int) {
        let direction: UIPageViewControllerNavigationDirection = index < pageControl.currentPage ? .reverse : .forward
        
        if (index < pages.count) {
            setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
            pageControl.currentPage = index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController) {
            if (index == 0) {
                return nil
            }
            return pages[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController) {
            if (index == pages.count - 1) {
                return nil
            }
            return pages[index + 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers, let index = pages.index(of: viewControllers[0]) {
            pageControl.currentPage = index
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    

}
