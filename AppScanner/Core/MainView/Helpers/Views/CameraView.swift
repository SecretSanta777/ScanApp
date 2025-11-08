//
//  CameraView.swift
//  AppScanner
//
//  Created by Владимир Царь on 05.11.2025.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let cameraLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                cameraLayer.frame = uiView.bounds
            }
        }
    }
}
