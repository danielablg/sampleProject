//
//  ViewController.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 06/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit
import Alamofire
import JSONUtilities

class ViewController: UIViewController {
  
  private var products: [Product] = []
  private lazy var scrollView: AddsScrollView = AddsScrollView.loadFromNib()
  
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    registerTableViewCells()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavBar()
    
    tableView.tableHeaderView = scrollView
    initialRequest()
    
    
//    searchBar.dimsBackgroundDuringPresentation = false
//    searchBar.searchBar.sizeToFit()
    
  }
  
  private func initialRequest() {
    Alamofire.request(.GET, "http://localhost:8081/scrape?page=1&items_per_page=20", parameters: nil)
      .responseJSON { response in
        
        guard response.result.isSuccess else {
          print("Error while fetching products: \(response.result.error)")
          return
        }
        
        guard let productsFromResult = response.result.value as? [[String: AnyObject]] else {
          print("Malformed data received from fetchProducts service")
          return
        }
        
        var products = [Product]()
        for product in productsFromResult {
          products.append(Product(jsonData: product))
        }
        
        self.products = products
        self.tableView.reloadData()
    }
  }

  private func registerTableViewCells() {
    let nib = UINib(nibName: "\(ProductTableViewCell.self)", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
    
  }
  
  private func setupNavBar() {
    navigationController?.navigationBar.barTintColor = .orangeColor()
    navigationController?.navigationBar.tintColor = .whiteColor()
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    var image = UIImage(named: "basket")
    image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let
      cell = tableView.dequeueReusableCellWithIdentifier(ProductTableViewCell.reuseIdentifier) as? ProductTableViewCell
      else {
        return UITableViewCell()
    }
    
    cell.configure(product: products[indexPath.row])
    return cell
  }

}

extension ViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
  

}