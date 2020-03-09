//
//  HWLocationManage.swift
//  swift-定位工具
//
//  Created by 李含文 on 2019/1/21.
//  Copyright © 2019年 SK丿希望. All rights reserved.
//

import UIKit
import CoreLocation

class HWLocationItem: NSObject {
    /// 经度
    var latitude:Double = 0
    /// 纬度
    var longitude:Double = 0
    /// 国家
    var country = ""
    /// 省
    var province = ""
    /// 市
    var city = ""
    /// 区
    var area = ""
    /// 街道
    var thoroughfare = ""
    /// 详细地址
    var address = ""
}
private let manage = HWLocationManage()
class HWLocationManage: NSObject {
    open var actionBlock:((HWLocationItem?)->())?
    private lazy var locationManager = CLLocationManager()
    private lazy var geoCoder = CLGeocoder()
    
    /// 单例方法
//    static let instance: HWLocationManage = HWLocationManage()
//    open class func sharedManage() -> HWLocationManage {
//        return instance
//    }
    /// 地理编码
    open class func hw_getLocation(_ text:String,_ action:@escaping ((HWLocationItem?)->())) {
        manage.actionBlock = { (item) in
            action(item)
        }
        manage.hw_getLocation(text)
    }
    open class func hw_getCurrentLocatio(action:@escaping ((HWLocationItem?)->())) {
        manage.actionBlock = { (item) in
            action(item)
        }
        manage.loadLocation()
    }
    /// 反地理编码  经纬度->地址
    open class func hw_getLocation(_ latitude:Double, _ longitude:Double, _ action:@escaping ((HWLocationItem?)->())) {
        manage.actionBlock = { (item) in
            action(item)
        }
        manage.hw_getLocation(latitude, longitude)
    }
    // MARK: 开始定位
    private func loadLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位方式
        if(UIDevice.current.systemVersion >= "8.0"){ //iOS8.0以上才可以使用
            //始终允许访问位置信息
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation() //开启定位
    }
    // MARK: 地理编码  地址->经纬度
    private func hw_getLocation(_ text:String) {
        geoCoder.geocodeAddressString(text) { [weak self] (pls: [CLPlacemark]?, error: Error?)  in
            if error == nil {
                print("地理编码成功")
                guard let plsResult = pls else {return}
                self?.getLocationItem(plsResult)
            }else {
                print("错误")
                if self?.actionBlock != nil {
                    self?.actionBlock!(nil)
                }
            }
        }
    }
    
    // MARK: 反地理编码  经纬度->地址
    private func hw_getLocation(_ latitude:Double, _ longitude:Double) {
        let loc1 = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(loc1) { [weak self] (pls: [CLPlacemark]?, error: Error?)  in
            if error == nil {
                print("反地理编码成功")
                guard let plsResult = pls else {return}
                self?.getLocationItem(plsResult)
            }else {
                print("错误")
                if self?.actionBlock != nil {
                    self?.actionBlock!(nil)
                }
            }
        }
    }
    // MARK: 获取位置模型
    private func getLocationItem(_ pls: [CLPlacemark]) {
        let pl = pls.first
        let item = HWLocationItem()
        item.address = pl?.name ?? "" // 详细地址
        item.country = pl?.country ?? "" // 国家
        item.province = pl?.administrativeArea ?? "" // 省
        if item.province.isEmpty {
            item.province = (pl?.addressDictionary?["State"] ?? "") as! String
        }
        item.city = pl?.locality ?? "" // 市
        if item.city.isEmpty {
            item.city = (pl?.addressDictionary?["City"] ?? "") as! String
        }
        if item.city.isEmpty { // 四大直辖市的城市信息无法通过CLPlacemark的locality属性获得，只能通过访问administrativeArea属性来获得（如果locality为空，则可知为直辖市）
            item.city = pl?.administrativeArea ?? ""
        }
        var area = pl?.subLocality ?? ""
        if area.isEmpty {
            area = (pl?.addressDictionary?["SubLocality"] ?? "") as! String
        }
        if area.isEmpty {
            area = item.city
        }
        item.area = area // 区
        item.thoroughfare = pl?.thoroughfare ?? ""// 街道
        let newLocation = pl?.location?.hw_locationBaiduFromMars()
        item.latitude = newLocation?.coordinate.latitude ?? 0
        item.longitude = newLocation?.coordinate.longitude  ?? 0
//        print("省市自治区（州）:\(pl?.administrativeArea ?? "未知")")
//        print("县区:\(pl?.subLocality ?? "未知")")
//        print("国家地区:\(pl?.country ?? "未知")")
//        print("县区(大陆为空):\(pl?.subAdministrativeArea ?? "未知")")
//        print("道路+门牌号:\(pl?.name ?? "未知")")
//        print("道路:\(pl?.thoroughfare ?? "未知")")
//        print("门牌号:\(pl?.subThoroughfare ?? "未知")")
        if self.actionBlock != nil {
            self.actionBlock!(item)
        }
    }
    deinit {
        print("释放")
    }
}
extension HWLocationManage : CLLocationManagerDelegate {
    //获取定位信息

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1] //取得locations数组的最后一个
        if(location.horizontalAccuracy > 0){ //判断是否为空
            let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            let lon = Double(String(format: "%.1f", location.coordinate.longitude))
            print("纬度:\(lon!)")
            print("经度:\(lat!)")
            hw_getLocation(lat ?? 0, lon ?? 0)
            locationManager.stopUpdatingLocation() //停止定位
        }
    }
    //出现错误
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if self.actionBlock != nil {
            self.actionBlock!(nil)
        }
    }
}


