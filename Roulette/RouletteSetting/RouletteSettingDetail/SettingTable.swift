//
//  SettingTable.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension RouletteSettingDetailViewController:UITableViewDelegate,UITableViewDataSource,DetailSettingDelegate,UIPopoverPresentationControllerDelegate,ColorPickerViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementDetailTitleArray != nil ? elementDetailTitleArray.count : 0
    }
    
    func rouletteChangeTitle(_ cell: ElementDetailTableCell, _ title: String?) {
        self.title = "\(title != nil ? title! : "")の詳細設定"
        guard let title = title else{return}
        self.cell.nameTextField.text = "\(title)"
    }
    func rouletteChangeResult(_ cell: ElementDetailTableCell, _ result: RouletteResult?) {
        self.cell.hit = result
    }
    func rouletteChangeSound(_ cell: ElementDetailTableCell, _ sound: RouletteSound) {
        
    }
    func rouletteChangeStopSound(_ cell: ElementDetailTableCell, _ sound: RouletteStopSound) {
        self.cell.stopSound = sound
    }
    func rouletteChangeArea(_ cell: ElementDetailTableCell, _ area: Int?,_ totalArea:Float){
        guard let area = area else{return}
        self.cell.numberTextField.text = "\(area)"
        self.totalArea = totalArea
        print(totalArea)
        
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
    }
    
    func onColorChanged(newColor: UIColor, _ cell: ElementTableCell) {
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
