//
//  Plant.swift
//  VisitorApp
//
//  Created by Yuvaraj Mayank Konjeti on 23/11/2023.
//

import Foundation

// MARK: - Plants
struct Plants: Codable {
    let plants: [Plant]
}

// MARK: - Plant
struct Plant: Codable {
    let recnum, acid, accsta, family: String?
    let genus, species, infraspecificEpithet, vernacularName: String?
    let cultivarName, donor, latitude, longitude: String?
    let country, iso, sgu, loc: String?
    let alt, cnam, cid, cdat: String?
    let bed, memoriam: String?
    let redlist: String?
    let lastModified: String?

    enum CodingKeys: String, CodingKey {
        case recnum = "recnum"
        case acid = "acid"
        case accsta = "accsta"
        case family = "family"
        case genus = "genus"
        case species = "species"
        case infraspecificEpithet = "infraspecific_epithet"
        case vernacularName = "vernacular_name"
        case cultivarName = "cultivar_name"
        case donor = "donor"
        case latitude = "latitude"
        case longitude = "longitude"
        case country = "country"
        case iso = "iso"
        case sgu = "sgu"
        case loc = "loc"
        case alt = "alt"
        case cnam = "cnam"
        case cid = "cid"
        case cdat = "cdat"
        case bed = "bed"
        case memoriam = "memoriam"
        case redlist = "redlist"
        case lastModified = "last_modified"
    }
}
