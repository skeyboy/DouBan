//
//  ViewController.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
class ViewController: UIViewController,AVAudioPlayerDelegate {
    var item:NSDictionary?
    var audio : AVAudioPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = item!.valueForKey("albumtitle") as? String
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string:item!.valueForKey("picture") as String)!), queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            if data.length > 0 {
                self.view.layer.contents = UIImage(data: data)?.CGImage
                let url = self.item!.valueForKey("url") as String
                //                var data = NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL.URLWithString(url)), returningResponse: nil, error: nil)
                //                var error:NSErrorPointer = NSErrorPointer()
                //                self.audio = AVAudioPlayer(data: data, error: nil)
                //                self.audio?.volume = 0.5
                //                self.audio?.prepareToPlay()
                //                self.audio?.play()
                //                println(error)
                AVAudioton.shareInstance().setMP3URL(url,info:self.item)
            }
        }
//        let url = self.item!.valueForKey("url") as String
//        HTTPTask().download(url, parameters: ["":""], progress: { (progress) -> Void in
//            println(progress)
//            }, success: { (response:HTTPResponse) -> Void in
//
//            }) { (error:NSError) -> Void in
//            
//        }
//        

        
    }
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        switch(event.subtype){
        case  UIEventSubtype.RemoteControlPause:
        
            break
        case  UIEventSubtype.RemoteControlPreviousTrack:
        
            break
        case  UIEventSubtype.RemoteControlNextTrack:
        
            break
        default :
            
            break
        }
    }
    override func viewWillAppear(animated: Bool) {
        hiddenNavigetionBar()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func viewDidDisappear(animated: Bool) {
        showNavigatioBar()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        autoNavigationBar()
        
    }
    func autoNavigationBar(){
        let isHidden = self.navigationController?.navigationBar.hidden
        if isHidden == true {
            showNavigatioBar()
        } else {
            hiddenNavigetionBar()
        }
        //         NSTimer(timeInterval: 6, target: self, selector: "hiddenNavigetionBar", userInfo: nil, repeats: false).fire()
    }
}

extension UIViewController{
    func hiddenNavigetionBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func showNavigatioBar(){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

