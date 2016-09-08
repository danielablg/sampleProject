//
//  ViewController.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 06/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit
//import Alamofire

class ViewController: UIViewController {
  
  let addImages: [UIImage?] = [UIImage(named: "11"), UIImage(named: "22"), UIImage(named: "33"),
                               UIImage(named: "11"), UIImage(named: "22")]
  
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var tableView: UITableView!
  
  var frame: CGRect = CGRectZero
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    registerTableViewCells()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.backgroundColor = .whiteColor()
    
    for index in 0..<addImages.count {
      
      frame.origin.x = scrollView.frame.size.width * CGFloat(index)
      frame.size = scrollView.frame.size
      
      let subView = UIImageView(frame: frame)
      subView.contentMode = .ScaleAspectFit
      subView.image = addImages[index]
      
      scrollView.addSubview(subView)
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(addImages.count), scrollView.frame.size.height)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.backgroundColor = .orangeColor()

    configurePageControl()
    scrollView.delegate = self
    scrollView.backgroundColor = .whiteColor()
    
    pageControl.addTarget(self, action: #selector(changePage), forControlEvents: UIControlEvents.ValueChanged)
  }
  
  private func configurePageControl() {
    pageControl.numberOfPages = addImages.count
    pageControl.currentPage = 0
    pageControl.pageIndicatorTintColor = .lightGrayColor()
    pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
  }
  
  @objc private func changePage(sender: AnyObject) -> () {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
  }
  
  private func registerTableViewCells() {
    let nib = UINib(nibName: "\(ProductTableViewCell.self)", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
  }
}

extension ViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let
      cell = tableView.dequeueReusableCellWithIdentifier(ProductTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ProductTableViewCell
      else {
        return UITableViewCell()
    }
    return cell

  }
}