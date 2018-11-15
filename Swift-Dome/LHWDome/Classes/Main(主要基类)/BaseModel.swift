//
//  BaseModel.swift
//  JYKShop
//
//  Created by 梁琪琛 on 2017/12/26.
//  Copyright © 2017年 ThreeHeart. All rights reserved.
//

import UIKit
import HandyJSON

// -MARK: 继承此model不用重写init()函数
class BaseModel: HandyJSON {
    
    required init() {}
}

class RefreshModel<T: HandyJSON>: BaseModel{
    typealias ModelType  = RefreshModel<T>
    
    var desc : String? = ""
    var status : Bool? = false
    var data : T?
    var flag: String!
    
    required init() {}
}


