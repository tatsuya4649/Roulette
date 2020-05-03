//
//  ElementTableCellBasicSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension ElementTableCell:UITextFieldDelegate{
    public func elementTableBasicSetting(){
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        basicTitle = UITextField(frame: CGRect(x: 0, y: 0, width: 0.8*(self.contentView.frame.size.width - 10), height: 30))
        basicTitle.placeholder = "ルーレットのタイトルを入力"
        basicTitle.font = .systemFont(ofSize: 15, weight: .semibold)
        basicTitle.layer.cornerRadius = 5
        basicTitle.leftView = UIView(frame: CGRect(x:0, y:0, width:10, height:0))
        basicTitle.leftViewMode = UITextField.ViewMode.always
        basicTitle.delegate = self
        basicTitle.returnKeyType = .done
        basicTitle.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        basicTitle.center = CGPoint(x: 10 + basicTitle.frame.size.width/2, y: self.frame.size.height/2)
        basicTitle.addTarget(self, action: #selector(changeBasicTitle), for: .editingChanged)
        self.contentView.addSubview(basicTitle)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == basicTitle{
        }else if textField == numberTextField || textField == nameTextField{
            guard let delegate = delegate else{return true}
            delegate.keyboardCheckTrueElement(self)
        }
        return true
    }
    @objc func changeBasicTitle(_ sender:UITextField){
        guard let title = sender.text else{return}
        guard let delegate = delegate else {return}
        //delegate.changeRouletteTitle(self,title)
    }
}
