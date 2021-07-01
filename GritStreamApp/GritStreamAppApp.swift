//
//  GritStreamAppApp.swift
//  GritStreamApp
//
//  Created by Mac1 on 23.06.21.
//

import SwiftUI
import ARKit
import Combine

class GuiData: ObservableObject {
    @Published var count: Int = 0
    @Published var colorImage: CGImage?
    @Published var depthImage: CGImage?
}

@main
final class GritStreamAppApp: App, ARDataReceiver {
    var guiData: GuiData = GuiData()
    var arReceiver: ARReceiver = ARReceiver()
    var ciContext: CIContext = CIContext()
    
    init(){
        arReceiver.delegate = self
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(guiData: guiData)
        }
    }
    func onNewARData(arData: ARData){
        let colorCiImage: CIImage = CIImage(cvPixelBuffer: arData.colorImage!)
        let colorCgImage: CGImage? = ciContext.createCGImage(colorCiImage, from: colorCiImage.extent)
        
        let depthCiImage: CIImage = CIImage(cvPixelBuffer: arData.depthImage!)
        let depthCgImage: CGImage? = ciContext.createCGImage(depthCiImage, from: depthCiImage.extent)
        
        guiData.colorImage = colorCgImage
        guiData.depthImage = depthCgImage
        guiData.count += 1
    }
}
