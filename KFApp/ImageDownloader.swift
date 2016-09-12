//
//  ImageDownloader.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 06/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit

private let kAppIconSize : CGFloat = 80

class ImageDownloader : NSObject, NSURLConnectionDataDelegate {
    
  var product: Product
  var completionHandler: ((UIImage) -> Void)?
  
  private var sessionTask: NSURLSessionDataTask?
  
  init(product: Product) {
    self.product = product
    super.init()
  }
  
  //MARK: -
  //	startDownload
  func startDownload() {
    let s = "http:" + product.imageURLString!
    guard let url = NSURL(string: s) else {
      return
    }
    
    let request = NSURLRequest(URL: url)
    
      // create an session data task to obtain and download the product image
      sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
          data, response, error in

          NSOperationQueue.mainQueue().addOperationWithBlock{
              
              // Set appIcon and clear temporary data/image
              let image = UIImage(data: data!)!
              let itemSize = CGSizeMake(kAppIconSize, kAppIconSize)
              UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
              let imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height)
              image.drawInRect(imageRect)
//              self.product!.productImage = UIGraphicsGetImageFromCurrentImageContext()
              let img  = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()

              // call our completion handler to tell our client that our icon is ready for display
              self.completionHandler?(img)
          }
      }
      
      self.sessionTask?.resume()
  }
  
  // -------------------------------------------------------------------------------
  //	cancelDownload
  // -------------------------------------------------------------------------------
  func cancelDownload() {
      self.sessionTask?.cancel()
      sessionTask = nil
  }
    
}