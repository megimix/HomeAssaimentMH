//
//  SearchQuery.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import Foundation

struct SearchQuery {
    var term: String
    var media: String = "podcast"
    var limit: Int = 10
    var offset: Int = 0

    var toDictionary: [String: String] {
        return [
            "term": term,
            "media": media,
            "entity": media,
            "limit": String(limit),
            "offset": String(offset)
        ]
    }
}
