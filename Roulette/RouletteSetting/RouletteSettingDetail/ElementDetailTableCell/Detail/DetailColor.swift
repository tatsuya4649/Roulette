//
//  DetailColor.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension ElementDetailTableCell{
    
    ///詳細設定のカラーを変更するために必要なセッティング
    public func detailColorButtonSetting(_ color:CGColor){
        detailColorButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        detailColorButton.layer.cornerRadius = detailColorButton.frame.size.height/2
        detailColorButton.backgroundColor = .white
        detailColorButton.layer.borderColor = UIColor.black.cgColor
        detailColorButton.layer.borderWidth = 0.1
        
        detailColorButtonLayer = CALayer()
        detailColorButtonLayer.bounds = CGRect(x: 0, y: 0, width: 0.8*detailColorButton.frame.size.width, height: 0.8*detailColorButton.frame.size.height)
        detailColorButtonLayer.position = CGPoint(x: detailColorButton.frame.size.width/2, y: detailColorButton.frame.size.height/2)
        detailColorButtonLayer.cornerRadius = detailColorButtonLayer.frame.size.height/2
        detailColorButtonLayer.backgroundColor = color
        detailColorButton.layer.addSublayer(detailColorButtonLayer)
        detailColorButton.center = CGPoint(x: self.frame.size.width - 10 - detailColorButton.frame.size.width/2, y: self.contentView.frame.size.height/2)
        detailColorButton.addTarget(self, action: #selector(detailColorButtonClick), for: .touchUpInside)
        self.contentView.addSubview(detailColorButton)
        
    }
    @objc func detailColorButtonClick(_ sender:UIButton){
        print("詳細設定のカラーボタンがクリックされました。")
        guard let delegate = delegate else{return}
        delegate.rouletteClickColorButton(self,sender)
    }
    
}
