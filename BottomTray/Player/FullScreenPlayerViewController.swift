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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(trackImage)
        view.addSubview(grabber)
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
        ])
    }
        
    @objc private func didTapDismiss() {
        delegate?.didTapDismiss()
    }
}

#Preview {
    FullScreenPlayerViewController()
}
