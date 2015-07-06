//
//  ViewController.swift
//  HelloWorld
//
//  Created by Philip Ingram on 7/3/15.
//  Copyright (c) 2015 Philip Ingram. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
  
  let api = APIController()
  
  var tableData = []
  
  let kCellIdentifier: String = "SearchResultCell"
  
  @IBOutlet var appsTableView : UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    api.delegate = self
    api.searchItunesFor("Angry Birds")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
    return tableData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
    
    if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
      urlString = rowData["artworkUrl60"] as? String,
      imgURL = NSURL(string: urlString),
      formattedPrice = rowData["formattedPrice"] as? String,
      imgData = NSData(contentsOfURL: imgURL),
      trackName = rowData["trackName"] as? String {
        cell.detailTextLabel?.text = formattedPrice
        cell.imageView?.image = UIImage(data: imgData)
        cell.textLabel?.text = trackName
    }
    return cell
  }
  
  func didReceiveAPIResults(results: NSArray) {
    dispatch_async(dispatch_get_main_queue(), {
      self.tableData = results
      self.appsTableView!.reloadData()
    })
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let rowData = self.tableData[indexPath.row] as? NSDictionary,
      name = rowData["trackName"] as? String,
      formattedPrice = rowData["formattedPrice"] as? String {
        let alert = UIAlertController(title: name, message: formattedPrice, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
}

