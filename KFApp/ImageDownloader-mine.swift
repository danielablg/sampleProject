//
//  ImageDownloader.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 11/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit

final class ImageDownloader: NSObject {
  
  func startDownload() {
    guard let url = NSURL(string: "") else {
      return
    }
    let request = NSURLRequest(URL: url)
    
    
    // create an session data task to obtain and download the app icon
    
    let sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
    let compleationHandler: () -> ()
    
    compleationHandler(data: NSData, response: NSURLRespose, error: NSError) {
      
    }
    
  }
  
  
  // -------------------------------------------------------------------------------

  
//  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//  
//  // in case we want to know the response status code
//  //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
//  
//  if (error != nil)
//  {
//  if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
//  {
//  // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
//  // then your Info.plist has not been properly configured to match the target server.
//  //
//  abort();
//  }
//  }
//  
//  [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
//  
//  // Set appIcon and clear temporary data/image
//  UIImage *image = [[UIImage alloc] initWithData:data];
//  
//  if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
//  {
//  CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
//  UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
//  CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//  [image drawInRect:imageRect];
//  self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
//  }
//  else
//  {
//  self.appRecord.appIcon = image;
//  }
//  
//  // call our completion handler to tell our client that our icon is ready for display
//  if (self.completionHandler != nil)
//  {
//  self.completionHandler();
//  }
//  }];
//  }];
//  
//  [self.sessionTask resume];
//  }
  
  func cancelDownload() {
    
  }

}
