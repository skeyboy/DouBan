//
//  DouBanHomeViewController.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import UIKit
class DouBanHomeViewController: UITableViewController {
    @IBOutlet weak var albumImage: UIImageView!
    var list:NSMutableArray?
    var dict:NSDictionary?
    var current = 0
    var channelID:String? = 1.description
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DouBan"
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleRightMargin
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.albumImage.layer.backgroundColor = UIColor.clearColor().CGColor
        self.albumImage.layer.cornerRadius = 20.0
        self.albumImage.layer.borderColor = UIColor.magentaColor().CGColor
        
        // self.albumImage.setImageWith(url: "http://img5.douban.com/lpic/s6988988.jpg")
        //        self.albumImage.setImageWith(url: "http://img5.douban.com/lpic/s6988988.jpg", holder: nil)
        getPlayListBy(channel: "1")
    }
    
    func getPlayListBy(#channel:String){
        channelID = channel
        HTTPTask().GET("http://douban.fm/j/mine/playlist", parameters: ["channel":channel], success: { (response:HTTPResponse) -> Void in
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("response: \(json)") //prints the HTML of the page
                self.dict = json as? NSDictionary
                if self.list != nil {
                    self.list?.removeAllObjects()
                }
                self.list = NSMutableArray(array: self.dict!.valueForKey("song") as NSArray )
                
                self.randonGetOne()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
                
            }
            }) { (error:NSError) -> Void in
                println(error)
                let path = MP3InfoHome
                println(path)
                let manger = NSFileManager.defaultManager()
                let objs:NSArray =    manger.subpathsAtPath(path)!
                println(objs)
                self.list = NSMutableArray()
                for item in objs  {
                    if item is String {
                        let name = item as String
                        if name.pathExtension == "txt" {
                            let dict = NSDictionary(contentsOfFile: "\(path)/\(name)")
                            self.list?.addObject(dict!)
                        }
                    }
                }
                self.randonGetOne()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
        }
        
    }
    func randonGetOne(){
        if list!.count > 0 {
            let rand = random() % self.list!.count
            let item = self.list?.objectAtIndex( rand ) as NSDictionary
            self.albumImage.setImageWith(url: item.valueForKey("picture") as String)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.list != nil{
            return self.list!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("doubanhome") as DouBanHomeCell
        let item:NSDictionary = self.list?.objectAtIndex(indexPath.row) as NSDictionary
        cell.artist.text = item.valueForKey("artist") as? String
        cell.picture.setImageWith(url: item.valueForKey("picture") as String )
        cell.picture.setImageWith(url: item.valueForKey("picture") as String , holder: nil) { (didWriteBytes, totoalBytes) -> Void in
            println("test  \(didWriteBytes) \(totoalBytes)")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.list?.objectAtIndex(indexPath.row) as NSDictionary
        self.albumImage.setImageWith(url: item.valueForKey("picture") as String)
        self.performSegueWithIdentifier("goto_player", sender: item)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goto_channels"{
            let doubanchannel:DouBanChannelsViewController = segue.destinationViewController as DouBanChannelsViewController
            doubanchannel.doubanHome = self
            return
        }
        let controller:ViewController = segue.destinationViewController as ViewController
        controller.item = sender as? NSDictionary
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        var cell:DouBanHomeCell? = tableView.cellForRowAtIndexPath(indexPath) as? DouBanHomeCell
        //        if cell != nil {
        //        cell?.frame.height
        //        }
        return 70
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        switch event.subtype {
        case UIEventSubtype.RemoteControlStop:
            self.tableView(self.tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: current++ % self.list!.count, inSection: 0))
            break
        case UIEventSubtype.RemoteControlNextTrack:
            
            break
            
        case UIEventSubtype.RemoteControlPlay:
            
            break
            
        default :
            
            break
            
            
        }
    }
    
    @IBAction func randomList(sender: AnyObject) {
        getPlayListBy(channel: channelID!)
    }
    @IBAction func choseMyChannels(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_channels", sender: nil)
    }
    @IBOutlet weak var choseMyChannels: UINavigationItem!
}
