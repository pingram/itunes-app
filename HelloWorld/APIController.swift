//
//  APIController.swift
//  HelloWorld
//
//  Created by Philip Ingram on 7/4/15.
//  Copyright (c) 2015 Philip Ingram. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
  func didReceiveAPIResults(results: NSArray)
}

class APIController {
  var delegate: APIControllerProtocol?
  
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
            self.delegate?.didReceiveAPIResults(results)
          }
        }
        
      })
      
      task.resume()
    }
  }
  
}