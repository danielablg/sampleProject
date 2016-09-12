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
  
  @IBOutlet private var tableView: UITableView!
  let PlaceHolderCellIdentifier = "PlaceholderCell"

  private var products: [Product] = []
  private let searchController = UISearchController(searchResultsController: nil)
  
  // the set of IconDownloader objects for each app
  private var imageDownloadsInProgress: [NSIndexPath: ImageDownloader] = [:]
  
  private func terminateAllDownloads() {
    // terminate all pending download connections
    let allDownloads = self.imageDownloadsInProgress.values
    for download in allDownloads {download.cancelDownload()}
    
    self.imageDownloadsInProgress.removeAll(keepCapacity: false)
  }
  
  // -------------------------------------------------------------------------------
  deinit {
    // terminate all pending download connections
    self.terminateAllDownloads()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    // terminate all pending download connections
    self.terminateAllDownloads()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    registerTableViewCells()
    setupNavBar()
    setupSearchController()
//    initialRequest()s
    
    self.imageDownloadsInProgress = [:]

    
    goodRequest()
  }

  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    
    searchController.searchBar.placeholder = "Search for product"
    searchController.searchBar.barTintColor = UIColor.darkGrayColor()
    searchController.searchBar.tintColor = UIColor.whiteColor()
    searchController.searchBar.translucent = false
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
        self.tableView.reloadData()
    }
  }
  
  func handleError(error: NSError) {
    let errorMessage = error.localizedDescription
    
    let alert = UIAlertController(title: "Cannot Show Products",
                                  message: errorMessage,
                                  preferredStyle: .ActionSheet)
    let OKAction = UIAlertAction(title: "OK", style: .Default) {action in
      // dissmissal of alert completed
    }
    
    alert.addAction(OKAction)
    
    presentViewController(alert, animated: true, completion: nil)

  }
  
  private func goodRequest() {
    let request = NSURLRequest(URL: NSURL(string: "http://localhost:8081/scrape?page=1&items_per_page=7")!)
    
    // create a session data task to obtain and the feed
    let sessionTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
      data, response, error in
      
      if let actualError = error {
        NSOperationQueue.mainQueue().addOperationWithBlock {
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          self.handleError(actualError)
        }
      } else {
        // create the queue to run our ParseOperation
        let  jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSArray
        
        var products = [Product]()
        for product in jsonDictionary! {
          products.append(Product(jsonData: product as! [String : AnyObject]))
        }
        
        
        dispatch_async(dispatch_get_main_queue()) {
          self.products.appendContentsOf(products)

          self.tableView.reloadData()
        }
      }
    }
    
    sessionTask.resume()
    
    // show in the status bar that network activity is starting
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
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

extension HomeViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let nodeCount = self.products.count ?? 0
    
    if nodeCount == 0 && indexPath.row == 0 {
      // add a placeholder cell while waiting on table data
      let cell = tableView.dequeueReusableCellWithIdentifier(PlaceHolderCellIdentifier, forIndexPath: indexPath)
      return cell

    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(ProductTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ProductTableViewCell
      
      // Leave cells empty if there's no data yet
      if nodeCount > 0 {
        // Set up the cell representing the app
        let product = self.products[indexPath.row] as Product
        
//        cell!.configure(product: product)
        
        // Only load cached images; defer new downloads until scrolling ends
        if product.productImage == nil {
          if !self.tableView.dragging && !self.tableView.decelerating {
            self.startIconDownload(product, forIndexPath: indexPath)
          }
          // if a download is deferred or in progress, return a placeholder image
          cell!.imageView!.image = UIImage(named: "Placeholder.png")!
        } else {
          cell!.imageView!.image = product.productImage
        }
      }
      return cell!
    }
  }
  
  private func startIconDownload(product: Product, forIndexPath indexPath: NSIndexPath) {
    var iconDownloader = self.imageDownloadsInProgress[indexPath]
    if iconDownloader == nil {
      iconDownloader = ImageDownloader(product: product)
      iconDownloader!.completionHandler = { img in
        
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ProductTableViewCell
                
        // Display the newly loaded image
//        product.productImage = img
        cell?.imageView?.image = img
        
        self.imageDownloadsInProgress.removeValueForKey(indexPath)
        
      }
      self.imageDownloadsInProgress[indexPath] = iconDownloader
      iconDownloader!.startDownload()
    }
    
  }
  
  private func loadImagesForOnscreenRows() {
    if self.products.count > 0 {
      let visiblePaths = self.tableView.indexPathsForVisibleRows!
      for indexPath in visiblePaths as [NSIndexPath] {
        let product = self.products[indexPath.row]
        
        // Avoid the app icon download if the app already has an icon
        if product.productImage == nil {
          self.startIconDownload(product, forIndexPath: indexPath)
        }
      }
    }
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
    if searchController.active == true {
      return nil
    }
    return AddsScrollView.loadFromNib()
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if searchController.active == true {
      return 0
    }
    return 179
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      self.loadImagesForOnscreenRows()
    }
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    self.loadImagesForOnscreenRows()
  }
}

extension HomeViewController: UISearchResultsUpdating {
  
  func filterContentForSearchText(searchText: String) {
    products = []
    
    if searchText == "Tool" {
      goodRequest()
    } else {
      tableView.reloadData()
    }
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
