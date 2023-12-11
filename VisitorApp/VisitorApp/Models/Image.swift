//
//  Image.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 23/11/2023.
//

import Foundation

// MARK: - Images
struct Images: Codable {
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let recnum, imgid, imgFileName, imgtitle: String?
    let photodt, photonme: String?
    let copy: String?
    let lastModified: String?

    enum CodingKeys: String, CodingKey {
        case recnum = "recnum"
        case imgid = "imgid"
        case imgFileName = "img_file_name"
        case imgtitle = "imgtitle"
        case photodt = "photodt"
        case photonme = "photonme"
        case copy = "copy"
        case lastModified = "last_modified"
    }
}

