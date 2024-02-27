//
//  CameraModel.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import Foundation
import AVFoundation
import Accelerate
import UIKit
import SwiftUI
class CameraModel: NSObject,ObservableObject,AVCapturePhotoCaptureDelegate, AVCaptureDepthDataOutputDelegate{
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    //   reading pic data
    @Published var photoOutput = AVCapturePhotoOutput()
    //   photo settings

    @Published var preview:AVCaptureVideoPreviewLayer!
    @Published var depthImage:UIImage?
    @Published var regularImage:UIImage?
    
    func check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status )in
                if status {
                    self.setUp()
                }
            }
            return
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
        
    }

    
    func setUp(){
        do{
            for input in session.inputs{
                session.removeInput(input)
            }
            for output in session.outputs{
                session.removeOutput(output)
            }
                    
            
            //Settings configs
            self.session.beginConfiguration()
            
            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            
            let device = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
        
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(photoOutput){
                session.addOutput(photoOutput)
                self.session.sessionPreset = .photo
            }
            
            
            self.photoOutput.isDepthDataDeliveryEnabled = true
           
            
            self.session.commitConfiguration()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func reTake(){
        print("retake function was tapped")
        self.depthImage = nil
        self.regularImage = nil
        self.isTaken.toggle()
    }
    
    func takePic(){
        DispatchQueue.global(qos: .userInitiated).async {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            settings.embedsDepthDataInPhoto = true
            settings.isDepthDataFiltered = true
            settings.isDepthDataDeliveryEnabled = true // this causes code to crash
            //
            self.photoOutput.capturePhoto(with: settings, delegate:self)
            print("things are working still")
            DispatchQueue.main.async{
                withAnimation{
                    self.isTaken.toggle()
                }
            }
            
        }
    }
    
    
    
    //    This is working for now
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo!!!!!: \(error.localizedDescription)")
            return
        }
        
        // Extract image
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Error converting photo data to UIImage.")
            return
        }
        
        //         Extract depth data
        guard var depthData = photo.depthData else {
            print("No depth data found.")
            return
        }
        let ciImage = CIImage(cvPixelBuffer: depthData.depthDataMap)
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciImage, from: ciImage.extent)!
        self.depthImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        self.regularImage =  image

        self.session.stopRunning()
        print("Picture taken...")
    }
    
    
    
}
