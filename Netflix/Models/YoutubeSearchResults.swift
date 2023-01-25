//
//  YoutubeSearchResults.swift
//  Netflix
//
//  Created by Дмитрий Процак on 05.12.2022.
//

//items =     (
//{
//etag = "CDOClxmQCtgAZWNEkHrnR-B9qKg";
//id =             {
//kind = "youtube#video";
//videoId = "l-9Pd8K44V4";
//};
//kind = "youtube#searchResult";
//},

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
