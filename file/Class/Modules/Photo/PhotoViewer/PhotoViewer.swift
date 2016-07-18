//
//  PhotoViewer.swift
//  file
//
//  Created by 翟泉 on 2016/6/30.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class PhotoViewer: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    var scrollView: UIScrollView!
    
    var photoItems = [PhotoItem]()
    
    var imagePaths: [String]!
    
    var currentIndex: Int = 0 {
        didSet {
            didSetCurrentIndex(oldIndex: oldValue)
        }
    }
    
    private var interactive = false
    private let interactionController = UIPercentDrivenInteractiveTransition()
    
    
    internal init(imagePaths: [String], index: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.imagePaths = imagePaths
        currentIndex = index
        title = "\(currentIndex+1)/\(imagePaths.count)"
        view.backgroundColor = UIColor.white()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(classForCoder)
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(UIView())
        
        navigationController?.delegate = self
        
        let rect: CGRect
        if view.frame.width < view.frame.height {
            rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height-20)
        }
        else {
            rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
        
        scrollView = UIScrollView(frame: rect)
        scrollView.backgroundColor = view.backgroundColor
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        
        scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(imagePaths.count), height: scrollView.bounds.height)
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(currentIndex), y: 0)
        
        let count = imagePaths.count > 5 ? 5 : imagePaths.count
        for idx in 0..<count {
            let offset: Int
            if currentIndex > imagePaths.count-2 {
                offset = imagePaths.count - count
            }
            else if currentIndex < 2 {
                offset = 0
            }
            else {
                offset = currentIndex - 2
            }
            let index = offset + idx
            
            let frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            let item = PhotoItem(frame: frame)
            photoItems.append(item)
            scrollView.addSubview(item)
            
            
            item.imagePath = imagePaths[index]
        }
        
        addGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        print(#function)
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.delegate = nil
        print(#function)
        super.viewDidDisappear(animated)
    }
    
    
    func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoViewer.handleTapGesture(tapGesture:)))
        scrollView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(PhotoViewer.handlePanGesture(panGesture:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
        
//        tapGesture.require(toFail: panGesture)
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        navigationController?.navigationBar.isHidden = !navigationController!.navigationBar.isHidden
    }
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        
        
        
        
        let translationY = panGesture.translation(in: scrollView).y
        
        let progress = -translationY / scrollView.bounds.height
        
        switch panGesture.state {
        case .began:
            interactive = true
            _ = navigationController?.popViewController(animated: true)
        case .changed:
            interactionController.update(progress)
        case .cancelled, .ended:
            if progress > 0.4 {
                interactionController.finish()
            }
            else {
                interactionController.cancel()
            }
            interactive = false
        default:
            break
        }
        
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let translation = panGesture.translation(in: scrollView)
        print(translation)
        print(panGesture.velocity(in: scrollView))
        if translation.y < 0 && abs(translation.y) > abs(translation.x) {
            return true
        }
        else {
            return false
        }
    }
    
    
    
    internal override func viewWillLayoutSubviews() {
        
        layoutSubviews()
        
        super.viewWillLayoutSubviews()
    }
    
    func layoutSubviews() {
        let rect: CGRect
        if view.frame.width < view.frame.height {
            rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height-20)
        }
        else {
            rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        }
        
        if rect != scrollView.frame {
            
            scrollView.frame = rect
            scrollView.contentSize = CGSize(width: scrollView.bounds.width * CGFloat(imagePaths.count), height: scrollView.bounds.height)
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(currentIndex), y: 0)
            
            for (idx, item) in photoItems.enumerated() {
                
                
                let offset: Int
                if currentIndex > imagePaths.count-2 {
                    offset = imagePaths.count - photoItems.count
                }
                else if currentIndex < 2 {
                    offset = 0
                }
                else {
                    offset = currentIndex - 2
                }
                
                let index = CGFloat(offset + idx)
                
                print(index)
                
                item.frame = CGRect(x: CGFloat(index) * scrollView.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            }
        }
        
    }
    
    func didSetCurrentIndex(oldIndex: Int) {
        title = "\(currentIndex+1)/\(imagePaths.count)"
        
        print(currentIndex)
        
        if currentIndex < 2 || currentIndex > imagePaths.count-3 {
            return
        }
        
        if currentIndex > oldIndex {
            if currentIndex == 2 {
                return
            }
            let item = photoItems.removeFirst()
            photoItems.append(item)
            let offset = CGFloat(currentIndex + 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = item.transform.translateBy(x: offset, y: 0)
            item.imagePath = imagePaths[currentIndex + 2]
        }
        else if currentIndex < oldIndex {
            if currentIndex == imagePaths.count-3 {
                return
            }
            let item = photoItems.removeLast()
            photoItems.insert(item, at: 0)
            
            let offset = CGFloat(currentIndex - 2) * scrollView.frame.width - item.frame.origin.x
            item.transform = item.transform.translateBy(x: offset, y: 0)
            item.imagePath = imagePaths[currentIndex - 2]
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(currentIndex+1) * scrollView.frame.width {
            currentIndex += 1
        }
        else if scrollView.contentOffset.x < CGFloat(currentIndex-1) * scrollView.frame.width {
            currentIndex -= 1
        }
    }
    
}




extension PhotoViewer: UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop && interactive {
            return self
        }
        else {
            return nil
        }
        
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionController : nil
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey), let toVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) else{
            return
        }
        
        
        guard let fromView = fromVC.view, let toView = toVC.view else {
            return
        }
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: transitionDuration(transitionContext), animations: { 
            //
            fromView.alpha = 0
            fromView.transform = fromVC.view.transform.translateBy(x: 0, y: -fromVC.view.frame.size.height)
        }) { (_) in
            fromView.alpha = 1
            fromView.transform = CGAffineTransform.identity
            
            let isCancelled = transitionContext.transitionWasCancelled()
            transitionContext.completeTransition(!isCancelled)
            
        }
        
    }
    
    
}
