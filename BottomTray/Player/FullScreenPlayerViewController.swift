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
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(trackImage)
        view.addSubview(dismissButton)
        view.backgroundColor = .systemBackground
        addConstraints()
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        view.layer.cornerRadius = 50
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            
            trackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackImage.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10),
            trackImage.widthAnchor.constraint(equalToConstant: 400),
            trackImage.heightAnchor.constraint(equalToConstant: 400),
        ])
    }
        
    @objc private func didTapDismiss() {
        delegate?.didTapDismiss()
    }
}
