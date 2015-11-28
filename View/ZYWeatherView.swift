//
//  ZYWeatherView.swift
//  MyWeather_swift
//
//  Created by zhuyongqing on 15/11/10.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import UIKit

let LIGHT_FONT = "HelveticaNeue-Light"
let ULTRALIGHT_FONT = "HelveticaNeue-UltraLight"

///天气view
class ZYWeatherView: UIView {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var weatherImage: UIImageView! //天气图
    
    @IBOutlet weak var weatherLabel: UILabel!  //天气名
    @IBOutlet weak var cityLabel: UILabel!  //城市名
    
    let num = arc4random()%5+1
    internal func buidView(data:[ZYWeatherData]){
        
        let weather:ZYWeatherData = data[0] as ZYWeatherData;
        //背景图
        let image = UIImageView.init(image: UIImage.init(named: "gradient\(num)"));
        image.frame = self.frame;
        self.addSubview(image);
        
        self.addSubview(self.weatherImage);
        self.addSubview(self.cityLabel);
        self.addSubview(self.weatherLabel);
        self.addSubview(self.backView);
        
        
        //天气图
        self.weatherImage.image = ZYWeatherView.stringWithWeather(weather.weather as NSString)
        //天气
        self.weatherLabel.text = weather.weather!;
        //城市
        self.cityLabel.text = weather.cityName;
        
        self.backView.backgroundColor = UIColor.init(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.3);

        //现在的温度
        let nowTmp = UILabel.init();
        nowTmp.frame = CGRectMake(15,0,100,80);
        nowTmp.text = weather.nowTmp;
        nowTmp.textColor = UIColor.whiteColor();
        nowTmp.textAlignment = NSTextAlignment.Center;
        nowTmp.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 80)
        self.backView.addSubview(nowTmp);
        
        //最高 最低温
        let maxmin = UILabel.init();
        maxmin.frame = CGRectMake(nowTmp.left,nowTmp.bottom,120,40);
        maxmin.textColor = UIColor.whiteColor();
        maxmin.textAlignment = NSTextAlignment.Center;
        maxmin.font = UIFont.init(name:LIGHT_FONT, size: 22);
        maxmin.text = "H \(weather.maxTmp) L \(weather.minTmp)"
        self.backView.addSubview(maxmin);
        
        //温度 圆圈显示
        let tmpLabel = UILabel.init();
        tmpLabel.frame = CGRectMake(nowTmp.right-10,nowTmp.top,50, 50);
        tmpLabel.text = "°"
        tmpLabel.textColor = UIColor.whiteColor();
        tmpLabel.font = UIFont.init(name: ULTRALIGHT_FONT, size: 50);
        self.backView.addSubview(tmpLabel);
        
        //三天的天气
        for(var i:CGFloat = 1;i<=3;i++){
            let width = (self.width-(nowTmp.right + 80))/3;
            let week = ZYWeekView.init(frame: CGRectMake(nowTmp.right+30+(i-1)*(width+20),0,width,self.backView.height),
                wether: data[NSInteger(i)]);
            self.backView.addSubview(week);
        }
    }
    
    
    
    //MARK:根据天气显示图片
    class func stringWithWeather(weatherName:NSString) -> UIImage
    {
        var weatherImg = UIImage();
        
        if weatherName.isEqualToString("晴"){
            weatherImg = UIImage.init(named: "qing")!;
        }else if weatherName.isEqualToString("多云"){
            weatherImg = UIImage.init(named: "duoyun")!;
        }else if weatherName.isEqualToString("晴间多云"){
            weatherImg = UIImage.init(named: "qingjianduoyun")!;
        }else if weatherName.isEqualToString("阴"){
            weatherImg = UIImage.init(named: "yin")!;
        }else if weatherName.isEqualToString("小雪"){
            weatherImg = UIImage.init(named: "xiaoxue")!;
        }else if weatherName.isEqualToString("阴转晴"){
            weatherImg = UIImage.init(named: "yinzhuanqing")!;
        }else if weatherName.isEqualToString("小雨"){
            weatherImg = UIImage.init(named: "xiaoyu")!;
        }else if weatherName.isEqualToString("大雨") || weatherName.isEqualToString("中雨"){
            weatherImg = UIImage.init(named: "dayu")!;
        }else if weatherName.isEqualToString("雨转晴"){
            weatherImg = UIImage.init(named: "yuzhuanqing")!;
        }else if weatherName.isEqualToString("雷阵雨"){
            weatherImg = UIImage.init(named: "zhenyu")!;
        }else if weatherName.isEqualToString("暴雨"){
            weatherImg = UIImage.init(named: "baoyu")!;
        }else if weatherName.isEqualToString("雨夹雨"){
            weatherImg = UIImage.init(named: "yujiaxue")!;
        }else{
            weatherImg = UIImage.init(named: "qing")!;
        }
        return weatherImg;
    }
}

//周几的view

class ZYWeekView:UIView {
    //天气的数据
    var weatherData:ZYWeatherData!
    //星期的label
    let weeklabel:UILabel!
    //天气图片
    let weatherImage:UIImageView!
    //
    var isTmp:Bool!
    //
    let tmpView:ZYTmpView!
    
