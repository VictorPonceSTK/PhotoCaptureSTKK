//
//  ImageData.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import Foundation
import UIKit

class ImageData:ObservableObject,Codable{
    @Published var image:UIImage?
    @Published var depthImage:UIImage?
    @Published var isOpen:Bool = false
    var type: Face
    
    init(image: UIImage? = nil, depthImage: UIImage? = nil, type: Face) {
        self.image = image
        self.depthImage = depthImage
        self.type = type
    }
    required init(from decoder: Decoder)throws  {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let imageData = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: imageData) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: container, debugDescription: "Invalid image data")
        }
        
        let depthImage = try container.decode(Data.self, forKey: .depthImage)
        guard let depthImage = UIImage(data: depthImage) else {
            throw DecodingError.dataCorruptedError(forKey: .image, in: container, debugDescription: "Invalid image data")
        }
        
        // Decode face as string
        let face = try container.decode(String.self, forKey: .type)
        
        // Set image and depthImage properties
        self.image = image
        self.depthImage = depthImage
        
        // Set type property based on the decoded face string
        self.type = ImageData.setFace(face)!
    }

    static func setFace(_ face: String) -> Face? {
        switch face {
        case "Frente":
            return .front
        case "Detras":
            return .back
        case "Izq":
            return .left
        case "Der":
            return .right
        default:
            print("Unexpected face value: \(face)")
            return nil
        }
    }
    
    func face()->String{
        switch type {
        case .front :
            return "Frente"
        case .back:
            return "Detras"
        case .left:
            return "Izq"
        case .right:
            return "Der"
        }
    }
    
    func setImage(image:UIImage, type:Imagetype){
        switch type{
        case .depth:
            self.depthImage = image
            break
        case .regular:
            self.image = image
            break
        }
    
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode image
        if let imageData = self.image?.pngData() {
            try container.encode(imageData, forKey: .image)
        } else {
            throw EncodingError.invalidValue(self.image ?? UIImage(), EncodingError.Context(codingPath: [CodingKeys.image], debugDescription: "Cannot encode image"))
        }
        
        // Encode depth image
        if let depthImageData = self.depthImage?.pngData() {
            try container.encode(depthImageData, forKey: .depthImage)
        } else {
            throw EncodingError.invalidValue(self.depthImage ?? UIImage(), EncodingError.Context(codingPath: [CodingKeys.depthImage], debugDescription: "Cannot encode depth image"))
        }
        
        // Encode face type
        try container.encode(self.face(), forKey: .type)
    }
    
    
    func tapped(){
        self.isOpen.toggle()
    }
}

enum CodingKeys: String, CodingKey {
    case image
    case depthImage
    case type
}

enum Imagetype{
    case depth
    case regular
}

enum Face{
    case front
    case back
    case left
    case right
}
