//
//  ActionSheetViewController.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import UIKit

class ActionSheetViewController: UIViewController {

    var items: [ListModel] = []

        @IBOutlet weak var countLabel: UILabel!
        @IBOutlet weak var statsLabel: UILabel!
    
    @IBOutlet weak var baseView: UIView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.layer.cornerRadius = 16
            view.clipsToBounds = true
            view.backgroundColor = .systemBackground
            statsLabel.numberOfLines = 0
            statsLabel.lineBreakMode = .byWordWrapping
            baseView.layer.cornerRadius = 10
            baseView.backgroundColor = UIColor(named: "TableViewCellColor")
            updateStats()
        }

    func updateStats() {
        countLabel.text = "Total items in the list: \(items.count)"
        let characters = items
            .map { $0.title.lowercased() }
            .joined()                    
            .filter { $0.isLetter }
        let frequency = Dictionary(characters.map { ($0, 1) }, uniquingKeysWith: +)
        let topThree = frequency
            .sorted { $0.value > $1.value }
            .prefix(3)
        let statText = topThree
            .map { "\($0.key) = \($0.value)" }
            .joined(separator: "\n")
        statsLabel.text = "Top three occurrence characters in the list: \n\(statText)"
    }

}
