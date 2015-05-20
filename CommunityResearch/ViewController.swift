//
//  ViewController.swift
//  CommunityResearch
//
//  Created by xms on 15/5/19.
//  Copyright (c) 2015年 xms. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {

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
        lbs.startUserLocationService()
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
    
    
    // BMKMapViewDelegate
    

    
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
    }

    
}

