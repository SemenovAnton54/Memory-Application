//
//  ImageObject.swift
//  Memory
//

import Foundation

enum ImageObject: Hashable, Codable {
    case remote(URL)
    case systemName(String)
    case local(String)
    case data(Data)
    case empty
}
