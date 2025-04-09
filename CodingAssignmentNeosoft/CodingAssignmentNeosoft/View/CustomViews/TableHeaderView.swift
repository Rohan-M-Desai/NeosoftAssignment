//
//  TableHeaderView.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import UIKit

class TableHeaderView: UIView {

    @IBOutlet weak var carouselCollectionView: UICollectionView!
       @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var imagesPageControl: UIPageControl!
    
    static func loadFromNib() -> TableHeaderView {
           return Bundle.main.loadNibNamed("TableHeaderView", owner: nil, options: nil)?.first as! TableHeaderView
       }

}
