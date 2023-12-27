//
//  FullScreenPlayerViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import SwiftUI
import UIKit
import MusicKit

protocol FullScreenPlayerDelegate: AnyObject {
    func didTapDismiss()
}

class FullScreenPlayerViewController: UIViewController {
    
    weak var delegate: FullScreenPlayerDelegate?
    
    private var initialCenter = CGPoint(x: 0, y: 0)
    private var shouldDismiss = false
    
    public private(set) var backgroundSwiftUIController: UIHostingController<BackgroundBlurView>?
    
    let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let grabber: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2.5
        button.grabberBlur(style: .systemThinMaterialLight, cornerRadius: 2.5)
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "play.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 44
                )
            ),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialCenter = view.center
        view.addSubview(trackImage)
        view.addSubview(grabber)
        view.addSubview(playPauseButton)
        view.backgroundColor = .systemBackground
        grabber.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        addSwiftUIController()
        layoutViews()
        addPanGesture()
        view.layer.cornerRadius = 50
    }
    
    func layoutViews() {
        grabber.frame = CGRect(
            x: view.frame.width / 2 - 22,
            y: view.frame.minY + 45,
            width: 44,
            height: 44
        )
        
        trackImage.frame = CGRect(
            x: view.frame.width / 2 - 200,
            y: grabber.frame.maxY,
            width: 400,
            height: 400
        )
        
        playPauseButton.frame = CGRect(
            x: view.frame.width / 2 - 22,
            y: trackImage.frame.maxY + 22,
            width: 44,
            height: 44
        )
    }
    
    private func addPanGesture() {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture(_:))
        )
        
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view,
              let superview = view.superview else { return }
        
        
        let translation = gestureRecognizer.translation(in: superview)
        let velocity = gestureRecognizer.velocity(in: superview)
        
        switch gestureRecognizer.state {
        case .changed:
            guard translation.y > 0 else { return }
            
            view.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
            shouldDismiss = translation.y > 400 || velocity.y > 1000 ? true : false
        case .ended, .cancelled:
            if shouldDismiss {
                dismiss(animated: true)
            } else {
                resetToCenter()
            }
        default:
            resetToCenter()
        }
    }
    
    private func resetToCenter() {
        UIView.animate(
            springDuration: 0.36,
            bounce: 0,
            initialSpringVelocity: 0,
            delay: 0,
            options: []) {
                view.center = initialCenter
            }
    }
    
    private func addSwiftUIController() {
        let backgroundController = UIHostingController(rootView: BackgroundBlurView(seedColor: CGColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)))
        addChild(backgroundController)
        backgroundController.didMove(toParent: self)
        view.insertSubview(backgroundController.view, at: 0)
        backgroundController.view.frame = view.frame
        backgroundController.view.layer.cornerRadius = 50
        backgroundController.view.layer.masksToBounds = true
        
        backgroundSwiftUIController = backgroundController
    }
        
    @objc private func didTapDismiss() {
        delegate?.didTapDismiss()
    }
}

#Preview {
    FullScreenPlayerViewController()
}
