//
//  ArrowDown.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension RouletteViewController{
    public func arrowDownSetting(){
        guard let rouletteView = rouletteView else { return }
        arrowDown = UILabel()
        arrowDown.text = String.fontAwesomeIcon(name: .sortDown)
        arrowDown.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        arrowDown.textColor = .black
        arrowDown.sizeToFit()
        arrowDown.center = CGPoint(x: self.view.frame.size.width/2, y: rouletteView.frame.minY-(2+arrowDown.frame.size.height/2))
        self.view.addSubview(arrowDown)
    }
}
