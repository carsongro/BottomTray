//
//  FullScreenPlayerAnimationController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit
import SwiftUI

class FullScreenPlayerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.36
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch (transitionContext.viewController(forKey: .from), transitionContext.viewController(forKey: .to)) {
        case (let fromVC as TabBarController, let toVC as FullScreenPlayerViewController):
            animatePresent(from: fromVC.miniPlayer, to: toVC, transitionContext: transitionContext)
        case (let fromVC as FullScreenPlayerViewController, let toVC as TabBarController):
            animateDismiss(from: fromVC, to: toVC.miniPlayer, transitionContext: transitionContext)
        default:
            assertionFailure("Incorrect View Controller Types")
        }
    }
    
    //TODO: Use the current playing track color to make the transition smoother instead of gray
    func animatePresent(
        from fromVC: MiniPlayerViewController,
        to toVC: FullScreenPlayerViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        containerView.addSubview(toVC.view)
        toVC.view.isHidden = true
        
        let backgroundView = UIView(frame: fromVC.view.frame)
        backgroundView.backgroundColor = .secondarySystemBackground
        backgroundView.layer.cornerRadius = 15
        
        let imageView = UIImageView()
        imageView.image = fromVC.trackImage.image
        imageView.contentMode = fromVC.trackImage.contentMode
        imageView.layer.cornerRadius = fromVC.trackImage.layer.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.frame = fromVC.trackImage.convert(fromVC.trackImage.bounds, to: fromVC.view.window)
        
        guard let trackName = fromVC.textView.snapshotView(afterScreenUpdates: false),
              let playPauseButton = fromVC.playPauseButton.snapshotView(afterScreenUpdates: false),
              let controlsPlayPause = toVC.playPauseButton.snapshotView(afterScreenUpdates: true) else {
            transitionContext.completeTransition(false)
            return
        }
        trackName.frame = fromVC.textView.convert(fromVC.textView.bounds, to: fromVC.view.window)
        playPauseButton.frame = fromVC.playPauseButton.convert(fromVC.playPauseButton.bounds, to: fromVC.view.window)
        // TODO: FIX: for some reason the frame from toVC is 0, 0 so figure out how to fix instead of manually setting the frame
        let grabber = UIButton()
        grabber.layer.masksToBounds = true
        grabber.layer.cornerRadius = 2.5
        grabber.grabberBlur(style: .systemThinMaterialLight, cornerRadius: 2.5)
        grabber.frame = CGRect(
            x: toVC.view.frame.midX - 22,
            y: playPauseButton.frame.midY,
            width: 44,
            height: 44
        )
        grabber.alpha = 0
        
        controlsPlayPause.frame = CGRect(
            x: toVC.view.frame.midX - controlsPlayPause.frame.width / 2,
            y: playPauseButton.frame.minY,
            width: 44,
            height: 44
        )
        controlsPlayPause.alpha = 0
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(controlsPlayPause)
        containerView.addSubview(trackName)
        containerView.addSubview(playPauseButton)
        containerView.addSubview(grabber)
        containerView.addSubview(imageView)
        
        UIView.animate(
            springDuration: transitionDuration(using: transitionContext),
            bounce: 0,
            initialSpringVelocity: 0,
            delay: 0,
            options: []) {
                backgroundView.layer.cornerRadius = 50
                backgroundView.frame = finalFrame
                
                imageView.frame = toVC.trackImage.frame
                imageView.layer.cornerRadius = toVC.trackImage.layer.cornerRadius
                
                trackName.frame = CGRect(
                    x: trackName.frame.minX,
                    y: toVC.view.frame.minY,
                    width: trackName.frame.width,
                    height: trackName.frame.height
                )
                trackName.alpha = 0
                
                playPauseButton.frame = CGRect(
                    x: playPauseButton.frame.minX,
                    y: toVC.view.frame.minY,
                    width: playPauseButton.frame.width,
                    height: playPauseButton.frame.height
                )
                playPauseButton.alpha = 0
                
                grabber.alpha = 1
                grabber.frame = CGRect(
                    x: toVC.view.frame.width / 2 - 22,
                    y: toVC.view.frame.minY + 45,
                    width: 44,
                    height: 44
                )
                
                controlsPlayPause.alpha = 1
                controlsPlayPause.frame = CGRect(
                    x: toVC.view.frame.width / 2 - 22,
                    y: toVC.trackImage.frame.maxY + 22,
                    width: 44,
                    height: 44
                )
            } completion: { _ in
                toVC.view.isHidden = false
                
                backgroundView.removeFromSuperview()
                imageView.removeFromSuperview()
                trackName.removeFromSuperview()
                playPauseButton.removeFromSuperview()
                grabber.removeFromSuperview()
                controlsPlayPause.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
    }
    
    func animateDismiss(
        from fromVC: FullScreenPlayerViewController,
        to toVC: MiniPlayerViewController,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        let containerView = transitionContext.containerView
        
        let backgroundView = UIView(frame: fromVC.view.frame)
        backgroundView.backgroundColor = .secondarySystemBackground
        backgroundView.layer.cornerRadius = 50
        
        let imageView = UIImageView()
        imageView.image = fromVC.trackImage.image
        imageView.contentMode = fromVC.trackImage.contentMode
        imageView.layer.cornerRadius = fromVC.trackImage.layer.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.frame = fromVC.trackImage.convert(fromVC.trackImage.bounds, to: fromVC.view.window)
        
        guard let trackName = toVC.textView.snapshotView(afterScreenUpdates: false),
              let playPauseButton = toVC.playPauseButton.snapshotView(afterScreenUpdates: false),
              let controlsPlayPause = fromVC.playPauseButton.snapshotView(afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }
        
        trackName.frame = CGRect(
            x: toVC.textView.frame.minX,
            y: fromVC.view.frame.minY,
            width: toVC.textView.frame.width,
            height: toVC.textView.frame.height
        )
        trackName.alpha = 0
        
        playPauseButton.frame = CGRect(
            x: toVC.playPauseButton.frame.minX,
            y: fromVC.view.frame.minY,
            width: toVC.playPauseButton.frame.width,
            height: toVC.playPauseButton.frame.height
        )
        playPauseButton.alpha = 0
        
        controlsPlayPause.frame = fromVC.playPauseButton.convert(fromVC.playPauseButton.bounds, to: fromVC.view.window)
        
        let grabber = UIButton()
        grabber.layer.masksToBounds = true
        grabber.layer.cornerRadius = 2.5
        grabber.grabberBlur(style: .systemThinMaterialLight, cornerRadius: 2.5)
        grabber.frame = fromVC.grabber.frame.offsetBy(dx: 0, dy: fromVC.view.frame.minY)
        grabber.alpha = 1
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(controlsPlayPause)
        containerView.addSubview(trackName)
        containerView.addSubview(playPauseButton)
        containerView.addSubview(grabber)
        containerView.addSubview(imageView)
        fromVC.view.isHidden = true
        
        UIView.animate(
            springDuration: transitionDuration(using: transitionContext),
            bounce: 0,
            initialSpringVelocity: 0,
            delay: 0,
            options: []) {
                backgroundView.layer.cornerRadius = 15
                backgroundView.frame = toVC.view.frame
                
                imageView.frame = toVC.trackImage.convert(toVC.trackImage.bounds, to: fromVC.view.window)
                imageView.layer.cornerRadius = toVC.trackImage.layer.cornerRadius
                
                trackName.frame = toVC.textView.convert(toVC.textView.bounds, to: toVC.view.window)
                trackName.alpha = 1
                
                let playPauseButtonRect = toVC.playPauseButton.convert(toVC.playPauseButton.bounds, to: toVC.view.window)
                playPauseButton.frame = playPauseButtonRect
                playPauseButton.alpha = 1
                
                grabber.alpha = 0
                grabber.frame = CGRect(
                    x: grabber.frame.minX,
                    y: playPauseButtonRect.minY,
                    width: 44,
                    height: 44
                )
                
                controlsPlayPause.frame = controlsPlayPause.frame.offsetBy(dx: 0, dy: 1000)
                controlsPlayPause.alpha = 0
            } completion: { _ in
                fromVC.view.isHidden = false
                
                backgroundView.removeFromSuperview()
                imageView.removeFromSuperview()
                trackName.removeFromSuperview()
                playPauseButton.removeFromSuperview()
                grabber.removeFromSuperview()
                controlsPlayPause.removeFromSuperview()
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            }
    }
}
