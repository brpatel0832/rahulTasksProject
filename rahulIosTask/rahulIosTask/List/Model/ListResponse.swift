//
//  ListResponse.swift
//  rahulIosTask
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import Foundation


// MARK: - Decodable Protocol

struct ListResponse: Decodable {
  let title : String?
  let rows : [ListResponsesub]
}

struct ListResponsesub: Decodable {
  let title : String?
  let description : String?
  let imageHref : String?
}
