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

class FullScreenPlayerViewController: UIViewController, PlayerObserver {

    weak var delegate: FullScreenPlayerDelegate?
    
    private var initialCenter = CGPoint(x: 0, y: 0)
    private var shouldDismiss = false
    
    let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
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
        grabber.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.didTapDismiss()
            }),
            for: .primaryActionTriggered
        )
        playPauseButton.addAction(
            UIAction(handler: {
                [weak self] _ in
                self?.didTapPlayPause()
            }),
            for: .primaryActionTriggered
        )
        MusicPlayerManager.shared.registerObserver(self)
        MusicPlayerManager.shared.notifyObservers()
        layoutViews()
        addPanGesture()
        view.layer.cornerRadius = 50
    }
    
    func update(with player: ApplicationMusicPlayer) {
        configure(with: player)
    }
    
    func configure(with player: ApplicationMusicPlayer) {
        Task { @MainActor in
            playPauseButton.setImage(
                UIImage(
                    systemName: player.state.playbackStatus == .playing ? "pause.fill" : "play.fill",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 44
                    )
                ),
                for: .normal
            )
            playPauseButton.isEnabled = true
            
            guard let width = player.queue.currentEntry?.artwork?.maximumWidth,
                  let height = player.queue.currentEntry?.artwork?.maximumHeight,
                  let url = player.queue.currentEntry?.artwork?.url(width: width, height: height) else {
                return
            }
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            trackImage.image = UIImage(data: data)
            trackImage.alpha = 1
        }
    }

    func layoutViews() {
        grabber.frame = CGRect(
            x: view.frame.width / 2 - 22,
            y: view.frame.minY + 45,
            width: 44,
            height: 44
        )
        
        let imageWith = view.frame.width - 30
        trackImage.frame = CGRect(
            x: view.center.x - imageWith / 2,
            y: grabber.frame.maxY + 10,
            width: imageWith,
            height: imageWith
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
    
    private func didTapPlayPause() {
        MusicPlayerManager.shared.handlePlayPause()
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
        
    private func didTapDismiss() {
        delegate?.didTapDismiss()
    }
}

#Preview {
    FullScreenPlayerViewController()
}
