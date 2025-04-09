//
//  MainViewModel.swift
//  CodingAssignmentNeosoft
//
//  Created by Rohan Desai on 09/04/25.
//

import Foundation
class MainViewModel {
    
    var originalSections: [CarouselSection] = []
    var sections: [CarouselSection] = []
    var selectedIndex: Int = 0
    var onSectionsUpdated: (() -> Void)?
    
    
    init() {}
    
    func loadData() {
            guard let url = Bundle.main.url(forResource: "/data", withExtension: "json") else {
                print("JSON not found.")
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let decodedSections = try JSONDecoder().decode([CarouselSection].self, from: data)
                self.originalSections = decodedSections
                self.sections = decodedSections
                onSectionsUpdated?()
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
    
    func filterSections(with searchText: String) {
        if searchText.isEmpty {
            self.sections = originalSections
        } else {
            let filtered = originalSections.compactMap { section -> CarouselSection? in
                let filteredItems = section.data.filter {
                    $0.title.lowercased().contains(searchText.lowercased()) ||
                    $0.subtitle.lowercased().contains(searchText.lowercased())
                }
                return filteredItems.isEmpty ? nil : CarouselSection(imageName: section.imageName, data: filteredItems)
            }
            self.sections = filtered
        }
        onSectionsUpdated?()
    }

        func listItemsForSelectedCarousel() -> [ListModel] {
            guard selectedIndex < sections.count else { return [] }
            return sections[selectedIndex].data
        }

        func itemCount() -> Int {
            return listItemsForSelectedCarousel().count
        }

        func top3Characters() -> [(Character, Int)] {
            let titles = listItemsForSelectedCarousel().map { $0.title.lowercased() }.joined()
            let filtered = titles.filter { $0.isLetter }
            let counts = Dictionary(filtered.map { ($0, 1) }, uniquingKeysWith: +)
            return counts.sorted(by: { $0.value > $1.value }).prefix(3).map { ($0.key, $0.value) }
        }
}
