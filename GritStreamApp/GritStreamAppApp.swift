//
//  GritStreamAppApp.swift
//  GritStreamApp
//
//  Created by Mac1 on 23.06.21.
//

import SwiftUI
import ARKit
import Combine
import Accelerate

class GuiData: ObservableObject {
    @Published var count: Int = 0
    @Published var colorImage: CGImage?
    @Published var depthImage: CGImage?
}

func test(buffer: CVPixelBuffer){
    CVPixelBufferLockBaseAddress(buffer, .readOnly)
    let width = CVPixelBufferGetWidth(buffer)
    let height = CVPixelBufferGetHeight(buffer)
    let bpr = CVPixelBufferGetBytesPerRow(buffer)
    let pft: OSType = CVPixelBufferGetPixelFormatType(buffer)
    
    let optPointer: UnsafeMutableRawPointer? = CVPixelBufferGetBaseAddress(buffer)
    if pft == kCVPixelFormatType_DepthFloat32 && width * 4 == bpr {
        if optPointer != nil {
            let voidPointer = optPointer!
            let size = width * height
            let floatPointer = voidPointer.bindMemory(to: Float32.self, capacity: size)
            for i in 0..<size {
                floatPointer[i] /= 5.0
            }
        }
    }
    CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
}

@main
final class GritStreamAppApp: App, ARDataReceiver {
    var guiData: GuiData = GuiData()
    var arReceiver: ARReceiver = ARReceiver()
    var ciContext: CIContext = CIContext()
    var dataStream: DataStream = DataStream()
    
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
        
        //test(buffer: arData.depthImage!)
        let depthCiImage: CIImage = CIImage(cvPixelBuffer: arData.depthImage!)
        let depthCgImage: CGImage? = ciContext.createCGImage(depthCiImage, from: depthCiImage.extent)
        
        guiData.colorImage = colorCgImage
        guiData.depthImage = depthCgImage
        guiData.count += 1
        
        if dataStream.connected == true {
            dataStream.stream(arData, guiData.count)
        }
        
    }
}
