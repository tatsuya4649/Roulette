//
//  TableSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension RouletteBasicSettingViewController:UITableViewDelegate,UITableViewDataSource,BasicDetailCellDelegate,ColorPickerViewDelegate,UIPopoverPresentationControllerDelegate{
    
        
    //セクションごとのアイテムの数を返すデリゲートメソッド(必須)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case RouletteBasicSettingSection.title.rawValue:
            return 1
        case RouletteBasicSettingSection.roulette.rawValue:
            return 3
        case RouletteBasicSettingSection.design.rawValue:
            return 2
        case RouletteBasicSettingSection.sound.rawValue:
            return 1
        default:break
        }
        return 0
    }
    //セクションごとのタイトルを返すデリゲートメソッド
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    //セクション数を返すデリゲートメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections != nil ? sections.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! BasicDetailCellTableViewCell
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        cell.frame.size.width = tableView.frame.size.width
        cell.setting(indexPath,rouletteTitle,rouletteElementFontColor,rouletteBackgroundColor, rouletteSound,rouletteSpeed,rouletteTime,rouletteSpin)
        cell.delegate = self
        return cell
    }
    public func stopSound(){
        if let cell = basicTable.cellForRow(at: IndexPath(row: 0, section: RouletteBasicSettingSection.sound.rawValue)) as? BasicDetailCellTableViewCell{
            cell.stopSound()
        }
    }
    public func basicTableViewSetting(){
        sections =  [
            "タイトル",
            "ルーレット",
            "デザイン",
            "サウンド"
        ]
        basicTable = UITableView(frame: CGRect(x: 0, y: (self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height), width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height)), style: .grouped)
        basicTable.dataSource = self
        basicTable.delegate = self
        basicTable.estimatedSectionHeaderHeight = 0
        basicTable.estimatedRowHeight = 50
        basicTable.rowHeight = UITableView.automaticDimension
        basicTable.tableFooterView = UIView()
        basicTable.register(BasicDetailCellTableViewCell.self, forCellReuseIdentifier: "basicCell")
        self.view.addSubview(basicTable)
    }
    
    func changeRouletteTitle(_ cell:BasicDetailCellTableViewCell,_ title:String){
        if title.count > 0{
            self.title = "\(title)の基本設定"
        }else{
            self.title = "ルーレットの基本設定"
        }
        guard let delegate = delegate else{return}
        delegate.changeTitle(title)
    }
    func changeRouletteSound(_ cell: BasicDetailCellTableViewCell, _ sound: RouletteSound) {
        guard let delegate = delegate else{return}
        delegate.changeRouletteSound(sound)
        self.rouletteSound = sound
    }
    func changeRouletteSpin(_ spin: RouletteSpin) {
        guard let delegate = delegate else{return}
        delegate.changeRouletteSpin(spin)
        self.rouletteSpin = spin
    }
    func clickDesignButton(_ button:ColorButton,_ cell: BasicDetailCellTableViewCell, _ design: BasicSettingColor) {
        colorPicker = ColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.basicCell = cell
        colorPicker.design = design
        colorPicker.modalPresentationStyle = UIModalPresentationStyle.popover
        colorPicker.preferredContentSize = CGSize(width: 300,height: 400)
        let popoverController = colorPicker.popoverPresentationController
        popoverController?.delegate = self
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popoverController?.sourceView = button
        popoverController?.sourceRect = button.bounds
        self.present(colorPicker, animated: true, completion: nil)
    }
    func onColorChangedBasic(newColor:UIColor,_ cell:BasicDetailCellTableViewCell,_ design:String){
        switch BasicSettingColor(rawValue:design){
        case .background:
            cell.backgroundColorButton.backgroundLayer.backgroundColor = newColor.cgColor
            self.rouletteBackgroundColor = newColor
            guard let delegate = delegate else{return}
            delegate.changeBackgroundColor(newColor)
        case .elementFont:
            cell.fontColorButton.backgroundLayer.backgroundColor = newColor.cgColor
            self.rouletteElementFontColor = newColor
            guard let delegate = delegate else{return}
            delegate.chnageElementFontColor(newColor)
        default:break
        }
    }
    func chnageRouletteSpin(_ speed: Float) -> RouletteSpin? {
        guard let delegate = delegate else{return nil}
        delegate.changeRouletteSpeed(speed)
        self.rouletteSpeed = speed
        return self.rouletteSpin
    }
    func changeRouletteTime(_ time: Float) {
        guard let delegate = delegate else{return}
        delegate.changeRouletteTime(time)
        self.rouletteTime = time
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
