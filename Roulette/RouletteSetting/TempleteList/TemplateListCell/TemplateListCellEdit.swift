//
//  TemplateListCellEdit.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/26.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

protocol TempleteCellDelegate:AnyObject {
    func templateDeleteButtonClick(_ cell:TempleteListCell,_ button:UIButton,_ id:String,_ title:String?)
}

extension TempleteListCell{
    ///テンプレート編集のときに削除を行うボタンを追加する関数
    public func addRemoveButton(){
        guard deleteButton == nil else{return}
        deleteButton = UIButton()
        deleteButton.setTitle(String.fontAwesomeIcon(name: .minusCircle), for: .normal)
        deleteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.sizeToFit()
        deleteButton.titleLabel?.sizeToFit()
        deleteButton.center = CGPoint(x: self.frame.size.width - deleteButton.frame.size.width/2, y: deleteButton.frame.size.height/2)
        deleteButton.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        self.contentView.addSubview(deleteButton)
    }
    ///テンプレート編集が終了したときに削除ボタンを削除を行う関数
    public func removeRemoveButton(){
        if deleteButton != nil{
            deleteButton.removeFromSuperview()
            deleteButton = nil
        }
    }
    @objc func deleteClick(_ sender:UIButton){
        print("テンプレートの削除ボタンがクリックされました")
        guard let delegate = delegate else{return}
        if let id = rouletteData[.id] as? String{
            let title : String? = rouletteData[.rouletteTitle] is String? ? rouletteData[.rouletteTitle] as! String? : nil
            delegate.templateDeleteButtonClick(self,sender,id,title)
        }
    }
}
