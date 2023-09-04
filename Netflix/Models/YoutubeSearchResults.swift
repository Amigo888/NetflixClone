//
//  YoutubeSearchResults.swift
//  Netflix
//
//  Created by Дмитрий Процак on 05.12.2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
