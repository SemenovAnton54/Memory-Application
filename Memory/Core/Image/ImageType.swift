//
//  ImageType.swift
//  Memory
//

import Foundation

enum ImageType: Hashable, Codable {
    case remote(URL)
    case systemName(String)
    case local(String)
    case data(Data)
    case empty
}
