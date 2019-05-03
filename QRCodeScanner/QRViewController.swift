//
//  QRViewController.swift
//  QRCodeScanner
//
//  Created by Alan on 4/30/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import AVFoundation

class QRViewController: UIViewController, DisplayQRcodeResultPro{
    func displayQRCodeResult(_ Text: String) {
        
    }
    
    
    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var jumpBtn: UIButton!
    var HideContainerView: Bool = true
    
    weak var ResultDelegate : DisplayQRcodeResultPro?
    
    @IBAction func buttonPressed(_ sender: Any) {
            ResultDelegate?.displayQRCodeResult("555")
        print("activated")
        if (HideContainerView == true) {
            UIView.animate(withDuration: 1.0) {
                self.ContainerView.transform = CGAffineTransform(translationX: 0, y: -175)
            }
            
            
            
            HideContainerView = false
        } else {
            UIView.animate(withDuration: 1.0) {
                self.ContainerView.transform = CGAffineTransform(translationX: 0, y: 175)
            }
            HideContainerView = true
        }
        
        
    }
    
    @IBOutlet weak var BaseView: UIView!
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    @IBOutlet weak var DetectLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        CreateScannerFrame(View: view)
        let overlay = createOverlay(frame: view.frame, xOffset: 20, yOffset:20, radius: 20)
//        view.addSubview(overlay)
        
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
            
        }
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        
        captureSession.startRunning()
//        view.bringSubviewToFront(overlay)
        
        view.bringSubviewToFront(DetectLabel)
        
    }
    

    

}



func createOverlay(frame: CGRect,
                   xOffset: CGFloat,
                   yOffset: CGFloat,
                   radius: CGFloat) -> UIView {
    // Step 1
    let overlayView = UIView(frame: frame)
    overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    // Step 2
    let path = CGMutablePath()
//    path.addArc(center: CGPoint(x: xOffset, y: yOffset),
//                radius: radius,
//                startAngle: 0.0,
//                endAngle: 2.0 * .pi,
//                clockwise: false)
    let rect = CGRect(x: 50, y: 50, width: 200, height: 200)
    let size = CGSize(width: frame.maxX / 2, height: frame.maxX / 2)
    let point = CGPoint(x: frame.maxX / 2 - frame.maxX / 4, y: frame.maxY / 2 - frame.maxX / 4)
    let newRect = CGRect(origin: point, size: size)
    
//    path.addRect(rect)
    path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
    path.addRect(newRect)
    // Step 3
    let maskLayer = CAShapeLayer()
    maskLayer.path = path
//    maskLayer.backgroundColor = UIColor.black.cgColor
    
    // Add border
    let borderLayerPath = CGMutablePath()
    borderLayerPath.addRect(newRect)
    let borderLayer = CAShapeLayer()
    borderLayer.path = borderLayerPath // Reuse the Bezier path
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = UIColor.green.cgColor
    borderLayer.lineWidth = 5

    
    // For Swift 4.0
    maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    // Step 4
    overlayView.layer.mask = maskLayer
    
    overlayView.clipsToBounds = true
    overlayView.layer.addSublayer(borderLayer)
    return overlayView
}

extension QRViewController: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            DetectLabel.text = "No QR code is detected"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        let tap = UITapGestureRecognizer(target: self, action: #selector(QRViewController.tapFunction))
        DetectLabel.isUserInteractionEnabled = true
        DetectLabel.addGestureRecognizer(tap)
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            view.bringSubviewToFront(qrCodeFrameView!)
            
            if metadataObj.stringValue != nil {
                DetectLabel.text = metadataObj.stringValue
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContainerViewSegue") {
            let vc = segue.destination as! ContainerViewController
            vc.ResultLabel?.text = "555"
            print(vc.ResultLabel?.text)
        }
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        self.tabBarController?.selectedIndex = 2
        print("tap working")
    }
    
}


