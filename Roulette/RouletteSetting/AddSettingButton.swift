//
//  AddSettingButton().swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

extension SettingViewController{
    public func settingPlusButton(){
        addSettingButton = UIButton()
        addSettingButton.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        addSettingButton.setTitleColor(.gray, for: .normal)
        addSettingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        addSettingButton.sizeToFit()
        addSettingButton.titleLabel?.sizeToFit()
        addSettingButton.titleLabel?.textAlignment = .center
        addSettingButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        addSettingButton.layer.cornerRadius = addSettingButton.frame.size.height/2
        addSettingButton.clipsToBounds = true
        addSettingButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - 30 - addSettingButton.frame.size.height/2)
        addSettingButton.addTarget(self, action: #selector(addSettingButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(addSettingButton)
    }

    ///プラスボタンを押すたびに要素数を1つずつ増やしていく
    @objc func addSettingButtonClick(_ sender:UIButton){
        print("ルーレット要素を追加します。")
        guard let _ = tableCellNumber else{return}
        sender.isUserInteractionEnabled = false
        tableCellNumber += 1
        elementTable.beginUpdates()
        elementTable.insertRows(at: [IndexPath(row: tableCellNumber-1, section: 0)],
                                  with: .automatic)
        elementTable.endUpdates()
        if let cell = elementTable.cellForRow(at: IndexPath(row: tableCellNumber-1, section: 0)) as? ElementTableCell{
            indexCell[tableCellNumber-1] =
            [
                .title : cell.nameTextField.text,
                .color : cell.colorButtonLayer.backgroundColor,
                .rate : ( cell.numberTextField.text!.count != 0 ? Float(cell.numberTextField.text!) : nil),
                .stopSound : cell.stopSound,
                .hit : cell.hit != nil ? cell.hit : RouletteResult.none
            ]
        }
        //print(elementTable.cellForRow(at: IndexPath(row: tableCellNumber-1, section: 0)))
        elementTable.scrollToRow(at: IndexPath(row: tableCellNumber-1, section: 0), at: .bottom, animated: true)
        elementTable.contentOffset.y = elementTable.contentSize.height - elementTable.frame.size.height
        
        if rouletteViewController != nil{
            //print(elements.count)
            getElementEnum(completion: {[weak self] in
                guard let _ = self else{return}
                //print(self!.elements.count)
                self!.rouletteViewController.elements = self!.elements
                self!.rouletteViewController.changeTheLayer()
                sender.isUserInteractionEnabled = true
            })
        }
    }
}
