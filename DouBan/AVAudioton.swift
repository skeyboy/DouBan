//
//  AVAudioton.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import Foundation
import AVFoundation
extension String {
    var MD5 :String{
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let digest = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<UInt8>.alloc(digest)
            CC_MD5(data!.bytes,UInt32(data!.length), result)
            var d5Str = NSMutableString()
            for i in 0 ... Int(CC_MD5_DIGEST_LENGTH) {
                d5Str.appendFormat("%02x", result[i])
            }
            result.destroy()
            return d5Str
    }
}
class AVAudioton {
    var audio:AVAudioPlayer?
    struct Audio {
        static var AVAudioton_URL = "AVAudioton_URL"
        static var audioton:AVAudioton = AVAudioton()
    }
    private init(){
        
    }
    class func shareInstance()->AVAudioton{
        return Audio.audioton
    }
    
    func setMP3URL(url:String,info:NSDictionary?){
        let fileInfo:(path:String,isCache:Bool) = self.makeCacehFromURLLastCompont(url,info: info)
        if fileInfo.isCache == false{
            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string: url)!), queue: NSOperationQueue.mainQueue(), completionHandler: { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        HTTPTask().download(url, parameters: nil, progress: { (progress:Double) -> Void in
                            
                            }, success: { (response:HTTPResponse) -> Void in

                            }, failure: { (error:NSError) -> Void in
                            
                        })
                        Audio.audioton.audio = AVAudioPlayer(data: data, error: nil)
                        Audio.audioton.audio?.prepareToPlay()
                        Audio.audioton.audio?.play()

                        if fileInfo.isCache == false {
                            dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                              let xx =  data.writeToFile(fileInfo.path, atomically: false)
                            })
                        }
                      
                    })
                })
                
            })
        } else {
        Audio.audioton.audio = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(fileInfo.path), error: nil)
            Audio.audioton.audio?.prepareToPlay()
            Audio.audioton.audio?.play()
        }
    }

    func makeCacehFromURLLastCompont(url:String, info:NSDictionary?) ->(path:String, isCache:Bool){
        println(url)
        let last = url.componentsSeparatedByString("/").last
        let manger = NSFileManager.defaultManager()
        if !manger.fileExistsAtPath(MP3Home) {
            manger.createDirectoryAtPath(MP3Home, withIntermediateDirectories: true, attributes: nil, error: nil)
            manger.createDirectoryAtPath(MP3InfoHome, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        let path = MP3Home.stringByAppendingFormat("/\(last!)")
        let infoPath = MP3InfoHome.stringByAppendingFormat("/\(last!).txt")
        println(path)
        if manger.fileExistsAtPath(path) {
            let attribute = manger.attributesOfItemAtPath(path, error: nil)
            println(attribute)
            return (path,true)
        } else {
            manger.createFileAtPath(path, contents: nil, attributes: info)
            info?.writeToFile(infoPath, atomically: false)
            return (path, false)
        }
    }
}
