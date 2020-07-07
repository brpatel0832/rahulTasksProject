//
//  ListViewModel.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import Foundation


class ListViewModel {

  // MARK: - Let to Var

   static let shared = ListViewModel()
   var postInformation = [ListResponsesub]()
   var titleInformation = String()

  // MARK: - Call Api & Model Create
   func getPostInformation(responseResult: @escaping(Result<Bool,RuntimeError>) -> Void){
       ListViewWorker().getPost { (result) in
           switch result {
           case .success(let model):
            self.titleInformation = model.title ?? "Title"
            self.postInformation = model.rows
               responseResult(.success(true))
           case .failure(let error):
               print(error)
               responseResult(.failure(error))
               break
           }
       }
   }
}