    init(frame: CGRect,wether:ZYWeatherData) {
        self.weatherData = wether;
        //星期
        self.weeklabel = UILabel.init();
        self.weeklabel.frame = CGRectMake(0,10,frame.size.width,20);
        self.weeklabel.font = UIFont.init(name: LIGHT_FONT, size: 13);
        self.weeklabel.textColor = UIColor.whiteColor()
        self.weeklabel.textAlignment = NSTextAlignment.Center;
       
        //天气图
        self.weatherImage = UIImageView.init();
        self.weatherImage.frame = CGRectMake(0,self.weeklabel.bottom+10,frame.size.width,frame.size.height-self.weeklabel.bottom-25);
        self.weatherImage.contentMode = UIViewContentMode.ScaleAspectFill;
        self.weatherImage.image = ZYWeatherView .stringWithWeather(weatherData.weather as NSString);
        self.weatherImage.userInteractionEnabled = true;
        
        self.isTmp = true;
        
        self.tmpView = ZYTmpView.init(frame: CGRectMake(-10,20,80,80), wetherData: weatherData);
        self.tmpView.alpha = 0;
        
        
        super.init(frame: frame);
        
        self.weeklabel.text = self.weekDay(weatherData.date as NSString) as String;
        
        self.addSubview(self.weeklabel);
        
        self.addSubview(self.weatherImage);
        
        self.userInteractionEnabled = true;
        
        //圆圈
        self.addSubview(self.tmpView);
        //加上点击手势
        let tap = UITapGestureRecognizer.init(target: self, action: Selector("addMaxTmp"));
        self.addGestureRecognizer(tap);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:点击事件
    func addMaxTmp(){
        if (isTmp != false){
            //展示动画
            self.tmpView.show();
            isTmp = false;
        }else{
            self.tmpView.hide();
            isTmp = true;
        }
    }
    
    //MARK:根据日期返回星期几
    func weekDay(formart:NSString) -> NSString
    {
        let weekDay:NSString?
        
        let comps = NSDateComponents.init()
        
        let str:NSString = formart.description;
        if (str.length >= 10) {
            let nowString = str.substringToIndex(10);
            var array:NSArray = nowString.componentsSeparatedByString("-");
            if (array.count == 0) {
                array = nowString.componentsSeparatedByString("/");
            }
            if (array.count >= 3) {
                let y:NSString = array.objectAtIndex(0) as! NSString
                let year = y.integerValue;
                let month = array.objectAtIndex(1).integerValue;
                 let day = array.objectAtIndex(2).integerValue;
                comps.year = year;
                comps.month = month;
                comps.day = day;
            }
        }
        let gregorian = NSCalendar.init(calendarIdentifier: NSGregorianCalendar);
        let _date = gregorian!.dateFromComponents(comps);
        let weekdayComponents = gregorian?.component(NSCalendarUnit.Weekday, fromDate: _date!);
        let week:Int = weekdayComponents!;
        switch (week) {
        case 1:
            weekDay = "星期日";
            break;
        case 2:
            weekDay = "星期一";
            break;
        case 3:
            weekDay = "星期二";
            break;
        case 4:
            weekDay = "星期三";
            break;
        case 5:
            weekDay = "星期四";
            break;
        case 6:
            weekDay = "星期五";
            break;
        case 7:
            weekDay = "星期六";
            break;
        default:
            weekDay = "";
            break;
        }
        return weekDay!;
    }
    
}

///温度的园圈

let kPosition:CGFloat = 120

class ZYTmpView : UIView{
    
    let maxLabel:UILabel!
    
    init(frame: CGRect,wetherData:ZYWeatherData) {
        //最高最低温
        self.maxLabel = UILabel.init();
        
        
        super.init(frame: frame);
         self.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 0.3);
        self.layer.cornerRadius = frame.height/2;
        self.maxLabel.frame = CGRectMake(0, 0, 80, 80);
        self.maxLabel.textAlignment = NSTextAlignment.Center;
        self.maxLabel.textColor = UIColor.whiteColor();
        self.maxLabel.font = UIFont.init(name: LIGHT_FONT, size: 20);
        self.maxLabel.text = "\(wetherData.maxTmp) / \(wetherData.minTmp)";
        self.addSubview(self.maxLabel);
    }

    //MARK:出场动画
    func show(){
        self.alpha = 1;
        
        let animation = CAKeyframeAnimation.init(keyPath: "position");
        let pathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathRef,nil,self.center.x, self.center.y);
        CGPathAddLineToPoint(pathRef, nil,self.center.x,self.center.y+kPosition);
        CGPathAddLineToPoint(pathRef, nil,self.center.x, self.center.y+kPosition-15);
        CGPathAddLineToPoint(pathRef, nil,self.center.x, self.center.y+kPosition-5);
        CGPathAddLineToPoint(pathRef, nil,self.center.x, self.center.y+kPosition-10);
        animation.path = pathRef;
        animation.delegate = self;
        animation.duration = 0.4;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = false;
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        
        self.layer.addAnimation(animation, forKey: "position");
    }
    
    //MARK:隐藏
    func hide(){
        UIView.animateWithDuration(0.4, animations: { () -> Void in
             self.origin = CGPointMake(self.origin.x, 20)
            }) { (Bool) -> Void in
                self.alpha = 0;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}









