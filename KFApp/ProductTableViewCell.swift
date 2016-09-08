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
  
  @IBOutlet weak var productImage: UIImageView!
  
  @IBOutlet private var productPrice: UILabel!
  @IBOutlet private var productTitle: UILabel!
  @IBOutlet private var productCollection: UILabel!
  @IBOutlet private var productHomeDelivery: UILabel!
  
  
  func configure() {
    backgroundColor = .redColor()
  }
}
