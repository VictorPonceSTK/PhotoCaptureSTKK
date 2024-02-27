//
//  CameraView.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import SwiftUI

struct CameraView: View {
    @StateObject var camera = CameraModel()
    @ObservedObject var imageObject:ImageData
    @Binding var buttonIsTapped:Bool
    @StateObject var imageArray:ImageDataArray
    
    var body: some View {
        ZStack{
            if let selectedImage = camera.regularImage{
                Image(uiImage: selectedImage)
                    .resizable()
//                    .scaledToFit()
            }else{
                if(camera.isTaken){
                    ProgressView()
                }else{
                    CameraPreview(camera: camera)
                        .ignoresSafeArea(.all,edges: .all)
                }
                
            }
            VStack{                
                Spacer()
                HStack{
                    //if taken showing save and take pictures again
                    if camera.isTaken{
                        Button(action:{
                            imageObject.setImage(image: camera.regularImage!, type: .regular)
                            imageObject.setImage(image: camera.depthImage!, type: .depth)
                            imageArray.setImages(imageObject)
                            imageObject.tapped()
                        }, label: {
                            Text("Guardar")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        Spacer()
                        Button(action:camera.reTake, label: {
                            Text("Retomar")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(.white)
                                .clipShape(Capsule())
                        })
                        .padding(.trailing)
                    }else{
                        Button(action:( camera.takePic),label: {
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 70,height: 70)
                                Circle()
                                    .stroke(.white,lineWidth:2)
                                    .frame(width: 75,height: 75)
                                
                            }
                        })
                    }
                }
            }
            
        }
        .onAppear(perform:camera.check)
    }
}

//#Preview {
//    CameraView()
//}
