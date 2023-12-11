//
//  Bed.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 23/11/2023.
//

import Foundation

// MARK: - Bed
struct Bed: Codable {
    let beds: [BedElement]
}

// MARK: - BedElement
struct BedElement: Codable {
    let bedID: String
    let name: String?
    let latitude, longitude: String
    let lastModified: String

    enum CodingKeys: String, CodingKey {
        case bedID = "bed_id"
        case name = "name"
        case latitude = "latitude"
        case longitude = "longitude"
        case lastModified = "last_modified"
    }
}


