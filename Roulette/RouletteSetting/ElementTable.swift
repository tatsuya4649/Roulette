//
//  ElementTable.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension SettingViewController:UITableViewDelegate,UITableViewDataSource,ElementTableCellDelegate,ColorPickerViewDelegate,UIPopoverPresentationControllerDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return tableCellNumber != nil ? tableCellNumber : 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return false
        }else{
           return true
        }
    }
    func changeRouletteTitle(_ cell: ElementTableCell, _ title: String) {
        if title.count > 0{
            self.title = "\(title)のセッティング"
        }else{
            self.title = "ルーレットセッティング"
        }
        self.rouletteTitle = title
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && (editingStyle == .delete) {
            print("要素を消しました")
            tableCellNumber -= 1
            removeCellCheck()
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ElementTableCell
            for i in cell.contentView.subviews{
                i.removeFromSuperview()
            }
            cell.frame.size.width = tableView.frame.size.width
            cell.elementTableBasicSetting()
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ElementTableCell
            for i in cell.contentView.subviews{
                i.removeFromSuperview()
            }
            cell.totalArea = totalArea
            cell.setUp(self.view.frame.size.width)
            cell.delegate = self
            return cell
        }
    }
    func getNowTotalValue(_ cell: ElementTableCell,_ beforeValue:Float) {
        if totalArea == nil{
            totalArea = Float(0)
            cell.totalArea = Float(0)
        }else{
            self.totalArea! -= beforeValue
            if self.totalArea < 0{
                self.totalArea = 0
            }
            cell.totalArea = self.totalArea!
        }
    }
    func areaChangeGetter(_ cell: ElementTableCell, _ area: Float,_ totalArea : Float) {
        if self.totalArea == nil{
            self.totalArea = Float(0)
        }
        let changedNumber = self.totalArea + area
        if changedNumber > 100{
            cell.numberTextField.text = "\(Int(totalArea))"
            self.totalArea = 100
        }else{
            self.totalArea = changedNumber
        }
        print(self.totalArea)
        //self.totalArea = totalArea
    }
    
    func onColorChangedDetail(newColor: UIColor, _ cell: ElementDetailTableCell) {
        
    }
    
    func onColorChanged(newColor: UIColor, _ cell: ElementTableCell) {
        cell.colorButtonLayer.backgroundColor = newColor.cgColor
    }
    func colorButtonClick(_ cell: ElementTableCell, _ button: UIButton) {
        colorPickerViewController = ColorPickerViewController()
        colorPickerViewController.cell = cell
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        colorPickerViewController.preferredContentSize = CGSize(width: 300,height: 400)
        let popoverController = colorPickerViewController.popoverPresentationController
        popoverController?.delegate = self
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection()
        popoverController?.sourceView = button
        popoverController?.sourceRect = button.bounds
        
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ElementTableCell
        if indexPath.section == 0{
            goToDetailBasicSetting(cell)
        }else{
            let title = cell.nameTextField.text
            detailSetting = RouletteSettingDetailViewController()
            detailSetting.title = "\(title != nil ? title! : "")の詳細設定"
            detailSetting.totalArea = totalArea
            detailSetting.cell = cell
            detailSetting.titleText = cell.nameTextField.text
            detailSetting.colorBackgroundColor = cell.colorButtonLayer.backgroundColor
            detailSetting.areaText = cell.numberTextField.text
            detailSetting.hit = cell.hit
            detailSetting.stopSound = cell.stopSound
            guard let navi = self.navigationController else{return}
            navi.pushViewController(detailSetting, animated: true)
        }
    }
    
    public func settingElementTable(){
        sections = [
            "基本設定",
            "ルーレット項目設定"
        ]
        tableCellNumber = Int(0)
        elementTable = UITableView(frame:CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height)),style: .grouped)
        elementTable.tableFooterView = UIView()
        elementTable.estimatedSectionHeaderHeight = 0
        elementTable.delegate = self
        elementTable.dataSource = self
        elementTable.register(ElementTableCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(elementTable)
    }
    func keyboardCheckTrueTitle() {
        self.keyBoardCheck = Bool(true)
    }
    func keyboardCheckTrueElement(_ cell: ElementTableCell) {
        guard let tableCellNumber = tableCellNumber else{return}
        let number = tableCellNumber
        var bool = Bool(false)
        for count in 0..<number{
            let checkCell = elementTable.cellForRow(at: IndexPath(row: count, section: 1))
            if checkCell == cell && count < 5{
                bool = Bool(true)
            }
        }
        print(bool)
        
        if bool{
            self.keyBoardCheck = Bool(true)
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
