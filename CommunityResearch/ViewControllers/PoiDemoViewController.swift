//
//  PoiDemoViewController.swift
//  CommunityResearch
//
//  Created by xms on 15/5/19.
//  Copyright (c) 2015年 xms. All rights reserved.
//




import UIKit

class PoiDemoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, BMKPoiSearchDelegate, BMKGeneralDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
 
    var poiSearcher = BMKPoiSearch()
    var centerlocation: CLLocationCoordinate2D!
    var poiResults: NSMutableArray!
    var searchKeyword: String!
    
    
    override func viewDidLoad() {
        poiSearcher.delegate = self
        poiResults = NSMutableArray()
        searchKeyword = ""
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
        
        poiResults.removeAllObjects()
        searchKeyword = searchText
        queryForPoi(searchKeyword, pageNum: 0)
        
    }
    
    
    func queryForPoi(searchText:String!, pageNum:Int32 ) {
        println("queryForPoi .... \(pageNum)")
        var option = BMKNearbySearchOption()
        option.pageIndex = pageNum
        option.pageCapacity = 50
        println("(\(centerlocation.latitude), \(centerlocation.longitude) ) ")
        option.location = centerlocation
//        self.searchKeyword = searchText
        option.keyword =  "小区";//
        
        var flag:Bool = poiSearcher.poiSearchNearBy(option);
        if(flag){
            NSLog("检索发送成功");
        } else {
            NSLog("检索发送失败");
        }
    }
    
    
    // bmkpoisearch delegate
    func onGetPoiResult(searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if (errorCode.value == BMK_SEARCH_NO_ERROR.value) {
            //在此处理正常结果
            poiResults.addObjectsFromArray(poiResult.poiInfoList as! [BMKPoiInfo])
            
            //for poi in poiResult.poiInfoList as! [BMKPoiInfo]{
            //    println("\(poi.name) (\(poi.pt.latitude), \(poi.pt.longitude))")
            //}
            
            if (poiResult.pageIndex < poiResult.pageNum) {
                queryForPoi(self.searchKeyword , pageNum: poiResult.pageIndex+1)
            } else {
                // see error code, BMK_SEARCH_RESULT_NOT_FOUND
            }
        } else if (errorCode.value == BMK_SEARCH_AMBIGUOUS_KEYWORD.value){
            //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
            // result.cityList;
            println("起始点有歧义");
        } else if (errorCode.value == BMK_SEARCH_RESULT_NOT_FOUND.value){
            if poiResults.count > 0 { // NOTE: accumulated results
                println("查询结束")
                // DEBUG:
                for poi in poiResults {  //  as! [BMKPoiInfo]
                    println("\(poi.name) (\(poi.pt.latitude), \(poi.pt.longitude))")
                }
            } else {
                println("抱歉，未找到结果")
            }
        } else {
            println("[Error] Error code : \(errorCode.value)");
        }
    }
    
}