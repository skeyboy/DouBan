//
//  DouBanConstant.swift
//  DouBan
//
//  Created by Mave on 14/10/22.
//  Copyright (c) 2014年 com.gener-tech. All rights reserved.
//

import Foundation

let DouBan_Channels = "http://www.douban.com/j/app/radio/channels"
//http://douban.fm/j/mine/playlist?channel=22

let DouBan_Play_List_Base = "http://douban.fm/j/mine/playlist"

let MP3Home = NSHomeDirectory().stringByAppendingFormat("/Documents/mp3")
let MP3InfoHome = NSHomeDirectory().stringByAppendingFormat("/Documents/mp3Info")

let ChannelHome = NSHomeDirectory().stringByAppendingFormat("/Documents/")
typealias Progress = (didWriteBytes:Int64,totoalBytes:Int64)->Void
