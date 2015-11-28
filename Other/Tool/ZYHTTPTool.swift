//
//  ZYHTTPTool.swift
//  MyWeather_swift
//
//  Created by zhuyongqing on 15/11/10.
//  Copyright © 2015年 zhuyongqing. All rights reserved.
//

import Foundation

//成功返回
typealias sussecs = (responseObject:AnyObject) -> Void

//失败返回
typealias faild = (error:NSError) -> Void



class ZYHTTPTool: NSObject {

    class  func requset(httpUrl:String!,result:sussecs,error:faild)
    {
        let confuguration = NSURLSessionConfiguration.defaultSessionConfiguration();
        let manager = AFURLSessionManager.init(sessionConfiguration: confuguration);
        
        let serializer = AFJSONRequestSerializer.init();
    serializer .setValue("6e2cfdae7ef55fea63fc5a9a203a16e5", forHTTPHeaderField: "apikey");
        
      let dataTask =  manager.dataTaskWithRequest(serializer.requestWithMethod("GET", URLString: httpUrl, parameters: nil)) { (response:NSURLResponse!, obj:AnyObject!, err:NSError!) -> Void in
        if let errs = err {
            error(error: errs);
        }else{
            result(responseObject: obj);
        }
        
    }
        
     dataTask.resume();
    
 }
    
}






