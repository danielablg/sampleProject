//
//  HomeViewController.swift
//  KFApp
//
//  Created by Daniela Bulgaru on 06/09/2016.
//  Copyright © 2016 TheAppBusiness. All rights reserved.
//

import UIKit
import Alamofire
import JSONUtilities
import TABSwiftLayout
import SDWebImage


class HomeViewController: UIViewController {
  
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!
  
  private var products: [Product] = []
//  private lazy var scrollView: AddsScrollView = AddsScrollView.loadFromNib()
  private let searchController = UISearchController(searchResultsController: nil)


  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    registerTableViewCells()
    setupNavBar()
    setupSearchController()
    initialRequest()
  }

  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    
    searchController.searchBar.placeholder = "Search for product"
    searchController.searchBar.barTintColor = UIColor.darkGrayColor()
    searchController.searchBar.tintColor = UIColor.whiteColor()
  }
  
  private func initialRequest() {
    Alamofire.request(.GET, "http://localhost:8081/scrape?page=1&items_per_page=20", parameters: nil)
//    Alamofire.request(.GET, "http://10.5.1.86:8081/scrape?page=1&items_per_page=20", parameters: nil)

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
  
  private func anotherRequest() {
    Alamofire.request(.GET, "http://localhost:8081/scrape?page=1&items_per_page=60", parameters: nil)
//    Alamofire.request(.GET, "http://10.5.1.86:8081/scrape?page=1&items_per_page=60", parameters: nil)
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
        self.searchDisplayController?.searchResultsTableView.reloadData()
    }
  }

  private func registerTableViewCells() {
    let nib = UINib(nibName: "\(ProductTableViewCell.self)", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
   
    searchDisplayController?.searchResultsTableView.registerNib(nib, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
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

extension HomeViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let
      cell = tableView.dequeueReusableCellWithIdentifier(ProductTableViewCell.reuseIdentifier) as? ProductTableViewCell
      else {
        return UITableViewCell()
    }
    
    let product = products[indexPath.row]
    cell.imageView?.frame = CGRect(x: 16, y: 40, width: 40, height: 40)
    cell.userInteractionEnabled = false
    cell.configure(product: product)
    
    let urlString = "http:" + product.image!
    
    let theSDWebImageDownloader = SDWebImageDownloader.sharedDownloader()
    theSDWebImageDownloader.downloadImageWithURL(NSURL(string: urlString),
                                                  options: .ContinueInBackground,
                                                  progress: { (i, j) in
                                                    
      }) { (image, data, error, flag) in
        dispatch_async(dispatch_get_main_queue()) {
          let c = tableView.cellForRowAtIndexPath(indexPath) as? ProductTableViewCell
          c?.imageView?.image = image
          c?.imageView?.contentMode = .ScaleAspectFill
          c?.imageView?.frame = CGRect(x: 16, y: 40, width: 40, height: 40)
          c?.layoutIfNeeded()
        }
    }

    return cell
  }

}

extension HomeViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return AddsScrollView.loadFromNib()
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 179
  }

  func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 170
  }
}

extension HomeViewController: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    products.removeAll()
    
    if searchText == "Tool" {
      anotherRequest()
      searchDisplayController?.searchResultsTableView.reloadData()
    }
  }
}

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
//    filterContentForSearchText(searchController.searchBar.text!)
  }
}
