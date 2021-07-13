import Foundation
import Combine
import ARKit
import Network


protocol ARDataReceiver: AnyObject {
    func onNewARData(arData: ARData)
}

final class ARData {
    var depthImage: CVPixelBuffer?
    var depthSmoothImage: CVPixelBuffer?
    var colorImage: CVPixelBuffer?
    var confidenceImage: CVPixelBuffer?
    var confidenceSmoothImage: CVPixelBuffer?
    var cameraIntrinsics = simd_float3x3()
    var cameraResolution = CGSize()
    
    func sendDepthMap(_ connection: NWConnection){
        if depthImage == nil{
            return
        }
        let dm = depthImage!
        CVPixelBufferLockBaseAddress(dm, .readOnly)
        let width = CVPixelBufferGetWidth(dm)
        let height = CVPixelBufferGetHeight(dm)
        let bpr = CVPixelBufferGetBytesPerRow(dm)
        let pft: OSType = CVPixelBufferGetPixelFormatType(dm)
        
        let optPointer: UnsafeMutableRawPointer? = CVPixelBufferGetBaseAddress(dm)
        if pft == kCVPixelFormatType_DepthFloat32 && width * 4 == bpr && width == 256 && height == 192 {
            if optPointer != nil {
                
                let myData = Data(bytesNoCopy: optPointer!, count: 4 * width * height, deallocator: .none)
                connection.send(content: myData,
                                     completion: NWConnection.SendCompletion.contentProcessed { error in
                    if let error = error {
                        print("did send, error: %@", "\(error)")
                        connection.cancel()
                    } else {
                        //print("did send, data:", data)
                    }
                })
            }
        }
        CVPixelBufferUnlockBaseAddress(dm, .readOnly)
    }
}

final class ARReceiver: NSObject, ARSessionDelegate {
    var arData = ARData()
    var arSession = ARSession()
    weak var delegate: ARDataReceiver?
    
    override init() {
        super.init()
        arSession.delegate = self
        start()
    }
    
    func start() {
        guard ARWorldTrackingConfiguration.supportsFrameSemantics([.sceneDepth, .smoothedSceneDepth]) else { return }
        let config = ARWorldTrackingConfiguration()
        config.frameSemantics = [.sceneDepth, .smoothedSceneDepth]
        arSession.run(config)
    }
    
    func pause() {
        arSession.pause()
    }
  
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if(frame.sceneDepth != nil) && (frame.smoothedSceneDepth != nil) {
            //print(frame.camera)
            //print(frame.timestamp)
            //print(Date(timeIntervalSinceNow: frame.capturedDepthDataTimestamp))
            arData.depthImage = frame.sceneDepth?.depthMap
            arData.depthSmoothImage = frame.smoothedSceneDepth?.depthMap
            arData.confidenceImage = frame.sceneDepth?.confidenceMap
            arData.confidenceSmoothImage = frame.smoothedSceneDepth?.confidenceMap
            arData.colorImage = frame.capturedImage
            arData.cameraIntrinsics = frame.camera.intrinsics
            arData.cameraResolution = frame.camera.imageResolution
            delegate?.onNewARData(arData: arData)
        }
    }
}

