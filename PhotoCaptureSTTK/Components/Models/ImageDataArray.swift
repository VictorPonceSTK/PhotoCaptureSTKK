//
//  ImageDataArray.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 22/02/24.
//

import Foundation
class ImageDataArray: ObservableObject {
    @Published var images: [ImageData]
    
    init(images: [ImageData]) {
        
        self.images = images
    }
    
    func setImages(_ image:ImageData){
        if let idx = images.firstIndex(where: {$0.type == image.type}){
            images[idx]
        }else{
            self.images.append(image)
        }
        
    }
}
