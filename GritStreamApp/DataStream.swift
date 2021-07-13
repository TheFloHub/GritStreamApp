//
//  DataStream.swift
//  GritStreamApp
//
//  Created by Mac1 on 12.07.21.
//

import Foundation
import Network

final class DataStream {

    let connection: NWConnection
    var connected: Bool = false
    
    init(){
        //let host = NWEndpoint.Host("192.168.0.10")
        //let port = NWEndpoint.Port("12345")!
        self.connection = NWConnection(host: "192.168.0.10", port: 12345, using: .tcp)
        
        self.connection.stateUpdateHandler = { (newState) in
              switch (newState) {
              case .ready:
                  print("ready")
                  self.connected = true
              case .setup:
                  print("setup")
              case .cancelled:
                  print("cancelled")
              case .preparing:
                  print("Preparing")
              default:
                  print("waiting or failed")
              }
          }
        self.connection.start(queue: .global())
    }
    
    func stream(_ arData: ARData, _ count: Int){
        //let data = "Test message Flo".data(using: String.Encoding.utf8)// Data("\(count)\r\n".utf8)
        //var tempInt = count
        //var myIntData = Data(bytes: &tempInt, count: MemoryLayout.size(ofValue: tempInt))
        //let myArray: [Float32] = [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8]
        //var data = "1234567887654321".data(using: String.Encoding.utf8)
        //data = myArray.withUnsafeBytes{Data($0)}
        
        arData.sendDepthMap(self.connection)
        /*
        self.connection.send(content: data,
                             completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                print("did send, error: %@", "\(error)")
                self.connection.cancel()
            } else {
                //print("did send, data:", data)
            }
        })
         */
    }
    
    func send() {
        self.connection.send(content: "Test message Flo".data(using: String.Encoding.utf8), completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            print("Did send message.")
            print(NWError)
        })))
    }

    func receive() {
        self.connection.receiveMessage { (data, context, isComplete, error) in
            print("Got it")
            print(data)
        }
    }
}

