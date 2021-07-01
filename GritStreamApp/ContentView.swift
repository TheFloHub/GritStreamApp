//
//  ContentView.swift
//  GritStreamApp
//
//  Created by Mac1 on 23.06.21.
//

import SwiftUI
import ARKit
import Combine

struct ContentView: View {
     
    @ObservedObject var counter: Counter
    
    
    var body: some View {
        if !ARWorldTrackingConfiguration.supportsFrameSemantics([.sceneDepth, .smoothedSceneDepth]) {
            Text("Unsupported Device: This app requires the LiDAR Scanner to access the scene's depth.")
        } else {
            if counter.cgImage != nil {
                Image(decorative: counter.depthImage!, scale: 1.0, orientation: .right)
            }
            Text("Hello, world! Count: " + String(counter.count)).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       Text("PREVIEW MISSING!")
    }
}
