//
//  CaptureImageButton.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import SwiftUI

struct CaptureImageButton: View {
    @StateObject var imageObject:ImageData
    @StateObject var imageArray:ImageDataArray
    let targetSize: CGFloat = 20 // Desired font size for all texts

    var body: some View {
        Button(action: {
            print("object :\(imageObject.face()) was tapped")
            imageObject.tapped()
            print("open?",imageObject.isOpen)
        }, label: {
            VStack(spacing:15){
                if let image = imageObject.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .padding(5)
                }else{
                    Image(systemName: "photo.badge.plus")
                        .scaleEffect(1.4)
                        .foregroundStyle(.gray)
                        .padding(5)
                }
                
                Text(imageObject.face())
                    .foregroundStyle(.gray)
                    .font(.system(size: 18))
                    .scaledToFit()
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Allow wrapping
                    
                
            }
            .frame(maxWidth: 60)
            .padding(.horizontal,25)
            .padding(.vertical,20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle(
                        lineWidth: 2,
                        dash: [5]
                    ))
                    .foregroundStyle(.gray)
            )
        })
        .sheet(isPresented: $imageObject.isOpen){
            CameraView(imageObject: imageObject, buttonIsTapped: $imageObject.isOpen, imageArray: imageArray)
        }
    }
    
    func fontSize(for text: String) -> CGFloat {
          let largestTextSize = CGFloat(text.count)
          let scalingFactor = targetSize / largestTextSize
          return targetSize * scalingFactor
      }
    
}



