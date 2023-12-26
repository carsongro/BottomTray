//
//  FullScreenPlayerViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit

protocol FullScreenPlayerDelegate: AnyObject {
    func didTapDismiss()
}

class FullScreenPlayerViewController: UIViewController {
    
    weak var delegate: FullScreenPlayerDelegate?
    
    let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let grabber: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 2.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.grabberBlur(style: .systemThinMaterialLight, cornerRadius: 2.5)
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(trackImage)
        view.addSubview(grabber)
        view.addSubview(playPauseButton)
        view.backgroundColor = .systemBackground
        grabber.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        addConstraints()
        view.layer.cornerRadius = 50
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            grabber.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 44),
            grabber.heightAnchor.constraint(equalToConstant: 44),
            
            trackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackImage.topAnchor.constraint(equalTo: grabber.bottomAnchor),
            trackImage.widthAnchor.constraint(equalToConstant: 400),
            trackImage.heightAnchor.constraint(equalToConstant: 400),
            
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: trackImage.bottomAnchor, constant: 20),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44),
            playPauseButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
        
    @objc private func didTapDismiss() {
        delegate?.didTapDismiss()
    }
}

#Preview {
    FullScreenPlayerViewController()
}
