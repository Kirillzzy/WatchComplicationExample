//
//  ExtensionDelegate.swift
//  ComplicationApp Extension
//
//  Created by Vadim Drobinin on 18/12/16.
//  Copyright © 2016 Vadim Drobinin. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
      WatchSessionManager.sharedManager.startSession()
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func updateComplication() {
      let complicationServer = CLKComplicationServer.sharedInstance()
      guard let activeComplications = complicationServer.activeComplications else {
        return
      }
      for complication in activeComplications {
        print("UPDATE COMPLICATION")
        complicationServer.reloadTimeline(for: complication)
      }
    }
  
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                print("User Info: \(connectivityTask.userInfo)")
                updateComplication()
                WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 1 * 60 * 60), userInfo: nil, scheduledCompletion: { error in
                  if let error = error {
                    print(error.localizedDescription)
                  }
                })
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                urlSessionTask.setTaskCompleted()
            default:
                task.setTaskCompleted()
            }
        }
    }

}
