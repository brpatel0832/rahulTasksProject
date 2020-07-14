//
//  Utility_Swift.swift
//  Keyword Market
//
//  Created by Admin on 22/11/17.
//  Copyright © 2017 Postgram Pte Ltd. All rights reserved.
//

import UIKit
import SystemConfiguration


class Utility_Swift: NSObject {



  //MARK:- Implementation to check Internet connectivity
  class func isInternetConnected(isShowPopup: Bool) -> Bool {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)

      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
          $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
              SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
          }
      }
      var flags = SCNetworkReachabilityFlags()
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
          if (isShowPopup) {
              showAlertController(stringTitle: "", stringMessage: "Please check your internet connection")
          }
          return false
      }
      let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
      let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0

      if (isReachable && !needsConnection) == false{
          if (isShowPopup) {
              showAlertController(stringTitle: "", stringMessage: "Please check your internet connection")
          }
      }
      return (isReachable && !needsConnection)
  }



  class func showAlertController(stringTitle: String, stringMessage: String) {
      var topController = UIApplication.shared.keyWindow?.rootViewController! as! UIViewController
      while ((topController.presentedViewController) != nil){
          topController = topController.presentedViewController!;
      }
      let alertController = UIAlertController(title: stringTitle, message: stringMessage, preferredStyle: UIAlertController.Style.alert)

      let alertActionOk: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
          //Just dismiss the action sheet
          print("OK")
      }
      alertController.addAction(alertActionOk)
      topController.present(alertController, animated:true, completion:nil)
  }
  
    // MARK: -
    
    class func showAlertControllerWithOKButtonActionCompletionHandler(_ stringTitle: String, _ stringMessage: String, completionHandlerForOKButtonAction: @escaping (_ stringOKCancel: String) -> Void) {
        
        var topController = UIApplication.shared.keyWindow!.rootViewController! as UIViewController
        while ((topController.presentedViewController) != nil){
            topController = topController.presentedViewController!;
        }
        let alertController = UIAlertController(title: stringTitle, message: stringMessage, preferredStyle: UIAlertController.Style.alert)
        
        let alertActionOk: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            //Just dismiss the action sheet
            print("OK")
            completionHandlerForOKButtonAction("OK")
        }
        alertController.addAction(alertActionOk)
        topController.present(alertController, animated:true, completion:nil)
    }

}
