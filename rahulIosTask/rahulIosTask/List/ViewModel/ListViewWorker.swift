//
//  ListViewWorker.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import Foundation
import UIKit

class ListViewWorker: NSObject {

  // MARK: - ViewModel for call api and response model

  func getPost(onSuccess: @escaping(ListResponse) -> Void, onFail: @escaping(Error?) -> Void, currentView : UIView)
  {
      do {

          APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: BASEURL,  methodType: .get, dictionaryParameters: nil, isNew: false , isShowProgress: true, viewCurrent: currentView, completionHandlerSuccess: { (responseInJSON) in

            if let tempResponseDict = responseInJSON as? [String:Any],let message = tempResponseDict["message"] as? [String:Any]{
              do {
                    let jsonData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(ListResponse.self, from: jsonData)
                    onSuccess(responseModel)
                } catch {
                  onFail(error)
                }
            }
          }, completionHandlerFailure: { (error) in
              onFail(error)
          })
      }
  }
}
