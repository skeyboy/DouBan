//
//  UIImageView+extension.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import Foundation
import UIKit

protocol imageCacheProtocol{
    func checkImageIsExistBy(#url:String)->(String,Bool)
    func cacheTheImageData(data:NSData,url:String)
}

extension String{
    func convertoPath(exten:String?) -> String{
        var path = NSHomeDirectory().stringByAppendingPathComponent("Documents/imgs/")
        let manger = NSFileManager.defaultManager()

        if !manger.fileExistsAtPath(path) {
        manger.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        path =   path.stringByAppendingPathComponent(self)
        if exten != nil {
            path =   path.stringByAppendingPathExtension(exten!)!
        }
        return path
    }
    func isExisAtPath()->Bool {
        let manger = NSFileManager.defaultManager()
        return manger.fileExistsAtPath( self.convertoPath(nil) )
    }
}
extension UIImageView: imageCacheProtocol,NSURLSessionDownloadDelegate{
    
//    var progress:((totoalBytes:Int64,excepBytes:Int64)->Void)?
    func checkImageIsExistBy(#url:String)->(String,Bool){
        return (url.convertoPath(nil),url.isExisAtPath())
    }
    func cacheTheImageData(data:NSData,url:String){
        data.writeToFile(url.convertoPath(nil), atomically: false)
    }
    func setImageWith(#url:String){
        
        let (path:String, isExist:Bool) = checkImageIsExistBy(url: url)
        var inetURL:NSURL?
        if isExist {
            inetURL = NSURL.fileURLWithPath(path)
        } else {
            inetURL = NSURL(string: url)
        }
        
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: inetURL!), queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            var image:UIImage? = UIImage(data: data)
            if image != nil {
                self.image = image
                if !isExist {
                    self.cacheTheImageData(data, url: url.lastPathComponent)
                }
            }
        }
    }
    func setImageWith(#url:String, holder:UIImage?,_ progress:(didWriteBytes:Int64,totoalBytes:Int64)->Void){
        self.image = holder
        let config = NSURLSessionConfiguration.backgroundSessionConfiguration(url)
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithRequest(NSURLRequest(URL: NSURL(string: url)!))
        let activity = Activity()
        activity.progress = progress
        ImageViewProgress.map.setValue(activity, forKey: session.configuration.identifier)
        task.resume()
    }
  public  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
    
    }
    public func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        println("XXXX \(session.configuration.identifier) \(downloadTask.taskIdentifier)  \(totalBytesWritten)   \(totalBytesExpectedToWrite)")
 let activ = ImageViewProgress.map.valueForKeyPath(session.configuration.identifier) as Activity
        activ.progress!(didWriteBytes: bytesWritten, totoalBytes: totalBytesWritten)
    }
    struct ImageViewProgress {
        static var progress:((didWriteBytes:Int64,totoalBytes:Int64)->Void)?
        static var map:NSMutableDictionary = NSMutableDictionary()
    }
    class Activity {
        var progress:((didWriteBytes:Int64,totoalBytes:Int64)->Void)?
    }
}