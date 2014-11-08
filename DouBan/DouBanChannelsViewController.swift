//
//  DouBanChannelsViewController.swift
//  DouBan
//
//  Created by Mave on 14/10/23.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import UIKit

class DouBanChannelsViewController: UITableViewController {
    var channels:NSMutableArray?
    var doubanHome:DouBanHomeViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if  UIDevice.currentDevice().systemVersion.toInt() >= 7 {
            self.edgesForExtendedLayout = UIRectEdge.None
            self.automaticallyAdjustsScrollViewInsets = false
        }
        var task:HTTPTask = HTTPTask()
        task.responseSerializer = JSONResponseSerializer()
        task.GET(DouBan_Channels, parameters: nil, success: { (result:HTTPResponse) -> Void in
            
            println(result.responseObject)
            let channels = (result.responseObject as NSDictionary).valueForKey("channels") as NSArray
            self.channels = NSMutableArray(array: channels)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            self.channels!.writeToFile("\(ChannelHome)channels.txt", atomically: false)
            })
            }) { (error:NSError) -> Void in
                self.channels = NSMutableArray(contentsOfURL: NSURL.fileURLWithPath("\(ChannelHome)channels.txt")!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })

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
        
        if self.channels != nil{
            return self.channels!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifer = "doubanchannlescell"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifer) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifer)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let item:NSDictionary = channels?.objectAtIndex(indexPath.row) as NSDictionary
        cell?.textLabel.text = item.valueForKey("name") as? String
        cell?.detailTextLabel?.text = item.valueForKey("seq_id") as? String
        
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item:NSDictionary = channels?.objectAtIndex(indexPath.row) as NSDictionary
        let channel: AnyObject? = item.valueForKey("channel_id")
        doubanHome!.getPlayListBy(channel: channel!.description)
        doubanHome?.title = item.valueForKey("name") as? String
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}
