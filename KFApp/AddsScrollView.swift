//
//  AddsScrollView.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 08/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit

final class AddsScrollView: UIView {
  
  private let addImages: [UIImage?] = [UIImage(named: "11"), UIImage(named: "22"), UIImage(named: "33")]
  
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var dotsBackground: UIView! {
    didSet {
      dotsBackground.layer.cornerRadius = 5
      dotsBackground.alpha = 0.4
      dotsBackground.backgroundColor = .blackColor()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
    scrollView.delegate = self
    
    for index in 0..<addImages.count {
      
      frame.origin.x = frame.size.width * CGFloat(index)
      frame.size = frame.size
      
      let subView = UIImageView(frame: frame)
      subView.contentMode = .ScaleAspectFit
      subView.image = addImages[index]
      
      scrollView.addSubview(subView)
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(addImages.count), scrollView.frame.size.height)
    configurePageControl()
    layoutIfNeeded()
  }
  
  private func configurePageControl() {
    pageControl.numberOfPages = addImages.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGrayColor()
    pageControl.currentPageIndicatorTintColor = .whiteColor()
    
    pageControl.addTarget(self, action: #selector(changePage), forControlEvents: UIControlEvents.ValueChanged)
  }

  @objc private func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * frame.size.width
    scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
  }
}

extension AddsScrollView: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
}
