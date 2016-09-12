//
//  ProductCollectionViewCell.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 07/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {
  
  static let reuseIdentifier = "ProductTableViewCell"
  
  @IBOutlet private var productPrice: UILabel!
  @IBOutlet private var productTitle: UILabel!
  @IBOutlet private var productCollection: UILabel!
  @IBOutlet private var productHomeDelivery: UILabel!
  @IBOutlet private var productInStore: UILabel!
  
  func configure(product product: Product) {
    productPrice.text = product.price
    productTitle.text = product.name
    productCollection.text = product.availableForCollection
    productHomeDelivery.text = product.homeDelivery
  }
}
