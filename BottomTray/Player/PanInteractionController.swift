//
//  PanInteractionController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/26/23.
//

import UIKit

/// This is currently unused, but keeping it here because it works
class PanInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController) {
        super.init()
        self.viewController = viewController
        prepareGestureRecognizer(in: viewController.view)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = translation.y / 200
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        case .cancelled:
            interactionInProgress = false
            cancel()
        default:
            break
        }
    }
}
