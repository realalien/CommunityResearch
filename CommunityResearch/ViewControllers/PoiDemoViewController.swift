//
//  PoiDemoViewController.swift
//  CommunityResearch
//
//  Created by xms on 15/5/19.
//  Copyright (c) 2015年 xms. All rights reserved.
//




import UIKit

class PoiDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate{
    
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
        println("\(searchText)")
        
        var option = BMKNearbySearchOption()
        option.pageIndex = 0
        option.pageCapacity = 50
        option.location = centerlocation
        option.keyword = searchText
        
        poiSearcher.poiSearchNearBy(option);
        
    }
    
    
    // bmkpoisearch delegate
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if (errorCode.value == BMK_SEARCH_NO_ERROR.value) {
            //在此处理正常结果
            
            for poi in poiResult.poiInfoList {
                println("\(poi.name)")
            }
            
            
        } else if (errorCode.value == BMK_SEARCH_AMBIGUOUS_KEYWORD.value){
            //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
            // result.cityList;
            println("起始点有歧义");
        } else {
            println("抱歉，未找到结果");
        }
    }
    
    
    
    
}