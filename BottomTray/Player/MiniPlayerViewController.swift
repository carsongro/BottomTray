//
//  MiniPlayerViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit
import Observation
import MusicKit

protocol PlayerSubject {
    func registerObserver(_ observer: PlayerObserver)
    func removeObserver(_ observer: PlayerObserver)
    func notifyObservers()
}

protocol PlayerObserver: AnyObject {
    func update(with player: ApplicationMusicPlayer)
}

class MiniPlayerViewController: UIViewController, FullScreenPlayerDelegate, PlayerObserver {
    
    let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.alpha = 0
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let textView: UILabel = {
        let label = UILabel()
        label.text = "Nothing Playing"
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(
                systemName: "play.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 22
                )
            ),
            for: .normal
        )
        button.tintColor = .label
        button.isEnabled = false
        return button
    }()
    
    var tapHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(trackImage)
        view.addSubview(textView)
        view.addSubview(playPauseButton)
        addConstraints()
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        MusicPlayerManager.shared.registerObserver(self)
        view.layer.cornerRadius = 15
        view.backgroundColor = .secondarySystemBackground
        addTapGesture()
    }
    
    func registerTapHandler(_ handler: @escaping () -> Void) {
        tapHandler = handler
    }
    
    func update(with player: ApplicationMusicPlayer) {
        configure(with: player)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            trackImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackImage.heightAnchor.constraint(equalToConstant: 40),
            trackImage.widthAnchor.constraint(equalToConstant: 40),
            
            textView.leftAnchor.constraint(equalTo: trackImage.rightAnchor, constant: 20),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            playPauseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playPauseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            playPauseButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        presentFullScreenPlayer()
    }
    
    @objc private func didTapPlayPause() {
        MusicPlayerManager.shared.handlePlayPause()
    }
    
    private func presentFullScreenPlayer() {
        let fullScreenPlayer = FullScreenPlayerViewController()
        fullScreenPlayer.modalPresentationStyle = .custom
        fullScreenPlayer.delegate = self
        fullScreenPlayer.transitioningDelegate = self
        present(fullScreenPlayer, animated: true)
    }
    
    func didTapDismiss() {
        dismiss(animated: true)
    }
    
    func configure(with player: ApplicationMusicPlayer) {
        dump(player.state)
        Task { @MainActor in
            playPauseButton.setImage(
                UIImage(
                    systemName: player.state.playbackStatus == .playing ? "pause.fill" : "play.fill",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 22
                    )
                ),
                for: .normal
            )
            playPauseButton.isEnabled = true
            
            textView.text = player.queue.currentEntry?.title
            
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
    
    private func resetPlayerView() {
        trackImage.image = nil
        textView.text = "Nothing Playing"
        playPauseButton.setImage(
            UIImage(
                systemName: "play.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 22
                )
            ),
            for: .normal
        )
    }
}

extension MiniPlayerViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        FullScreenPlayerAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FullScreenPlayerAnimationController()
    }
}

#Preview {
    MiniPlayerViewController()
}
