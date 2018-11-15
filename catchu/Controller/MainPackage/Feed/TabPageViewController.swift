//
//  TabPageViewController.swift
//  catchu
//
//  Created by Remzi YILDIRIM on 11/5/18.
//  Copyright © 2018 Remzi YILDIRIM. All rights reserved.
//

import UIKit

struct TabPageViewConfigurator {
    var tabHeight: CGFloat = 50
    var isTabInside = false
    
    init() {}
}

class TabPageViewController: UIPageViewController {
    
    var selectedIndex: Int = 0
    let configurator: TabPageViewConfigurator = TabPageViewConfigurator()
    
    lazy var menuTabView: MenuTabView = {
        let view = MenuTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var items = [UIViewController]() {
        didSet {
            menuTabView.configure(items)
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupScrollView()
        setupBinds()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        
        self.dataSource = self
        self.delegate = self
        
        scrollToPage(selectedIndex)
        menuTabView.selectTabViewCollectionCell(selectedIndex)
    }
    
    /// find scroll view in pageviewcontroller and set delegate
    private func setupScrollView() {
        let scrollView = view.subviews.compactMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
    }
    
    // change first view controller in pageVC
    private func scrollToPage(_ index: Int) {
        let direction: UIPageViewControllerNavigationDirection = self.selectedIndex > index ? .reverse : .forward
        
        if direction == .forward {
            for tempIndex in selectedIndex...index {
                self.setViewControllers([items[tempIndex]], direction: direction, animated: true) { [weak self](_) in
                    self?.selectedIndex = tempIndex
                }
            }
        } else {
            for tempIndex in (index...selectedIndex).reversed() {
                self.setViewControllers([items[tempIndex]], direction: direction, animated: true) { [weak self](_) in
                    self?.selectedIndex = tempIndex
                }
            }
        }
    }
    
    private func setupBinds() {
        menuTabView.selectAction.bindAndFire { [unowned self] (index) in
            self.scrollToPage(index)
        }
    }
    
    deinit {
        menuTabView.selectAction.unbind()
    }
    
}

extension TabPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let index = findCurrentIndex() {
            selectedIndex = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: false)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController, isAfter: true)
    }
    
    private func nextViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        
        guard var index = findIndex(viewController) else {
            return nil
        }
        
        index = isAfter ? index + 1 : index - 1
        
        if index >= 0 && index < items.count {
            return items[index]
        }
        
        return nil
    }
    
    private func findCurrentIndex() -> Int? {
        guard let viewController = viewControllers?.first else {
            return nil
        }
        return findIndex(viewController)
    }
    
    private func findIndex(_ viewController: UIViewController) -> Int? {
        guard let index = items.map({$0}).index(of: viewController) else {
            return nil
        }
        return index
    }
}

extension TabPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let selectedWidthSize = CGFloat(selectedIndex) * view.frame.width
        
        let scrollOffsetX = scrollView.contentOffset.x + selectedWidthSize - view.frame.width
        
        print("selected: \(selectedIndex) - scrollOffsetX: \(scrollOffsetX)")
        
        self.menuTabView.scrollBarIndicator(contentOffsetX: scrollOffsetX, currentIndex: selectedIndex)
    }
    
}
