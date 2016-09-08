//
//  Product.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 08/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import Foundation

struct Product {
  var name: String?
  var price: String?
  var homeDelivery: String?
  var inStore: String?
  var availableForCollection: String?
  var image: String?
}

extension Product {
  
  init(jsonData: [String: AnyObject]) {
    name = jsonData.jsonKey("title")
    price = jsonData.jsonKey("price")
    homeDelivery = jsonData.jsonKey("home_deliver")
    inStore = jsonData.jsonKey("in_store")
    availableForCollection = jsonData.jsonKey("click_and_collect")
    image = jsonData.jsonKey("img")
  }
}