//
//  CollectionViewCell.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
       
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName) ?? UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
    }

}
