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
     
    @ObservedObject var guiData: GuiData
    
    
    var body: some View {
        if !ARWorldTrackingConfiguration.supportsFrameSemantics([.sceneDepth, .smoothedSceneDepth]) {
            Text("Unsupported Device: This app requires the LiDAR Scanner to access the scene's depth.")
        } else {
            
            if guiData.depthImage != nil && guiData.colorImage != nil {
                Image(decorative: guiData.colorImage!, scale: 1.0, orientation: .right).resizable().scaledToFit()
                Image(decorative: guiData.depthImage!, scale: 1.0, orientation: .right).resizable().scaledToFit()
            }
            Text("Hello, world! Count: " + String(guiData.count)).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       Text("PREVIEW MISSING!")
    }
}
