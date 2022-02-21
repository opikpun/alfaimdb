//
//  MovieVideoModel.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import Foundation

struct MovieVideoResponse: Codable {
    let id: Int
    let results: [MovieVideoModel]
}

// MARK: - Result
struct MovieVideoModel: Codable {
    let name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
