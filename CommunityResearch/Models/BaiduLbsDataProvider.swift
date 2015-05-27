//
//  BaiduLbsDataProvider.swift
//  CommunityResearch
//
//  Created by xms on 15/5/21.
//  Copyright (c) 2015年 xms. All rights reserved.
//



// NOTE: 
// * singleton pattern, following https://gist.github.com/szehnder/84b0bd6f45a7f3f99306
// * singleton impl choose among 3 ways, http://stackoverflow.com/questions/24024549/dispatch-once-singleton-model-in-swift



// NOTE:
// * Q: How to wrap the bmkpoisearch delegate into a block call? A:
protocol BaiduLbsDataProviderDelegate {
    func finishedResults(results:[BMKPoiInfo])
}



class BaiduLbsDataProvider: NSObject, BMKPoiSearchDelegate {
    
    // Singleton impl, 
    // Q: why singleton? multiple results sets should be allowed? 
    // A:
    //    class var sharedInstance:BaiduLbsDataProvider {
    //        struct Singleton {
    //            static let instance = BaiduLbsDataProvider()
    //        }
    //        return Singleton.instance
    //    }
    
    var poiSearcher: BMKPoiSearch!
    var poiResults: [BMKPoiInfo]!
    var keyword: String!
    var centerLocation: CLLocationCoordinate2D!
    var delegate:BaiduLbsDataProviderDelegate?
    
    override init() {
        poiSearcher = BMKPoiSearch()
        poiResults = []
        keyword = ""
        centerLocation = CLLocationCoordinate2DMake(31.241110, 121.516637)
    }
    
    func searchNearbyLocation(keyword:String, centerCoord: CLLocationCoordinate2D) {
        poiResults!.removeAll(keepCapacity: false)
        poiSearcher.delegate = self
        
        self.centerLocation = CLLocationCoordinate2DMake(centerCoord.latitude, centerCoord.longitude)
        queryForPoi(keyword, pageNum:0, centerlocation:centerCoord)
    }
    
    
    func queryForPoi(searchText:String!, pageNum:Int32, centerlocation:CLLocationCoordinate2D ) {
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

            for poi in poiResult.poiInfoList {
                poiResults.append(poi as! BMKPoiInfo)
            }

            //for poi in poiResult.poiInfoList as! [BMKPoiInfo]{
            //    println("\(poi.name) (\(poi.pt.latitude), \(poi.pt.longitude))")
            //}
            
            if (poiResult.pageIndex < poiResult.pageNum) {
                queryForPoi(keyword , pageNum: poiResult.pageIndex+1, centerlocation:centerLocation)
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
                    //                    var marker = BMKPointAnnotation()
                    //                    marker.coordinate = CLLocationCoordinate2DMake(poi.pt.latitude, poi.pt.longitude)
                    //                    self.addAnotation(marker)
                }
                
                self.delegate!.finishedResults(self.poiResults)
                
            } else {
                println("抱歉，未找到结果")
            }
        } else {
            println("[Error] Error code : \(errorCode.value)  ");
        }
    }
    
}