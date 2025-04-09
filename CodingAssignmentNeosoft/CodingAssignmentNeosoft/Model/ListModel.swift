//
//  ListModel.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import Foundation

struct ListModel:Codable {
    let imageName: String
    let title: String
    let subtitle: String
}

struct CarouselSection:Codable {
    let imageName: String
    let data: [ListModel]
}
