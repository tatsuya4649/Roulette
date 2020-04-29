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
        addSettingButton.setTitleColor(.white, for: .normal)
        addSettingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        addSettingButton.backgroundColor = .lightGray
        addSettingButton.sizeToFit()
        addSettingButton.titleLabel?.sizeToFit()
        addSettingButton.titleLabel?.textAlignment = .center
        addSettingButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        addSettingButton.layer.cornerRadius = addSettingButton.frame.size.height/2
        addSettingButton.clipsToBounds = true
        addSettingButton.center = CGPoint(x: self.view.frame.size.width - 20 - addSettingButton.frame.size.width/2, y: self.view.frame.size.height - 30 - addSettingButton.frame.size.height/2)
        addSettingButton.addTarget(self, action: #selector(addSettingButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(addSettingButton)
    }
    ///プラスボタンを押すたびに要素数を1つずつ増やしていく
    @objc func addSettingButtonClick(_ sender:UIButton){
        print("ルーレット要素を追加します。")
        guard let _ = tableCellNumber else{return}
        tableCellNumber += 1
        elementTable.beginUpdates()
        elementTable.insertRows(at: [IndexPath(row: tableCellNumber-1, section: 1)],
                                  with: .automatic)
        elementTable.endUpdates()
        if tableCellNumber > 0{
            addingNaviButton()
        }else{
            removeNaviButton()
        }
    }
}
