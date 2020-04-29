//
//  SettingElement.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension RouletteViewController{
    public func settingElement(){
        if elements == nil{
            elements = Array<Dictionary<ElementEnum,Any?>>()
            elements.append([.rate:Float(0.5),.color:UIColor.orange.cgColor])
            elements.append([.rate:Float(0.5),.color:UIColor.green.cgColor])
        }
    }
}
