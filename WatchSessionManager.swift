//
//  WatchSessionManager.swift
//  WatchOS3ComplicationExample
//
//  Created by Vadim Drobinin on 18/12/16.
//  Copyright © 2016 Vadim Drobinin. All rights reserved.
//

import WatchConnectivity
import WatchKit

class WatchSessionManager: NSObject, WCSessionDelegate {
  
  static let sharedManager = WatchSessionManager()
  private override init() {
    super.init()
  }
  
  private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
  
  @available(iOS 9.3, *)
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  #if os(iOS)
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  func sessionDidDeactivate(_ session: WCSession) {
  }
  #endif
  
  var validSession: WCSession? {
    #if os(iOS)
      if let session = session, session.isPaired && session.isWatchAppInstalled {
        return session
      }
    #elseif os(watchOS)
      return session
    #endif
    return nil
  }
  
  func startSession() {
    session?.delegate = self
    session?.activate()
  }
}

extension WatchSessionManager {
  func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
    if let session = validSession {
      do {
        try session.updateApplicationContext(applicationContext)
      } catch let error {
        throw error
      }
    }
  }
  
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    DispatchQueue.main.async {
      // make sure to put on the main queue to update UI!
    }
  }
}

// MARK: User Info
extension WatchSessionManager {
  
  func transferUserInfo(userInfo: [String : Any]) -> WCSessionUserInfoTransfer? {
    return validSession?.transferUserInfo(userInfo)
  }
  
  func transferCurrentComplicationUserInfo(userInfo: [String : Any]) -> WCSessionUserInfoTransfer? {
    #if os(iOS)
    return validSession?.transferCurrentComplicationUserInfo(userInfo)
    #elseif os(watchOS)
    return nil
    #endif
  }

  @objc(session:didFinishUserInfoTransfer:error:) func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
    // implement this on the sender if you need to confirm that
    // the user info did in fact transfer
  }
  
  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    // handle receiving user info
    DispatchQueue.main.async {
      print("Received: \(userInfo)")
      // Update UI from here
    }
  }
  
}

// MARK: Transfer File
extension WatchSessionManager {
  
  // Sender
  func transferFile(file: NSURL, metadata: [String : AnyObject]) -> WCSessionFileTransfer? {
    return validSession?.transferFile(file as URL, metadata: metadata)
  }
  
  @objc(session:didFinishFileTransfer:error:) func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
    // handle filed transfer completion
  }
  
  // Receiver
  @objc(session:didReceiveFile:) func session(_ session: WCSession, didReceive file: WCSessionFile) {
    // handle receiving file
    DispatchQueue.main.async {
      // make sure to put on the main queue to update UI!
    }
  }
}


// MARK: Interactive Messaging
extension WatchSessionManager {
  
  // Live messaging! App has to be reachable
  private var validReachableSession: WCSession? {
    if let session = validSession , session.isReachable {
      return session
    }
    return nil
  }
  
  // Sender
  func sendMessage(message: [String : Any],
                   replyHandler: (([String : Any]) -> Void)? = nil,
                   errorHandler: ((Error) -> Void)? = nil)
  {
    validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
  }
  
  func sendMessageData(data: Data,
                       replyHandler: ((Data) -> Void)? = nil,
                       errorHandler: ((Error) -> Void)? = nil)
  {
    validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
  }
  
  // Receiver
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    // handle receiving message
    DispatchQueue.main.async {
      // make sure to put on the main queue to update UI!
    }
  }
  
  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    // handle receiving message data
    DispatchQueue.main.async {
      // make sure to put on the main queue to update UI!
    }
  }
}
