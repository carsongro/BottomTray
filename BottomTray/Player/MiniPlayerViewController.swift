//
//  MiniPlayerViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit

class MiniPlayerViewController: UIViewController {
    
    private let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textView: UILabel = {
        let label = UILabel()
        label.text = "Track Name"
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playPauseButton: UIButton = {
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
        return button
    }()
    
    var tapHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(trackImage)
        view.addSubview(textView)
        view.addSubview(playPauseButton)
        addConstraints()
        view.layer.cornerRadius = 15
        view.backgroundColor = .secondarySystemBackground
        addTapGesture()
    }
    
    func registerTapHandler(_ handler: @escaping () -> Void) {
        tapHandler = handler
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            trackImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackImage.heightAnchor.constraint(equalToConstant: 45),
            
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
    
    private func presentFullScreenPlayer() {
        let fullScreenPlayer = FullScreenPlayerViewController()
        fullScreenPlayer.modalPresentationStyle = .custom
        fullScreenPlayer.transitioningDelegate = self
        if let sheet = fullScreenPlayer.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        present(fullScreenPlayer, animated: true)
    }
}

extension MiniPlayerViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return FullScreenPlayerAnimationController(originFrame: view.frame)
    }
}

#Preview {
    MiniPlayerViewController()
}
