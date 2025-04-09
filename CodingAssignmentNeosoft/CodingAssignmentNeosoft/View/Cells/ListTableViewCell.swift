//
//  ListTableViewCell.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var listItemBaseView: UIView!
    
    func configure(with item: ListModel) {
        itemImageView.image = UIImage(named: item.imageName) ?? UIImage(systemName: "photo")
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        itemImageView.layer.cornerRadius = 10
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listItemBaseView.layer.cornerRadius = 15
        listItemBaseView.layer.masksToBounds = true
        listItemBaseView.backgroundColor = UIColor(named: "TableViewCellColor")
        self.backgroundColor = .clear
    }
    
}