// --- transform_earth_from_mars ---
// 参考来源：https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
let a:Double = 6378245.0
let ee:Double = 0.00669342162296594323

// --- transform_earth_from_mars end ---
// --- transform_mars_vs_bear_paw ---
// 参考来源：http://blog.woodbunny.com/post-68.html
let x_pi:Double = M_PI * 3000.0 / 180.0

public extension CLLocation {
    
    /// 从地图坐标转化到火星坐标
    func hw_locationMarsFromEarth() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat + self.coordinate.latitude, longitude: n_lng + self.coordinate.longitude)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从火星坐标到地图坐标
    func hw_locationEarthFromMars() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: self.coordinate.latitude - n_lat, longitude: self.coordinate.longitude - n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从火星坐标转化到百度坐标
    func hw_locationBaiduFromMars() -> CLLocation {
        
        let (n_lat,n_lng) = CLLocation.transform_mars_from_baidu(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    /// 从百度坐标到火星坐标
    func hw_locationMarsFromBaidu() -> CLLocation {
        let (n_lat,n_lng) = CLLocation.transform_baidu_from_mars(lat: self.coordinate.latitude, lng: self.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: n_lat, longitude: n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
        
    }
    
    /// 从百度坐标到地图坐标
    func hw_locationEarthFromBaidu() -> CLLocation {
        
        let mars = self.hw_locationMarsFromBaidu()
        let (n_lat,n_lng) = CLLocation.transform_earth_from_mars(lat: mars.coordinate.latitude, lng: mars.coordinate.longitude)
        let coord_2d = CLLocationCoordinate2D(latitude: self.coordinate.latitude - n_lat, longitude: self.coordinate.longitude - n_lng)
        
        return CLLocation(coordinate: coord_2d, altitude: self.altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.horizontalAccuracy, course: self.course, speed: self.speed, timestamp: self.timestamp)
    }
    
    private class func transform_earth_from_mars(lat: Double, lng: Double) -> (Double, Double) {
        if CLLocation.transform_sino_out_china(lat: lat, lng: lng) {
            return (lat, lng)
        }
        var dLat = CLLocation.transform_earth_from_mars_lat(lng - 105.0, lat - 35.0)
        var dLng = CLLocation.transform_earth_from_mars_lng(lng - 105.0, lat - 35.0)
        let radLat = lat / 180.0 * M_PI
        var magic = sin(radLat)
        magic = 1 - ee * magic * magic
        let sqrtMagic:Double = sqrt(magic)
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI)
        dLng = (dLng * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI)
        return (dLat,dLng)
    }
    private class func transform_earth_from_mars_lat(_ x: Double,_ y: Double) -> Double {
        var ret: Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
        ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0
        return ret
    }
    private class func transform_earth_from_mars_lng(_ x: Double,_ y: Double) -> Double {
        var ret: Double = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
        ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0
        return ret
    }
    private class func transform_mars_from_baidu(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng , y = lat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)
        return (z * sin(theta) + 0.006, z * cos(theta) + 0.0065)
    }
    private class func transform_baidu_from_mars(lat: Double, lng: Double) -> (Double,Double) {
        let x = lng - 0.0065 , y = lat - 0.006
        let z =  sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)
        return (z * sin(theta), z * cos(theta))
    }
    private class func transform_sino_out_china(lat: Double, lng: Double) -> Bool {
        if (lng < 72.004 || lng > 137.8347) {
            return true
        }
        if (lat < 0.8293 || lat > 55.8271) {
            return true
        }
        return false
    }
}
