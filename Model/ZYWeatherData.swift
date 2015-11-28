//
//  ZYWeatherData.swift
//  MyWeather_swift
//
//  Created by zhuyongqing on 15/11/10.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit

class ZYWeatherData: NSObject {
    
    var maxTmp:String!  //最高温
    var minTmp:String! //最低温
    var wind:String!   //风向
    var weather:String! //天气
    var nowTmp:String! //现在的温度
    var cityName:String! //城市的名称
    var date:String! //时间
    
     override init() {
        super.init();
       
    }
   //MARK:初始化得到一个天气数据模型
  class func returnWeather(dict:NSDictionary) -> ZYWeatherData{
        let weather = ZYWeatherData.init();
        weather.maxTmp = dict["tmp"]!["max"]! as! String;
        weather.minTmp = dict["tmp"]!["min"]! as! String;
        weather.wind = dict["wind"]!["dir"]! as! String;
        weather.weather = dict["cond"]!["txt_d"]! as! String;
        weather.date = dict["date"]! as! String;
        return weather;
    }
    
    //MARK:根据数据返回一个 模型的数组
    class func weatherWithArray(data:NSArray) -> [ZYWeatherData] {
        let tmp:NSArray = data[0]["daily_forecast"] as! NSArray;
        var weatherData = [ZYWeatherData]();
       
        tmp.enumerateObjectsUsingBlock {(idx, index,stop) -> Void in
            ///用字典创建一个 模型
            let weather = ZYWeatherData.returnWeather(idx as! NSDictionary);
            //如果是第一个 插入现在的天气 和 城市名称
            if index == 0{
                //现在的天气
                weather.nowTmp = data[0]["now"]!!["tmp"]! as! String;
                //城市名称
                weather.cityName = data[0]["basic"]!!["city"]! as! String;
            }
            //加入数组
            weatherData.append(weather);
        }
        
        return weatherData;
    }
    
    
}
