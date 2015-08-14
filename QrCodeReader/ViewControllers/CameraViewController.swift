//
//  CameraViewController.swift
//  QrCodeReader
//
//  Created by 原田 周作 on 2015/03/01.
//  Copyright (c) 2015年 Shusaku HARADA. All rights reserved.
//

import UIKit
import AVFoundation
//import QuartzCore

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    private var session: AVCaptureSession! = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var closeButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "closeCameraView:");
        self.navigationItem.rightBarButtonItem = closeButton;

        // セッションの作成.
        let mySession: AVCaptureSession! = AVCaptureSession()

        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()

        // デバイスを格納する.
        var myDevice: AVCaptureDevice!

        // バックカメラをmyDeviceに格納.
        NSLog("device check");
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                NSLog("can use back camera.");
                myDevice = device as! AVCaptureDevice
            }
        }

        // バックカメラから入力(Input)を取得.
        let myVideoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput

        if mySession.canAddInput(myVideoInput) {
            NSLog("can add input.");
            // セッションに追加.
            mySession.addInput(myVideoInput)
        }
        else {
            NSLog("can not add input.");
        }

        // 出力(Output)をMeta情報に.
        let myMetadataOutput: AVCaptureMetadataOutput! = AVCaptureMetadataOutput()

        if mySession.canAddOutput(myMetadataOutput) {
            NSLog("can add output.");
            // セッションに追加.
            mySession.addOutput(myMetadataOutput)
            // Meta情報を取得した際のDelegateを設定.
            myMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            // 判定するMeta情報にQRCodeを設定.
            myMetadataOutput.metadataObjectTypes = myMetadataOutput.availableMetadataObjectTypes;
        }
        else {
            NSLog("can not add output.");
        }

        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)

        // セッション開始.
        mySession.startRunning();
        self.session = mySession;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.closeCameraView(nil);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func closeCameraView(sender: AnyObject!) {
        if ((self.session) != nil) {
            self.session.stopRunning();
            self.session = nil;
        }
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//            NSLog("Closed camera view.");
//        });
        if ((sender) == nil) {
            return;
        }

        if (1 < self.navigationController?.viewControllers.count) {
            self.navigationController?.popViewControllerAnimated(true);
        }
        else if ((self.presentingViewController) != nil) {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                NSLog("closed view");
            });
        }
    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        NSLog("captureOutput = %@", captureOutput);

        NSLog("object = %@", metadataObjects);
        for i in 0 ..< metadataObjects.count {
            if metadataObjects[i] is AVMetadataMachineReadableCodeObject {
                let qrData: AVMetadataMachineReadableCodeObject  = metadataObjects[i] as! AVMetadataMachineReadableCodeObject;
                println("\(qrData.type)");
                println("\(qrData.stringValue)");
            }
            else if metadataObjects[i] is AVMetadataFaceObject {
                let faceObject: AVMetadataFaceObject  = metadataObjects[i] as! AVMetadataFaceObject;
                println("\(faceObject.faceID)");
//                println("\(faceObject.stringValue)");
            }
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        NSLog("touch");
    }
}
