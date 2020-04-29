//
//  SettingViewControllerBasicDetailDelegate.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension SettingViewController:RouletteBasicSettingDelegate{
    
    public func goToDetailBasicSetting(_ cell:ElementTableCell){
        basicSettingViewController = RouletteBasicSettingViewController()
        let title = cell.basicTitle.text
        if title == nil{
            basicSettingViewController.title = "ルーレットの基本設定"
        }else{
            if title!.count == 0{
                basicSettingViewController.title = "ルーレットの基本設定"
            }else{
                basicSettingViewController.title = "\(title!)の基本設定"
            }
        }
        basicSettingViewController.rouletteSound = rouletteSound
        basicSettingViewController.rouletteSpin = rouletteSpin
        basicSettingViewController.rouletteSpeed = rouletteSpeed
        basicSettingViewController.rouletteTime = rouletteTime
        basicSettingViewController.rouletteTitle = title
        basicSettingViewController.delegate = self
        guard let navi = self.navigationController else{return}
        navi.pushViewController(basicSettingViewController, animated: true)
    }
    func changeTitle(_ title:String){
        if title.count > 0{
            self.title = "\(title)のセッティング"
        }else{
            self.title = "ルーレットセッティング"
        }
        let cell = elementTable.cellForRow(at: IndexPath(row: 0, section: 0)) as? ElementTableCell
        if let textFiled = cell?.basicTitle{
            textFiled.text = title
        }
    }
    func changeBackgroundColor(_ rouletteBackgroundColor: UIColor) {
        print("ルーレットの背景色が変更されました。")
        self.rouletteBackgroundColor = rouletteBackgroundColor
    }
    func chnageElementFontColor(_ rouletteElementFontColor: UIColor) {
        print("ルーレットの項目の文字色が変更されました。")
        self.rouletteElementFontColor = rouletteElementFontColor
    }
    func changeRouletteSound(_ sound: RouletteSound) {
        print("ルーレットのサウンドが変更されました。")
        self.rouletteSound = sound
    }
    func changeRouletteSpin(_ spin: RouletteSpin) {
        print("ルーレットの回転方法が変更されました。")
        self.rouletteSpin = spin
    }
    func changeRouletteSpeed(_ speed: Float) {
        print("ルーレットの回転スピードが変更されました。")
        self.rouletteSpeed = speed
    }
    func changeRouletteTime(_ time: Float) {
        print("ルーレットの回転時間が変更されました。")
        self.rouletteTime = time
    }
}
