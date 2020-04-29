//
//  RouletteView.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

class RouletteView : UIView{
    var elements : Array<Dictionary<ElementEnum,Any?>>!
    var nowAngle : CGFloat!
    var keyRange : Array<Range<CGFloat>>!
    var elementFontColor : CGColor!
    var fontSize : CGFloat!
    init(frame:CGRect,elements:Array<Dictionary<ElementEnum,Any?>>,fontColor:CGColor){
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.size.height/2
        self.elements = elements
        self.elementFontColor = fontColor
        settingElementLayer()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}