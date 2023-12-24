//
//  FullScreenPlayerAnimationController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit

class FullScreenPlayerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch (transitionContext.viewController(forKey: .from), transitionContext.viewController(forKey: .to)) {
        case (let fromVC as TabBarController, let toVC as FullScreenPlayerViewController):
            animatePresent(from: fromVC.miniPlayer, to: toVC, transitionContext: transitionContext)
        case (let fromVC as FullScreenPlayerViewController, let toVC as TabBarController):
            animateDismiss(from: fromVC, to: toVC.miniPlayer, transitionContext: transitionContext)
        default:
            assertionFailure("Incorrect View Controllers")
        }
    }
    
    func animatePresent(
        from fromVC: MiniPlayerViewController,
        to toVC: FullScreenPlayerViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        // TODO: Figure out why removing this guard breaks the whole thing
        guard let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let backgroundView = UIView(frame: fromVC.view.frame)
        backgroundView.backgroundColor = .secondarySystemBackground
        backgroundView.layer.cornerRadius = 15
        
        let imageView = UIImageView()
        imageView.image = fromVC.trackImage.image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = fromVC.trackImage.convert(fromVC.trackImage.bounds, to: fromVC.view.window)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(imageView)
        toVC.view.isHidden = true
        
        UIView.animate(
            springDuration: transitionDuration(using: transitionContext),
            bounce: 0,
            initialSpringVelocity: 0,
            delay: 0,
            options: []) {
                backgroundView.layer.cornerRadius = 50
                backgroundView.frame = finalFrame
                imageView.frame = toVC.trackImage.frame
            } completion: { _ in
                defer {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                
                toVC.view.isHidden = false
                
                backgroundView.removeFromSuperview()
                imageView.removeFromSuperview()
            }
    }
    
    func animateDismiss(
        from fromVC: FullScreenPlayerViewController,
        to toVC: MiniPlayerViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
//        guard let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else {
//            transitionContext.completeTransition(false)
//            return
//        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        let backgroundView = UIView(frame: fromVC.view.frame)
        backgroundView.backgroundColor = .secondarySystemBackground
        backgroundView.layer.cornerRadius = 50
        
        let imageView = UIImageView()
        imageView.image = fromVC.trackImage.image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = fromVC.trackImage.convert(fromVC.trackImage.bounds, to: fromVC.view.window)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(imageView)
        toVC.view.isHidden = true
        
        UIView.animate(
            springDuration: transitionDuration(using: transitionContext),
            bounce: 0,
            initialSpringVelocity: 0,
            delay: 0,
            options: []) {
                backgroundView.layer.cornerRadius = 15
                backgroundView.frame = finalFrame
                imageView.frame = toVC.trackImage.convert(toVC.trackImage.frame, to: fromVC.view.window)
            } completion: { _ in
                defer {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
                
                toVC.view.isHidden = false
                
                backgroundView.removeFromSuperview()
                imageView.removeFromSuperview()
            }
    }
}
