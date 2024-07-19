/*
 Fairy Technologies CONFIDENTIAL
 __________________
  
 Copyright (C) Fairy Technologies, Inc - All Rights Reserved
 
 NOTICE:  All information contained herein is, and remains
 the property of Fairy Technologies Incorporated and its suppliers,
 if any.  The intellectual and technical concepts contained
 herein are proprietary to Fairy Technologies Incorporated
 and its suppliers and may be covered by U.S. and Foreign Patents,
 patents in process, and are protected by trade secret or copyright law.
 Dissemination of this information, or reproduction or modification of this material
 is strictly forbidden unless prior written permission is obtained
 from Fairy Technologies Incorporated.
*/

import Foundation
import UIKit
import Moment

class CashbackTableViewCell: UITableViewCell {
    static let identifier = "CashbackCell"
    
    private let businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let businessNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(businessImageView)
        contentView.addSubview(businessNameLabel)
        
        NSLayoutConstraint.activate([
            businessImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            businessImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            businessImageView.widthAnchor.constraint(equalToConstant: 50),
            businessImageView.heightAnchor.constraint(equalToConstant: 50),
            
            businessNameLabel.leadingAnchor.constraint(equalTo: businessImageView.trailingAnchor, constant: 16),
            businessNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            businessNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with program: CashbackProgram) {
        businessNameLabel.text = program.businessName
        loadImage(from: program.businessImageURL)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self?.businessImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
