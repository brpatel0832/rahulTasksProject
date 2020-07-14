//
//  APIManagerClass.swift
//  Keyword Market
//
//  Created by Admin on 22/11/17.
//  Copyright © 2017 Postgram Pte Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class APIManagerClass: NSObject {
    
    static let sharedManagerClass = APIManagerClass()
    static var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    // MARK: - Alamofire api calling method

    func hitAPIWithURL(apiURL: String,methodType:HTTPMethod, dictionaryParameters: NSMutableDictionary?,isNew: Bool,isShowProgress:Bool,viewCurrent: UIView?, completionHandlerSuccess: @escaping (_ responseInJSON: Any) -> Void, completionHandlerFailure: @escaping (_ error: Error?) -> Void ) {
        if Utility_Swift.isInternetConnected(isShowPopup: true) {
            
            
            if isShowProgress && viewCurrent != nil{
                if (APIManagerClass.activityIndicator.isAnimating == false || APIManagerClass.activityIndicator.isHidden == true) {
                    viewCurrent?.addSubview(APIManagerClass.activityIndicator)
                    APIManagerClass.activityIndicator.center = CGPoint.init(x: (viewCurrent?.bounds.width)!/2, y: (viewCurrent?.bounds.height)!/2)
                    APIManagerClass.activityIndicator.hidesWhenStopped = true
                    APIManagerClass.activityIndicator.color = UIColor.black
                    APIManagerClass.activityIndicator.isHidden = false
                    APIManagerClass.activityIndicator.startAnimating()
                    viewCurrent?.isUserInteractionEnabled = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            }else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }

            print("url = \(apiURL)")

          var request: URLRequest!
          request = URLRequest(url: URL(string: "\(apiURL)")!)
          request.httpMethod = methodType.rawValue
          request.addValue("uc_session=sNKLoyrHK8PEvx9tJ0bIhyOWyzBe2sfVpTdfdGF2GfUP2MnYlKZ7XSWSTzxMs51H", forHTTPHeaderField: "Cookie")

            switch methodType {

            case .get:
                Alamofire.request(request).responseJSON { response in
                  if let data = response.data{
                    let jsonData = String(decoding: data, as: UTF8.self)
                    if let status = response.response?.statusCode {

                       switch(status){

                       case 200:
                        let jsondata = Data(jsonData.utf8)
                        let jsonDic = self.convertToDictionary(text: jsondata)
                        let populatedDictionary = ["statusCode": response.response!.statusCode,"message":jsonDic as Any] as [String : Any] 
                           completionHandlerSuccess(populatedDictionary)


                       case 201:


                        let populatedDictionary = ["statusCode": response.response!.statusCode,"message":""] as [String : Any]
                           completionHandlerSuccess(populatedDictionary)

                       case 404 , 400, 411:

                           let populatedDictionary = ["statusCode": response.response!.statusCode,"message":""] as [String : Any]
                           completionHandlerSuccess(populatedDictionary)

                       default:
                           completionHandlerFailure(response.value as? Error)
                       }
                   }
                   else{
                       completionHandlerFailure(response.error)
                   }
                  }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    viewCurrent?.isUserInteractionEnabled = true
                    APIManagerClass.activityIndicator.stopAnimating()
                }
            case  .post :
                print("Post")
            case .put:
                print("In Put")
            case .delete:
                print("In Delete")
            default:
                print("In Default")
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
    
    
    func stopAllSessions() {
        
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) in
            tasks.forEach({
              print($0.currentRequest?.url as Any)
                $0.cancel()
            })
        }
    }


}
