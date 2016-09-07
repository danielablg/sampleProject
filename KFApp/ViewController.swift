//
//  ViewController.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 06/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit
import TABSwiftLayout

class ViewController: UIViewController,UIScrollViewDelegate {
  
  let adds: [UIImage?] = [UIImage(named: "11"), UIImage(named: "22"), UIImage(named: "33")]
  
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var scrollView: UIScrollView!
  
  var frame: CGRect = CGRectZero

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    for index in 0..<adds.count {
      
      frame.origin.x = scrollView.frame.size.width * CGFloat(index)
      frame.size = scrollView.frame.size
      
      let subView = UIImageView(frame: frame)
      subView.contentMode = .ScaleAspectFit
      subView.image = adds[index]
      
      scrollView.addSubview(subView)
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(adds.count), scrollView.frame.size.height)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.backgroundColor = .orangeColor()

    configurePageControl()
    scrollView.delegate = self
    scrollView.backgroundColor = .whiteColor()
    
    pageControl.addTarget(self, action: #selector(changePage), forControlEvents: UIControlEvents.ValueChanged)
  }
  
  func configurePageControl() {
    pageControl.numberOfPages = adds.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGrayColor()
    pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
  }
  
  func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
}