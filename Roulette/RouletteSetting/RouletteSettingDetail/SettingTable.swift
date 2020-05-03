//
//  SettingTable.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

protocol RouletteSettingDetailVieControllerDelegate : AnyObject{
    func rouletteChangeTitle(_ cell:ElementTableCell,_ title:String?)
    func rouletteChangeResult(_ cell:ElementTableCell,_ result:RouletteResult?)
    func rouletteChangeSound(_ cell:ElementTableCell,_ sound:RouletteSound)
    func rouletteChangeStopSound(_ cell:ElementTableCell,_ sound:RouletteStopSound)
    func rouletteChangeArea(_ cell:ElementTableCell,_ area:Float,_ totalArea:Float?)
    func rouletteChangeElementBackground(_ cell:ElementTableCell,_ newColor:UIColor)
    func rouletteDetailGetNowTotalValue(_ cell:ElementTableCell,_ beforeValue:Float)
}

extension RouletteSettingDetailViewController:UITableViewDelegate,UITableViewDataSource,DetailSettingDelegate,UIPopoverPresentationControllerDelegate,ColorPickerViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementDetailTitleArray != nil ? elementDetailTitleArray.count : 0
    }
    
    func rouletteChangeTitle(_ cell: ElementDetailTableCell, _ title: String?) {
        self.title = "\(title != nil ? title! : "")の詳細設定"
        guard let title = title else{return}
        self.cell.nameTextField.text = "\(title)"
        guard let delegate = delegate else{return}
        delegate.rouletteChangeTitle(self.cell,title)
    }
    func rouletteChangeResult(_ cell: ElementDetailTableCell, _ result: RouletteResult?) {
        self.cell.hit = result
        guard let delegate = delegate else{return}
        delegate.rouletteChangeResult(self.cell,result)
    }
    func rouletteChangeSound(_ cell: ElementDetailTableCell, _ sound: RouletteSound) {
        
    }
    func rouletteChangeStopSound(_ cell: ElementDetailTableCell, _ sound: RouletteStopSound) {
        self.cell.stopSound = sound
        guard let delegate = delegate else{return}
        delegate.rouletteChangeStopSound(self.cell,sound)
    }
    func rouletteChangeArea(_ cell: ElementDetailTableCell, _ area: Float,_ totalArea:Float?){
        let changedNumber = self.totalArea + area
        if let totalArea = totalArea{
            if changedNumber > 100{
                cell.detailAreaTextField.text = "\(Int(totalArea))"
                self.totalArea = 100
            }else{
                self.totalArea = changedNumber
            }
            self.cell.numberTextField.text = "\(Int(totalArea))"
            self.cell.beforeValue = totalArea
            print(self.totalArea)
            print("{{{{{{{{{{{{{{")
            //self.totalArea = totalArea
        }else{

        }
        guard let delegate = delegate else{return}
        delegate.rouletteChangeArea(self.cell,area,totalArea)
    }
    
    func detailGetNowTotalValue(_ cell:ElementDetailTableCell,_ beforeValue:Float){
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
        guard let delegate = delegate else{return}
        delegate.rouletteDetailGetNowTotalValue(self.cell, beforeValue)
    }
    
    public func stopSoundStop(){
        if let cell = elementTable.cellForRow(at: IndexPath(row: 3, section: 0)) as? ElementDetailTableCell{
            cell.stopSound()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ElementDetailTableCell
        cell.frame.size.width = tableView.frame.size.width
        cell.delegate = self
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        cell.totalArea = totalArea
        switch elementDetailTitleArray[indexPath.item]{
        case ElementDetailString.title.rawValue:
            cell.titleSetting(titleText)
        case ElementDetailString.color.rawValue:
            cell.colorSetting(colorBackgroundColor)
        case ElementDetailString.area.rawValue:
            cell.beforeValue = beforeValue
            cell.areaSetting(areaText)
        //case ElementDetailString.sound.rawValue:
            //cell.soundSetting()
        case ElementDetailString.stopSound.rawValue:
            cell.stopSoundSetting(stopSound)
        case ElementDetailString.result.rawValue:
            cell.resultSetting(hit)
        default:break
        }
        return cell
    }
    
    public func elementTableSetting(){
        elementTable = UITableView(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height)), style: .plain)
        elementTable.delegate = self
        elementTable.dataSource = self
        elementTable.tableFooterView = UIView()
        elementTable.register(ElementDetailTableCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(elementTable)
        elementDetailTitleArray = Array<String>()
        elementDetailTitleArray = [
            ElementDetailString.title.rawValue,
            ElementDetailString.color.rawValue,
            ElementDetailString.area.rawValue,
            //ElementDetailString.sound.rawValue,
            ElementDetailString.stopSound.rawValue,
            ElementDetailString.result.rawValue,
        ]
    }
    func rouletteClickColorButton(_ cell: ElementDetailTableCell, _ button: UIButton) {
        colorPickerViewController = ColorPickerViewController()
        colorPickerViewController.detailCell = cell
        colorPickerViewController.delegate = self
        colorPickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        colorPickerViewController.preferredContentSize = CGSize(width: 300,height: 400)
        let popoverController = colorPickerViewController.popoverPresentationController
        popoverController?.delegate = self
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popoverController?.sourceView = button
        popoverController?.sourceRect = button.bounds
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    func onColorChangedDetail(newColor: UIColor, _ cell: ElementDetailTableCell) {
        guard let layer = cell.detailColorButtonLayer else{return}
        layer.backgroundColor = newColor.cgColor
        self.cell.colorButtonLayer.backgroundColor = newColor.cgColor
        guard let delegate = delegate else{return}
        delegate.rouletteChangeElementBackground(self.cell,newColor)
    }
    
    func onColorChanged(newColor: UIColor, _ cell: ElementTableCell) {
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
