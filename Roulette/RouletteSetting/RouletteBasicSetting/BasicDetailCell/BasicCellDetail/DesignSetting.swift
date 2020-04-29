//
//  DesignSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum BasicSettingColor:String{
    case background = "background"
    case elementFont = "elementFont"
}

extension BasicDetailCellTableViewCell{
    public func backGroundDesign(_ backgroundColor:UIColor?){
        cellTitleSetting("背景色")
        backgroundColorButton = ColorButton(frame:CGRect(x: 0, y: 0, width: 30, height: 30),backgroundColor:backgroundColor != nil ?  backgroundColor!.cgColor : UIColor.white.cgColor)
        backgroundColorButton.center = CGPoint(x: self.frame.size.width - 20 - backgroundColorButton.frame.size.width/2, y: self.frame.size.height/2)
        backgroundColorButton.addTarget(self, action: #selector(colorClick), for: .touchUpInside)
        self.contentView.addSubview(backgroundColorButton)
    }
    public func fontDesign(_ fontColor:UIColor?){
        cellTitleSetting("項目のフォントカラー")
        fontColorButton = ColorButton(frame:CGRect(x: 0, y: 0, width: 30, height: 30),backgroundColor:fontColor != nil ?  fontColor!.cgColor : UIColor.black.cgColor)
        fontColorButton.center = CGPoint(x: self.frame.size.width - 20 - fontColorButton.frame.size.width/2, y: self.frame.size.height/2)
        fontColorButton.addTarget(self, action: #selector(colorClick), for: .touchUpInside)
        self.contentView.addSubview(fontColorButton)
    }
    @objc func colorClick(_ sender:UIButton){
        if sender == backgroundColorButton{
            guard let delegate = delegate else { return }
            delegate.clickDesignButton(backgroundColorButton,self,.background)
        }else if sender == fontColorButton{
            guard let delegate = delegate else { return }
            delegate.clickDesignButton(fontColorButton,self,.elementFont)
        }
    }
}
