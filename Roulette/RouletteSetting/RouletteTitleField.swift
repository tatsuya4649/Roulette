//
//  RouletteTitleField.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension SettingViewController{
    public func rouletteTextFieldSetting(){
        rouletteTextField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.8, height: 40))
        rouletteTextField.font = .systemFont(ofSize: 15, weight: .bold)
        rouletteTextField.textColor = UIColor.black
        rouletteTextField.layer.cornerRadius = 5
        rouletteTextField.leftView = UIView(frame: CGRect(x:0, y:0, width:10, height:0))
        rouletteTextField.leftViewMode = UITextField.ViewMode.always
        rouletteTextField.placeholder = "ルーレットのタイトルを入力"
        rouletteTextField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        rouletteTextField.center = CGPoint(x: self.view.center.x, y: self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height + 10 + rouletteTextField.frame.size.height/2)
        self.view.addSubview(rouletteTextField)
    }
}
