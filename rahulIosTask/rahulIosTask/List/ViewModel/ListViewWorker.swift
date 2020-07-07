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

    override init() {
       super.init()
    }

  // MARK: - Call webservice & Decode Return Result
    func getPost(result: @escaping(Result<ListResponse,RuntimeError>) -> Void){
           do {
                 WebService.shared.callJSONWebApi(.GETPOST,withHTTPMethod: .get, forPostParameters: "",tokenInHeader: false) { (response) in
                   do {
                       let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                       let jsonDecoder = JSONDecoder()
                       let responseModel = try jsonDecoder.decode(ListResponse.self, from: jsonData)
                       result(.success(responseModel))
                   } catch {
                       result(.failure(RuntimeError.init("Data not found")))
                   }
               }
           }
       }
}
