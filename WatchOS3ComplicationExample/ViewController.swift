//
//  ViewController.swift
//  WatchOS3ComplicationExample
//
//  Created by Vadim Drobinin on 18/12/16.
//  Copyright © 2016 Vadim Drobinin. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

  var data = [String: String]()
  
  @IBAction func sendButtonPressed(_ sender: AnyObject) {
    
    // [2]
    if let transferObject = WatchSessionManager.sharedManager.transferCurrentComplicationUserInfo(userInfo: data) {
      while transferObject.isTransferring {
        print("Data is transferring...")
      }
      print("Data succesfully passed!")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    data["12:00"] = "Test 1"
    data["15:00"] = "Test 2"
  }
}
