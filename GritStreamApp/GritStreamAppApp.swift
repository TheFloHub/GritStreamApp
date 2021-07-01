//
//  GritStreamAppApp.swift
//  GritStreamApp
//
//  Created by Mac1 on 23.06.21.
//

import SwiftUI
import ARKit
import Combine

class Counter: ObservableObject {
    @Published var count: Int = 0
    @Published var cgImage: CGImage? //= Image(systemName: "heart.fill")
    @Published var depthImage: CGImage?
}

func printInfo(of img: CGImage){
    print(img)
    print("is mask: \(img.isMask)")
    print("Width \(img.width) Height \(img.height)")
    print("Bits per component: \(img.bitsPerComponent)")
    print("Bits per pixel: \(img.bitsPerPixel)")
}

@main
final class GritStreamAppApp: App, ARDataReceiver {
    var counter: Counter = Counter()
    var arReceiver: ARReceiver = ARReceiver()
    var ciContext: CIContext = CIContext()
    
    init(){
        arReceiver.delegate = self
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(counter: counter)
        }
    }
    func onNewARData(arData: ARData){
        let ciImage: CIImage = CIImage(cvPixelBuffer: arData.colorImage!)
        //print("Width \(ciImage.extent.width) Height \(ciImage.extent.height)")
        // if ciImage.colorSpace != nil {
        //     print("Color space: \(ciImage.colorSpace!)")
        // }
        
        self.counter.cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
        // print("Width \(self.counter.cgImage!.width) Height \(self.counter.cgImage!.height)")
        print(self.counter.cgImage!)
        
        let ciDepthImage: CIImage = CIImage(cvPixelBuffer: arData.depthImage!)
        //print("Width \(ciDepthImage.extent.width) Height \(ciDepthImage.extent.height)")
        self.counter.depthImage = ciContext.createCGImage(ciDepthImage, from: ciDepthImage.extent)
        //printInfo(of: self.counter.depthImage!)
        
        
        counter.count += 1
    }
}
