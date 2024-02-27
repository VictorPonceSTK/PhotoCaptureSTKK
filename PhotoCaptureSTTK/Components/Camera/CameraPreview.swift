//
//  CameraPreview.swift
//  PhotoCaptureSTTK
//
//  Created by Victor David Ponce Quintanilla on 21/02/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable{
    @ObservedObject  var camera: CameraModel
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        //your own properties
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        //Thi should be in a back ground thread, however since we access the camera a lot
        //it shouldn't matter too much
        camera.session.startRunning()

        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
