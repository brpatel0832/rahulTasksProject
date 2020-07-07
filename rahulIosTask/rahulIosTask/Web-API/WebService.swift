//
//  WebService.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import SVProgressHUD
import Alamofire


enum HTTPMethod : String {
    case post = "POST"
    case get = "GET"
}

enum API: String
{
    case GETPOST = ""
}


struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

typealias actionWithServiceResponse = ((_ serviceResponse: [String:Any])-> Void)
typealias Completion = (NSData?) ->Void


class WebService: NSObject {
    static let shared = WebService()
    var window: UIWindow?
    var elementValue: String?
    var success = false

    //Base URL for WebAPI(s)
    private let baseurl = BASEURL //Live
     private let MasterUrl = ""

    private let userInteractiveGlobalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    //GCD initialize Global User Initiated Queue
    private let userInitiatedGlobalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)

    //Instance of URLSession to interact with WebAPI(s)
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)

    //activity indicator while waiting for Web Api response and to stop user interaction

    fileprivate var progressHUD: SVProgressHUD!

    public func callJSONWebApi(_ api: API,withHTTPMethod method: HTTPMethod, forPostParameters parameters: String,tokenInHeader:Bool = false,masterData:Bool = false,appendStringInUrl:String = "",actionAfterServiceResponse completionHandler: @escaping actionWithServiceResponse)
    {
        var request: URLRequest!
        if method == .post {

            request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)

            if parameters != "" {
                let jsonData = parameters.data(using: .utf8, allowLossyConversion: false)!
                request.httpBody = jsonData
            }
        }
        else {
             if appendStringInUrl != "" {
                request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)/\(appendStringInUrl)")!)
             }else{
              request = URLRequest(url: URL(string: "\(self.baseurl)\(api.rawValue)")!)
            }
        }

        if tokenInHeader{

        }

        print(request.url!)
        request.httpMethod = method.rawValue
        request.addValue("uc_session=sNKLoyrHK8PEvx9tJ0bIhyOWyzBe2sfVpTdfdGF2GfUP2MnYlKZ7XSWSTzxMs51H", forHTTPHeaderField: "Cookie")

        guard checkForNetworkConnectivity() else {
              return
        }

        self.showHUD()


      // MARK: - Json request
        Alamofire.request(request).responseJSON
            { response in
                  self.hideHUD()
                 //UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let data = response.data
                {
                    let json = String(decoding: data, as: UTF8.self)
                    //let json = String(data: data, encoding: String.Encoding.utf8)
                    //print("Response: \(String(describing: json))")
                    if let httpResponse = response.response?.statusCode
                    {
                        if httpResponse == 200 || httpResponse == 202 {

                            if httpResponse == 200
                            {
                              let jsondata = Data(json.utf8)
                                let jsonDic = self.convertToDictionary(text: jsondata)
                                 completionHandler(jsonDic!)
                            }
                            else
                            {
                                if let errorMessageString =  response.result.error as? String
                                {
                                    self.showErrorWithHud(errorMessage: errorMessageString)
                                }
                                else{
                                    self.showErrorWithHud(errorMessage: "Data not in correct format")
                                }
                             }
                         }
                        else if httpResponse == 405
                        {
                            if let errorMessageString =  response.result.error as? String
                            {
                                self.showErrorWithHud(errorMessage: errorMessageString)
                            }
                            else{
                                self.showErrorWithHud(errorMessage: "Data not in correct format")
                            }
                        }
                    }
                }
        }
    }

}

extension WebService  {

    // possible states for internet access
    private enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }

    private var currentReachabilityStatus: ReachabilityStatus {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }

        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }

    // MARK: - check for internet access
    public func checkForNetworkConnectivity() -> Bool {
        guard self.currentReachabilityStatus != .notReachable else {
             self.showErrorWithHud(errorMessage: "Internet not available")
             return false
        }
        return true
    }

  // MARK: - Progressbar

     func showHUD() {
             if !SVProgressHUD.isVisible() {
                SVProgressHUD.setDefaultMaskType(.gradient)
                SVProgressHUD.show(withStatus: "Loading Data")
            }
     }

    func showErrorWithHud(errorMessage:String){
        DispatchQueue.main.async {
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
    }


    fileprivate func showHUDWithPercentage(progressFile : Float) {
        DispatchQueue.main.async {
            if !SVProgressHUD.isVisible() {
                SVProgressHUD.showProgress(progressFile)
            }
        }
    }

     func hideHUD() {
        DispatchQueue.main.async {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        }
    }




// MARK: - Serializ result
    func convertToDictionary(text: Data) -> [String: Any]? {
        do {
                let json = try! JSONSerialization.jsonObject(with: text)
                if let jsonArray = json as? [String:Any] {
                   return jsonArray
                } else {
                   let jsonDictionary = json as! [String:Any]
                   var dataDict = [[String: Any]]()
                   dataDict.append(jsonDictionary)
                   return jsonDictionary
                }
           }
    }

}



