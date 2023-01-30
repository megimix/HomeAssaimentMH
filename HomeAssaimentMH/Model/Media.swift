//
//  Media.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import Foundation

struct Media: Identifiable, Codable {
    var id: Int
    var name: String?
    var artistName: String?
    var imageUrl: URL
    var releaseDate: Date?
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case artistName, releaseDate
        case id = "trackId"
        case name = "trackName"
        case imageUrl = "artworkUrl100"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)

        name = try? container.decode(String.self, forKey: .name)
        artistName = try? container.decode(String.self, forKey: .artistName)

        imageUrl = try container.decode(URL.self, forKey: .imageUrl)
        releaseDate = try? container.decode(Date.self, forKey: .releaseDate)
    }
    
    init(id: Int,
         name: String? = nil,
         artistName: String? = nil,
         imageUrl: URL,
         releaseDate: Date? = nil) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.imageUrl = imageUrl
        self.releaseDate = releaseDate
    }
}

struct MediaList: Codable {
    var results: [Media]
}
