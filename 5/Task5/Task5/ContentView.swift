//
//  ContentView.swift
//  Task5
//
//  Created by Philipp on 26.01.2022.
//

import SwiftUI
import CoreMotion
import ARKit
import UIKit

struct ContentView: View {
    
    // Available sensors
    private let motionManager = CMMotionManager()
    
    func isLiDARAvailable() -> Bool {
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
           return true
       } else {
           return false
       }
    }
    
    // Accelerometer data
    @State private var accX: Double = 0
    @State private var accY: Double = 0
    @State private var accZ: Double = 0
    
    //Gyroscope data
    @State private var gyroX:Double = 0.0
    @State private var gyroY:Double = 0.0
    @State private var gyroZ:Double = 0.0
    
    //Magnetometer data
    @State private var magX:Double = 0.0
    @State private var magY:Double = 0.0
    @State private var magZ:Double = 0.0
    
    //Camera app
    let vc = UIImagePickerController()
    @Binding var image = Image("sample")
    @Binding var showCamera = true
    
    
    var body: some View {
        Form {
            Section(header: Text("Available sensors")) {
                HStack {
                    Text("Gyroscope")
                        .font(Font.headline)
                    Spacer()
                    Text(String(motionManager.isGyroAvailable))
                }.padding(5)
                
                HStack {
                    Text("Motion Sensor")
                        .font(Font.headline)
                    Spacer()
                    Text(String(motionManager.isDeviceMotionAvailable))
                }.padding(5)
                
                HStack {
                    Text("Accelerometer")
                        .font(Font.headline)
                    Spacer()
                    Text(String(motionManager.isAccelerometerAvailable))
                }.padding(5)
                
                HStack {
                    Text("Magnetometer")
                        .font(Font.headline)
                    Spacer()
                    Text(String(motionManager.isMagnetometerAvailable))
                }.padding(5)
                
                HStack {
                    Text("LiDAR")
                        .font(Font.headline)
                    Spacer()
                    Text(String(isLiDARAvailable()))
                }.padding(5)
            }
            
            Section (header: Text("Accelerometer data")) {
                HStack {
                    Text("X")
                        .font(Font.headline)
                    Spacer()
                    Text(String(accX))
                }.padding(5)
                
                HStack {
                    Text("Y")
                        .font(Font.headline)
                    Spacer()
                    Text(String(accY))
                }.padding(5)
                
                HStack {
                    Text("Z")
                        .font(Font.headline)
                    Spacer()
                    Text(String(accZ))
                }.padding(5)
                
                Button (action: {
                    motionManager.startAccelerometerUpdates()
                    if motionManager.accelerometerData != nil {
                        accX = motionManager.accelerometerData?.acceleration.x ?? 0
                        accY = motionManager.accelerometerData?.acceleration.y ?? 0
                        accZ = motionManager.accelerometerData?.acceleration.z ?? 0
                    }
                }){
                    Text("Start Accelerometer")
                }
            }
            
            Section (header: Text("Gyroscope data")) {
                HStack {
                    Text("X")
                        .font(Font.headline)
                    Spacer()
                    Text(String(gyroX))
                }.padding(5)
                
                HStack {
                    Text("Y")
                        .font(Font.headline)
                    Spacer()
                    Text(String(gyroY))
                }.padding(5)
                
                HStack {
                    Text("Z")
                        .font(Font.headline)
                    Spacer()
                    Text(String(gyroZ))
                }.padding(5)
                
                Button (action: {
                    motionManager.gyroUpdateInterval = 0.2
                    motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                                if let myData = data {
                                    self.gyroX += myData.rotationRate.x
                                    self.gyroY += myData.rotationRate.y
                                    self.gyroZ += myData.rotationRate.z
                                }
                            }
                }){
                    Text("Start Gyroscope")
                }
            }
            
            Section (header: Text("Magnetometer")) {
                HStack {
                    Text("X")
                        .font(Font.headline)
                    Spacer()
                    Text(String(magX))
                }.padding(5)
                
                HStack {
                    Text("Y")
                        .font(Font.headline)
                    Spacer()
                    Text(String(magY))
                }.padding(5)
                
                HStack {
                    Text("Z")
                        .font(Font.headline)
                    Spacer()
                    Text(String(magZ))
                }.padding(5)
            }
            
            Button (action: {
                motionManager.magnetometerUpdateInterval = 0.2
                motionManager.startMagnetometerUpdates(to: OperationQueue.current!) { (data, error) in
                            if let myData = data {
                                self.magX += myData.magneticField.x
                                self.magY += myData.magneticField.y
                                self.magZ += myData.magneticField.z
                            }
                        }
            }){
                Text("Start Magnetometer")
            }
        
            Section (header: Text("Camera")) {
                NavigationLink(destination: CaptureImageView(isShown: true, image: "image")) {
                    Text("Show Date")
                        .fontWeight(.bold)
                }

            }
            
            Section (header: Text("Voice memo")) {
                
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        print(image.size)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> Coordinator {
      return Coordinator(isShown: $isShown, image: $image)
    }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}


class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  @Binding var isCoordinatorShown: Bool
  @Binding var imageInCoordinator: Image?
  init(isShown: Binding<Bool>, image: Binding<Image?>) {
    _isCoordinatorShown = isShown
    _imageInCoordinator = image
  }
  func imagePickerController(_ picker: UIImagePickerController,
                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
     imageInCoordinator = Image(uiImage: unwrapImage)
     isCoordinatorShown = false
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
     isCoordinatorShown = false
  }
}
