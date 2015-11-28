//
//  ZYLocation.swift
//  MyWeather_swift
//
//  Created by zhuyongqing on 15/11/10.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import Foundation
import CoreLocation

typealias Sussecs = (parms:AnyObject) -> Void

class ZYLocation: NSObject,CLLocationManagerDelegate {
    
    
    var locationManger:CLLocationManager?
    
    var _geocoder:CLGeocoder!
    //MARK:设置定位
    func settingLocaton(obj:ZYMViewController){
        locationManger = CLLocationManager.init()
        
        if (!CLLocationManager.locationServicesEnabled()){
            print("定位可能尚未打开，请设置打开")
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined){
            locationManger?.requestWhenInUseAuthorization()
        }
        //设置代理
        locationManger?.delegate = obj;
        //设置定位精度
        locationManger?.desiredAccuracy = kCLLocationAccuracyBest;
        //设置多少米定位一次
        let distance:CLLocationDistance = 100000.0;
        locationManger?.distanceFilter = distance;
        //启动跟踪定位
        locationManger?.startUpdatingLocation();
        _geocoder = CLGeocoder.init();
        
    }
    //MARK:根据地标获得 地址
    internal func getAdress(latitude:CLLocationDegrees,longitude:CLLocationDegrees,sussecd:Sussecs){
        let location:CLLocation = CLLocation.init(latitude: latitude, longitude: longitude);
    
        //解码
        _geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
            sussecd(parms: (placemarks?.first)!)
         
        })
    }
    
    //MARK:停止定位
    internal func stopUpdating(){
        locationManger?.stopUpdatingLocation();
    }
}
