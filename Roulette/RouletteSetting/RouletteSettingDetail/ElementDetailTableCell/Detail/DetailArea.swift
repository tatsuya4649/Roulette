//
//  DetailArea.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension ElementDetailTableCell{
    public func detailAreaSetting(_ area:String?){
        detailAreaPercent = UILabel()
        detailAreaPercent.text = "%"
        detailAreaPercent.font = .systemFont(ofSize: 12, weight: .light)
        detailAreaPercent.sizeToFit()
        detailAreaPercent.textColor = .black
        detailAreaPercent.center = CGPoint(x: self.frame.size.width - 10 - detailAreaPercent.frame.size.width/2, y: self.contentView.frame.size.height/2)
        self.contentView.addSubview(detailAreaPercent)
        detailAreaTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        detailAreaTextField.font = .systemFont(ofSize: 12, weight: .semibold)
        detailAreaTextField.text = area
        detailAreaTextField.placeholder = "0~100"
        detailAreaTextField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        detailAreaTextField.layer.cornerRadius = 5
        detailAreaTextField.keyboardType = .numberPad
        detailAreaTextField.addDoneCancelToolbar()
        detailAreaTextField.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        detailAreaTextField.leftViewMode = UITextField.ViewMode.always
        detailAreaTextField.center = CGPoint(x: detailAreaPercent.frame.minX - 10 - detailAreaTextField.frame.size.width/2, y: self.contentView.frame.size.height/2)
        detailAreaTextField.addTarget(self, action: #selector(detailAreaTextInput), for: .editingChanged)
        self.contentView.addSubview(detailAreaTextField)
        
        //全体の数字からこのセルの数字を引き算を初期設定としておこなう
        if totalArea != nil{
            if detailAreaTextField.text != nil{
                if let number = Float(detailAreaTextField.text!) {
                    totalArea -= number
                }
            }
        }else{
            totalArea = Float(0)
        }
    }
    @objc func detailAreaTextInput(_ sender:UITextField){
        guard let delegate = delegate else{return}
        delegate.detailGetNowTotalValue(self, beforeValue != nil ? beforeValue : 0)
        guard let text = sender.text else{return}
        if var number = Int(text) {
            number =  Int(totalAreaCheck(Float(number)))
            if number > 100{
                number = 100
            }else if number < 0{
                number = 0
            }
            sender.text = "\(number)"
            delegate.rouletteChangeArea(self, Float(number),Float(number))
            beforeValue = Float(number)
        }else{
            sender.text = nil
            delegate.rouletteChangeArea(self, 0,nil)
            beforeValue = nil
        }
    }
    private func totalAreaCheck(_ number:Float)->Float{
        let changedNumber = totalArea + number
        if changedNumber > 100{
            detailAreaTextField.text = "\(100 - totalArea)"
            return 100 - totalArea
        }else{
            return number
        }
    }
}
