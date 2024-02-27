//
//  PhotoBundle.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 22/02/24.
//

import Foundation

class PhotoBundle: Codable {
    var brand: String
    var images: [ImageData]

    init(brand: String, images: [ImageData]) {
        self.brand = brand
        self.images = images
    }

    // Implementing Codable methods

    enum CodingKeys: String, CodingKey {
        case brand
        case images
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brand = try container.decode(String.self, forKey: .brand)
        images = try container.decode([ImageData].self, forKey: .images)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brand, forKey: .brand)
        try container.encode(images, forKey: .images)
    }
}
