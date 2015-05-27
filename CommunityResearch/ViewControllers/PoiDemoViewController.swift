//
//  PoiDemoViewController.swift
//  CommunityResearch
//
//  Created by xms on 15/5/19.
//  Copyright (c) 2015年 xms. All rights reserved.
//


import UIKit

class PoiDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate, BMKGeneralDelegate, BaiduLbsDataProviderDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    var poiSearcher = BMKPoiSearch()
    var centerlocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        poiSearcher.delegate = self
    }
    
    // search controller result table delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    // searchbar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //单字符不检索，SUG: 单英文不检索
        if count(searchText) < 2 {
            return;
        }
        
        println("\(searchText)")
        var datap = BaiduLbsDataProvider()
        datap.delegate = self;
        datap.searchNearbyLocation(searchText, centerCoord: CLLocationCoordinate2DMake(31.224349, 121.476753) )  //  TODO: centerlocation
    }
    
    
    
    // BaiduLbsDataProviderDelegate
    func finishedResults(results:[BMKPoiInfo]){
        NSLog("Done! num of results  \(results.count)")
        
        // return to map view for plotting
        if results.count > 0 {
            println("Button seen.  Trigging exit segue manually...")
            self.performSegueWithIdentifier("backToMap", sender: self)
        }
    }
    
}