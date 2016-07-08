//
//  MusicViewController.swift
//  file
//
//  Created by 翟泉 on 2016/7/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
    
    static let `default` = MusicViewController()
    
    var interactive: Bool = false
    
    let interactionController = UIPercentDrivenInteractiveTransition()
    
    var progress = MusicProgressView()
    
    var toolView = MusicToolView()
    
    var backgroundImageView = MusicBackgroundView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = MusicPlayManager.default.currentPlaying?.name
        view.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(MusicViewController.handlePan(panGesture:)))
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        
        
        handlePlayStateChangedNotification()
        view.addSubview(progress)
        progress.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(view)
            make.height.equalTo(150)
        }
        
        view.addSubview(toolView)
        toolView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(100)
        }
        
        NotificationCenter.default().addObserver(self, selector: #selector(MusicListViewController.handlePlayStateChangedNotification), name: PlayStateChangedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self)
    }
    
    func handlePlayStateChangedNotification() {
        progress.currentTime = MusicPlayManager.default.player.currentTime
        progress.duration = MusicPlayManager.default.player.duration
        
        if MusicPlayManager.default.state == .Playing {
            progress.start()
            backgroundImageView.loadNext()
        }
        else if MusicPlayManager.default.state == .Paused {
            progress.pause()
        }
        else if MusicPlayManager.default.state == .Stopped {
            progress.stop()
        }
    }
    
    func handlePan(panGesture: UIPanGestureRecognizer) {
        let translationX =  panGesture.translation(in: view).x
        let progress = translationX / view.frame.width * 2
        
        switch panGesture.state {
        case .began:
            interactive = true
            dismiss(animated: true, completion: nil)
            break
        case .changed:
            interactionController.update(progress>1 ? 1 : progress)
            break
        case .cancelled, .ended:
            interactionController.completionSpeed = 0.99
            if progress > 0.5 {
                interactionController.finish()
            }
            else {
                interactionController.cancel()
            }
            interactive = false
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}




extension MusicViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresentedController presented: UIViewController, presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissedController dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationController(forPresentedViewController presented: UIViewController, presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionController(forPresentation animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionController : nil
    }
    
    func interactionController(forDismissal animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? interactionController : nil
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey), let toVC = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) else{
            return
        }
        
        if toVC.isBeingPresented() {
            containerView.addSubview(toVC.view)
            toVC.view.transform = toVC.view.transform.translateBy(x: toVC.view.frame.size.width, y: 0)
            UIView.animate(withDuration: transitionDuration(transitionContext), animations: {
                toVC.view.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
            
        }
        else if fromVC.isBeingDismissed() {
            UIView.animate(withDuration: transitionDuration(transitionContext), animations: {
                fromVC.view.transform = fromVC.view.transform.translateBy(x: fromVC.view.frame.size.width, y: 0)
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
                    fromVC.view.transform = CGAffineTransform.identity
            })
        }
        
    }
    
}
