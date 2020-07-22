//
//  TitleSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension BasicDetailCellTableViewCell:UITextFieldDelegate{
    public func titleTextSetting(_ title:String?){
        titleText = UITextField(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 30))
        titleText.placeholder = "ルーレットのタイトルを入力"
        titleText.text = title
        titleText.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        titleText.delegate = self
        titleText.returnKeyType = .done
        titleText.font = .systemFont(ofSize: 12,weight:.semibold)
        titleText.layer.cornerRadius = 5
        titleText.leftView = UIView(frame: CGRect(x:0, y:0, width:10, height:0))
        titleText.leftViewMode = UITextField.ViewMode.always
        titleText.addDoneCancelToolbar()
        titleText.center = CGPoint(x: 10 + titleText.frame.size.width/2, y: self.contentView.frame.size.height/2)
        titleText.addTarget(self, action: #selector(changeRouletteTitle), for: .editingChanged)
        self.contentView.addSubview(titleText)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func changeRouletteTitle(_ sender:UITextField){
        guard let delegate = delegate else{return}
        guard let title = sender.text else{return}
        delegate.changeRouletteTitle(self,title)
    }
}
