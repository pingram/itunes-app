//
//  ViewController.swift
//  HelloWorld
//
//  Created by Philip Ingram on 7/3/15.
//  Copyright (c) 2015 Philip Ingram. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var tableData = []
  
  @IBOutlet var appsTableView : UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    searchItunesFor("JQ Software")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
    return tableData.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
    
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
  
  func searchItunesFor(searchTerm: String) {
    let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
      let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
      let url = NSURL(string: urlPath)
      let session = NSURLSession.sharedSession()
      let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
        println("Task Completed")
        if (error != nil) {
          println(error.localizedDescription)
        }
        var err: NSError?
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
          if(err != nil) {
            println("JSON Error \(err!.localizedDescription)")
          }
          if let results: NSArray = jsonResult["results"] as? NSArray {
            dispatch_async(dispatch_get_main_queue(), {
              self.tableData = results
              self.appsTableView!.reloadData()
            })
          }
        }
        
      })
      
      task.resume()
    }
  }
  
}

