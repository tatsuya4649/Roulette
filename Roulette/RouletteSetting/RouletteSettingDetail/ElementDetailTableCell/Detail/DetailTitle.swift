//
//  DetailTitle.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

protocol DetailSettingDelegate:AnyObject{
    func rouletteChangeTitle(_ cell:ElementDetailTableCell,_ title:String?)
    func rouletteChangeResult(_ cell:ElementDetailTableCell,_ result:RouletteResult?)
    func rouletteChangeSound(_ cell:ElementDetailTableCell,_ sound:RouletteSound)
    func rouletteChangeStopSound(_ cell:ElementDetailTableCell,_ sound:RouletteStopSound)
    func rouletteChangeArea(_ cell:ElementDetailTableCell,_ area:Float,_ totalArea:Float?)
    func rouletteClickColorButton(_ cell:ElementDetailTableCell,_ button:UIButton)
    func detailGetNowTotalValue(_ cell:ElementDetailTableCell,_ beforeValue:Float)
}

extension ElementDetailTableCell:UITextFieldDelegate{
    public func detailTitleSetting(_ title:String?){
        detailTitleTextField = UITextField(frame:CGRect(x:0,y:0,width:0.8*(self.frame.size.width - titleLabel.frame.maxX),height:30))
        detailTitleTextField.center = CGPoint(x:self.frame.size.width - 10 - detailTitleTextField.frame.size.width/2,y:self.frame.size.height/2)
        detailTitleTextField.layer.cornerRadius = 5
        detailTitleTextField.text = title
        detailTitleTextField.placeholder = "タイトルを入力..."
        detailTitleTextField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        detailTitleTextField.font = .systemFont(ofSize: 12, weight: .semibold)
        detailTitleTextField.leftView = UIView(frame: CGRect(x:0, y:0, width:10, height:0))
        detailTitleTextField.leftViewMode = UITextField.ViewMode.always
        detailTitleTextField.returnKeyType = .done
        detailTitleTextField.delegate = self
        detailTitleTextField.addDoneCancelToolbar()
        detailTitleTextField.addTarget(self, action: #selector(changeTitle), for: .editingChanged)
        self.contentView.addSubview(detailTitleTextField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func changeTitle(_ sender:UITextField){
        print("タイトルを変更しています。")
        guard let delegate = delegate else{return}
        delegate.rouletteChangeTitle(self,sender.text)        
    }
}
