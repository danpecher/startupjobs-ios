import Foundation

fileprivate struct Area: Decodable {
    let slug: String
    let name: String
    let children: [Area]
}

class AreaOptionsLoader {
    func load() -> [FilterOption] {
        let time = Date()
        
        guard let fileUrl = Bundle.main.url(forResource: "areas", withExtension: "json") else {
            print("areas.json not found!")
            return []
        }
        
        let options = try! JSONDecoder().decode(
            [Area].self,
            from: Data(contentsOf: fileUrl)
        ).map {
            FilterOption(key: $0.slug, value: $0.name, children: loadTree(area: $0))
        }
        
        return options
    }
    
    private func loadTree(area: Area) -> [FilterOption] {
        area.children.map {
            FilterOption(key: $0.slug, value: $0.name, children: loadTree(area: $0))
        }
    }
}
