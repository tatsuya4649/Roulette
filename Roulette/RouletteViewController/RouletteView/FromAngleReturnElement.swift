//
//  FromAngleReturnElement.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension RouletteView{
    public func returnElementFromAngle(_ angle:CGFloat)->Int?{
        print(keyRange)
        print(angle)
        for i in 0..<keyRange.count{
            if keyRange[i].contains(angle){
                if let title = elements[i][.title] as! String?{
                    return i
                }
            }
        }
        return nil
    }
}
