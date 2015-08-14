//
//  ViewController.swift
//  QrCodeReader
//
//  Created by 原田 周作 on 2015/03/01.
//  Copyright (c) 2015年 Shusaku HARADA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var modalView: UINavigationController! = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var notification: NSNotificationCenter = NSNotificationCenter.defaultCenter();
        notification.addObserver(self, selector: "closeCameraView:", name: "CloseCameraViewNotification", object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showCameraView(sender: AnyObject!) {
        var vc: CameraViewController = CameraViewController();
        self.modalView = UINavigationController(rootViewController: vc);
        self.presentViewController(self.modalView, animated: true) { () -> Void in
            NSLog("showed camera view");
            NSLog("presentedViewController = %@", self.presentedViewController!);
            if self.presentingViewController != nil {
                NSLog("presentingViewController = %@", self.presentingViewController!);
            }
        }
//        if self.navigationController != nil {
//            self.navigationController?.pushViewController(vc, animated: true);
//        }
    }
    
    func closeCameraView(notification: NSNotification!) {
        if self.modalView == nil {
            return;
        }

        self.modalView.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSLog("Closed camera view");
        });
    }

}

