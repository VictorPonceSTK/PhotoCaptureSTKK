//
//  ContentView.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import SwiftUI

struct ContentView: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    @State var brand:Brands = .Toyota
    
    @State var imageData: [ImageData] = {
        var imageDataArray = [ImageData]()
        for face in [Face.front, .back, .right, .left] {
            imageDataArray.append(ImageData(type: face))
        }
        return imageDataArray
    }()
    @State var takePicture = false
    @State var selectedImageButton:ImageData?
    @State var buttonIsTapped = false
    @State var done = true
    @State var waiting = false
    @State var error:Bool = false
    @StateObject var imageArray:ImageDataArray = ImageDataArray(images: [])
    
    var body: some View {
        
        NavigationStack {
            if waiting{
                Loading()
            }else{
                VStack {
                    HStack(){
                        Text("Seleccionar marca")
                        Spacer()
                        Picker("Seleccionar marca", selection: $brand){
                            ForEach(Brands.allCases){ brand in
                                Text(brand.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                    
                    LazyVGrid(columns: columns,spacing: 25){
                        ForEach(imageData, id: \.type) { imageDataItem in
                            CaptureImageButton(imageObject: imageDataItem,imageArray: imageArray)
                        }
                    }
                    
                    Spacer()
                    Button(action: submit, label: {
                        Text("Enviar")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    })
                    .disabled(done)
                }
                .padding()
            }
        }
        
        .onChange(of: imageArray.images.count){
            print("inside onChange")
            if imageArray.images.count == 4 {
                done.toggle()
            }
        }
        .alert(Text("Error al subir a base de datos"), isPresented: $error){
            Button("Volver a intentar"){
                restetVars()
            }
        }
    }
    
    func submit() {
        waiting = true
        let photoBundle = PhotoBundle(brand: self.brand.rawValue, images: imageData)
        sendToStorage(PhotoBundle: photoBundle) { resp in
            switch resp {
            case .success(let ans):
                restetVars()
            case .failure(let err):
                error = true
                print(err)
            }
        }
    }
    func restetVars(){
        brand = .Toyota
        imageData.removeAll()
        imageData = {
            var imageDataArray = [ImageData]()
            for face in [Face.front, .back, .right, .left] {
                imageDataArray.append(ImageData(type: face))
            }
            return imageDataArray
        }()
        takePicture = false
        selectedImageButton = nil
        buttonIsTapped = false
        done = true // Here's the correction, you're assigning to the outer 'done' variable
        waiting = false
    }
}

func restetVars(){
    
}

enum Brands:String,CaseIterable,Identifiable{
    case Toyota,Mazda
    var id: Self { self }
}


#Preview {
    ContentView()
}
