//
//  ZYMViewController.swift
//  MyWeather_swift
//
//  Created by zhuyongqing on 15/11/10.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

var CITY = "CITY"
let TAG = 10

class ZYMViewController: UIViewController,CLLocationManagerDelegate,UIScrollViewDelegate {

    //定位
    var _location:ZYLocation!
    
    //滑动视图
    var scrollView:UIScrollView!
    
    //页数
    var pageControl:UIPageControl!
    
    //城市数组
   var cityArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //CFURLCreateStringByAddingPercentEscapes
        
        //定位
        self.setLocation();
        
        //加 上视图
        self.buildView();
        //从本地取u
        if let arr = NSUserDefaults.standardUserDefaults().objectForKey(CITY){
            //如果不为空就创建
            self.buildWeathers(arr as! [String]);
           
        }else{
            //创建新的
            self.addWeather(self.view.width);
        }
        
    }

    func buildWeathers(arr:[String]){
         self.cityArr = arr
        
        for(var i = 1;i<=self.cityArr.count;i++){
            self.addWeather(self.view.width * CGFloat(i));
            self.upDateWeatherData(self.cityArr[i-1], tag: i*TAG);
        }
        self.scrollView.setContentOffset(CGPointMake(0,0), animated: true);
    }
    
    //MARK:初始视图
    func buildView(){
        //滑动视图
        scrollView = UIScrollView.init(frame: self.view.frame);
        scrollView.contentSize = CGSizeMake(self.view.width, 0);
        scrollView.delegate = self;
        scrollView.pagingEnabled = true;
        scrollView.bounces = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "gradient3")!);
        self.view.addSubview(scrollView);
        
        //页数控制
        pageControl = UIPageControl.init();
        pageControl.numberOfPages = NSInteger(self.scrollView.contentSize.width)/NSInteger(self.view.width);
        pageControl.backgroundColor = UIColor.whiteColor();
        pageControl.currentPageIndicatorTintColor = UIColor.init(patternImage: UIImage.init(named: "yuandian1")!)
        pageControl.pageIndicatorTintColor = UIColor.init(patternImage: UIImage.init(named: "yuandian1")!)
        pageControl.centerX = self.view.width/2;
        pageControl.centerY = self.view.height-40;
        self.view.addSubview(pageControl);
    }
    
    
    //MARK:请求数据
    func upDateWeatherData(cityName:NSString,tag:Int){
        ZYHTTPTool.requset(self.returnUrl(cityName as String), result: { (responseObject) -> Void in
            let data = ZYWeatherData.weatherWithArray(responseObject["HeWeather data service 3.0"] as! NSArray)
            
            let weather:ZYWeatherView = self.scrollView.viewWithTag(tag) as! ZYWeatherView
            weather.buidView(data);
            }) { (error) -> Void in
                print(error);
        }
    }
    
    //MARK:加天气页面
    func addWeather(width:CGFloat){
        //改变滑动视图的容量
        self.scrollView.contentSize = CGSizeMake(width, 0);
        //改变页数
        self.pageControl.numberOfPages = NSInteger(width)/NSInteger(self.view.width);
        //移动页数
      self.scrollView.setContentOffset(CGPointMake(width-self.view.width,0), animated: true);
        //创建天气页面
        let weather:ZYWeatherView = NSBundle.mainBundle().loadNibNamed("ZYWeatherView", owner: nil, options: nil).first as! ZYWeatherView;
        weather.frame = CGRectMake(width-self.view.width,0,self.scrollView.width, self.scrollView.height);
        //设置页面的标识
        weather.tag = self.pageControl.numberOfPages*TAG
        //加到滚动视图中
        self.scrollView.addSubview(weather);
    }
    
    
    //MARK:设置定位
    func setLocation(){
        _location = ZYLocation.init();
        _location.settingLocaton(self);
    }
    
    //MARK:位置完成更新
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let core = locations.first!;
        let coordinate = core.coordinate;
        _location.getAdress(coordinate.latitude, longitude: coordinate.longitude, sussecd: { (parms) -> Void in
            let str:NSString = parms.locality!!;
            //去掉定位的城市的最后一个 市字
            let city = str.substringToIndex(str.length-1);
            
            //判断数组里是否存在
            if self.isHaveCity(city){
                
            }else{
                //加到数组
                self.cityArr.append(city)
                //保存
                NSUserDefaults.standardUserDefaults().setObject(self.cityArr, forKey: CITY);
                //更新数据
                self.upDateWeatherData(city, tag: 1*TAG);
            }
           
        })
        
    }
    
    
    //MARK:判断是否已存在城市
    func isHaveCity(city:NSString) -> Bool{
        
        for(var i = 0;i<self.cityArr.count;i++){
            let str = self.cityArr[i];
            if city.isEqualToString(str){
                return true;
            }
        }
        return false;
    }
    
    //MARK:url城市名称编码
    func returnUrl(cityName:String) -> String
    {
        return "http://apis.baidu.com/heweather/weather/free?city=\(cityName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
    }

}
