//
//  ViewController.swift
//  CommunityResearch
//
//  Created by xms on 15/5/19.
//  Copyright (c) 2015年 xms. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate, BaiduLbsDataProviderDelegate {

    @IBOutlet weak var mapView: BMKMapView!
    
    var lbs: BMKLocationService!
    var hasUpdatedUserLoca: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = true
        mapView.zoomLevel = 18
        mapView.delegate = self
        
        lbs = BMKLocationService()
        lbs.delegate = self
        
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("retryUserLocation"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "poiSearch" {
            let controller = segue.destinationViewController as! PoiDemoViewController
            controller.centerlocation = mapView.centerCoordinate
            //controller.delegate = self
        }
    }
    
    
    
    @IBAction func testBtnClicked(sender: AnyObject) {
        var datap = BaiduLbsDataProvider()
        datap.delegate = self;
        datap.searchNearbyLocation("小区", centerCoord: CLLocationCoordinate2DMake(31.224349, 121.476753) )
    }
    
    
    func finishedResults(results:[BMKPoiInfo]){
            NSLog("Done! num of results  \(results.count)")
            
            // map view for plotting
            if results.count > 0 {
                for poi in results {
                    var pin: BMKPointAnnotation = BMKPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2DMake( poi.pt.latitude , poi.pt.longitude)
                    pin.title = poi.name
                    self.mapView.addAnnotation(pin)
                }
            }
    }
    
    
    // BMKMapViewDelegate
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if ( annotation.isKindOfClass(BMKPointAnnotation)) {
            var newAnnotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            newAnnotationView.pinColor = UInt(BMKPinAnnotationColorPurple)
            newAnnotationView.animatesDrop = false;// 设置该标注点动画显示
            return newAnnotationView;
        }
        return nil;
    }
    
    
    // BMKLocationServiceDelegate
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if hasUpdatedUserLoca == false{
            hasUpdatedUserLoca = true
            
            self.mapView.setCenterCoordinate(userLocation.location.coordinate, animated: true)
            BMKLocationService().stopUserLocationService()
        }

    }
    
    func didFailToLocateUserWithError(error: NSError!) {
        println("[Error] didFailToLocateUserWithError occured. \(error.localizedDescription)")
        
//        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("retryUserLocation"), userInfo: nil, repeats: true)
    }
    
    func retryUserLocation(){
        lbs.startUserLocationService()
    }

    
    
    //获得poi结果数据
    @IBAction func unwindFromPoiSearch(segue:UIStoryboardSegue!){
        if (segue.identifier == "backToMap") {
            var srcVc:PoiDemoViewController = segue.sourceViewController as! PoiDemoViewController;
            //NSLog("Violets are %@", srcVc.poiResults);
        }
    }
    
}

