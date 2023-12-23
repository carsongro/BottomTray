//
//  FullScreenPlayerViewController.swift
//  BottomTray
//
//  Created by Carson Gross on 12/22/23.
//

import UIKit

class FullScreenPlayerViewController: UIViewController {
    
    private let trackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(trackImage)
        view.backgroundColor = .systemBackground
        addConstraints()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            trackImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackImage.widthAnchor.constraint(equalToConstant: 200),
            trackImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
