//
//  ElementTable.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

extension SettingViewController:UITableViewDelegate,UITableViewDataSource,ElementTableCellDelegate,ColorPickerViewDelegate,UIPopoverPresentationControllerDelegate,RouletteHeaderViewDelegate,RouletteFooterViewDelegate,RouletteSettingDetailVieControllerDelegate{
    
    //ルーレットの回転が終了したとに呼び出されるデリゲートメソッド
    //ルーレット画像を引数に持ち、ユーザーにシェアを促す
    func toRecommendShare(_ rouletteImage: UIImage) {
        
    }
    
    ///ルーレットが回転を始めたときに呼び出されるデリゲートメソッド
    func startRouletteAnimation() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        addTemplateButton.alpha = 0
        addSettingButton.alpha = 0
        //elementCellUserEnabled(false)
    }
    ///ルーレットの回転が終わったときに呼び出されるデリゲートメソッド
    func stopRouletteAnimation() {
        settingNavi()
        addTemplateButton.alpha = 1
        addSettingButton.alpha = 1
        elementCellUserEnabled(true)
    }
    
    private func elementCellUserEnabled(_ bool:Bool){
        elementTable.allowsSelection = bool
        elementTable.isUserInteractionEnabled = bool
        elementTable.isScrollEnabled = bool
        for i in 0..<tableCellNumber{
            if let cell = elementTable.cellForRow(at: IndexPath(row: i, section: 0)) as? ElementTableCell{
                cell.colorButton.isUserInteractionEnabled = bool
                cell.numberTextField.isUserInteractionEnabled = bool
                cell.nameTextField.isUserInteractionEnabled = bool
            }
        }
    }
    func rouletteVieChange() -> RouletteViewController{
        rouletteViewController = RouletteViewController()
        rouletteViewController.elementFontColor = (rouletteElementFontColor != nil ? rouletteElementFontColor!.cgColor : UIColor.black.cgColor)
        getElementEnum(completion: nil)
        print(elements)
        
        self.rouletteViewController.elements = self.elements
        self.rouletteViewController.rouletteSound = self.rouletteSound
        self.rouletteViewController.rouletteSpin = self.rouletteSpin
        self.rouletteViewController.rouletteSpeed = self.rouletteSpeed
        self.rouletteViewController.rouletteTime = self.rouletteTime
        self.rouletteViewController.view.backgroundColor = self.rouletteBackgroundColor != nil ? self.rouletteBackgroundColor! : .white
        self.rouletteViewController.title = self.rouletteTitle != nil ? self.rouletteTitle! : "ルーレット"
        self.rouletteViewController.rouletteTitle = self.rouletteTitle
        self.rouletteViewController.rouletteBackgroundColor = self.rouletteBackgroundColor
        self.rouletteViewController.view.frame = self.tableHeaderRoulette.contentView.bounds
        
        return rouletteViewController
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableHeaderRoulette = RouletteHeaderView()
        tableHeaderRoulette.delegate = self
        return tableHeaderRoulette
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.height*0.6
    }
    //func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //tableFooterRoulette = RouletteFooterView()
        //tableFooterRoulette.delegate = self
        //return tableFooterRoulette
    //}
    
    //func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //return 50
    //}
    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return sections[section]
    //}
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellNumber != nil ? tableCellNumber : 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0{
            return true
        }else{
            return false
        }
    }
    func changeRouletteElementTitle(_ cell: ElementTableCell, _ title: String) {
        //if title.count > 0{
            //self.title = "\(title)のセッティング"
        //}else{
            //self.title = "ルーレットセッティング"
        //}
        //self.rouletteTitle = title
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let _ = indexCell[number]{
                        indexCell[number]![.title] = title
                    }
                }
            }
        }
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && (editingStyle == .delete) {
            print("要素を消しました")
            tableCellNumber -= 1
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            if indexPath.row != indexCell.keys.max(){
                indexCell[indexPath.row] = nil
            }
            for key in indexCell.keys.sorted(){
                if key > indexPath.row{
                    indexCell[key-1] = indexCell[key]
                }
            }
            if let max = indexCell.keys.max(){
                indexCell[max] = nil
            }
            print(indexCell.keys)
            print(indexCell)
            getElementEnum(completion:nil)
            rouletteViewController.elements = elements
            rouletteViewController.changeTheLayer()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ElementTableCell
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        cell.totalArea = totalArea
        cell.setUp(self.view.frame.size.width)
        cell.delegate = self
        return cell
    }
    func getNowTotalValue(_ cell: ElementTableCell,_ beforeValue:Float) {
        print("おいこれ??？")
        print(beforeValue)
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
    func areaChangeGetter(_ cell: ElementTableCell, _ area: Float,_ totalArea : Float?) {
        print(self.totalArea)
        if self.totalArea == nil{
            self.totalArea = Float(0)
        }
        let changedNumber = self.totalArea + area
        print(changedNumber)
        
        if let totalArea = totalArea{
            if changedNumber > 100{
                cell.numberTextField.text = "\(Int(totalArea))"
                self.totalArea = 100
            }else{
                self.totalArea = changedNumber
            }
            print(totalArea)
            //self.totalArea = totalArea
            for number in 0..<tableCellNumber{
                if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                    if cell == c{
                        if let _ = indexCell[number]{
                            indexCell[number]![.rate] = Float(totalArea)
                        }
                    }
                }
            }
        }else{
            for number in 0..<tableCellNumber{
                if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                    if cell == c{
                        if let _ = indexCell[number]{
                            let element : Dictionary<ElementEnum,Any?> = [
                                .rate : nil
                            ]
                            indexCell[number]![.rate] = element[.rate]
                        }
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    
    func onColorChangedDetail(newColor: UIColor, _ cell: ElementDetailTableCell) {
        
    }
    
    func onColorChanged(newColor: UIColor, _ cell: ElementTableCell) {
        cell.colorButtonLayer.backgroundColor = newColor.cgColor
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let _ = indexCell[number]{
                        indexCell[number]![.color] = newColor.cgColor
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
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
    func rouletteChangeTitle(_ cell:ElementTableCell,_ title:String?){
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let title = title{
                        if let _ = indexCell[number]{
                            indexCell[number]![.title] = title
                        }
                    }else{
                        let element : Dictionary<ElementEnum,Any?> = [
                            .title : nil
                        ]
                        indexCell[number]![.rate] = element[.title]
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    func rouletteChangeResult(_ cell:ElementTableCell,_ result:RouletteResult?){
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let result = result{
                        if let _ = indexCell[number]{
                            indexCell[number]![.hit] = result
                        }
                    }else{
                        let element : Dictionary<ElementEnum,Any?> = [
                            .hit : nil
                        ]
                        indexCell[number]![.hit] = element[.hit]
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    func rouletteChangeSound(_ cell:ElementTableCell,_ sound:RouletteSound){

    }
    func rouletteChangeStopSound(_ cell:ElementTableCell,_ sound:RouletteStopSound){
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let _ = indexCell[number]{
                        indexCell[number]![.stopSound] = sound
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    func rouletteChangeArea(_ cell:ElementTableCell,_ area:Float,_ totalArea:Float?){
        if self.totalArea == nil{
            self.totalArea = Float(0)
        }
        print("***************")
        print(self.totalArea)
        print(area)
        let changedNumber = self.totalArea + area
        if let totalArea = totalArea{
            if changedNumber > 100{
                cell.numberTextField.text = "\(Int(totalArea))"
                self.totalArea = 100
            }else{
                self.totalArea = changedNumber
            }
            //self.totalArea = totalArea
            for number in 0..<tableCellNumber{
                if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                    if cell == c{
                        if let _ = indexCell[number]{
                            indexCell[number]![.rate] = Float(totalArea)
                        }
                    }
                }
            }
        }else{
            for number in 0..<tableCellNumber{
                if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                    if cell == c{
                        if let _ = indexCell[number]{
                            let element : Dictionary<ElementEnum,Any?> = [
                                .rate : nil
                            ]
                            indexCell[number]![.rate] = element[.rate]
                        }
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    func rouletteDetailGetNowTotalValue(_ cell: ElementTableCell, _ beforeValue: Float) {
        print("?????????????????")
        print(beforeValue)
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
    
    func rouletteChangeElementBackground(_ cell:ElementTableCell,_ newColor:UIColor){
        for number in 0..<tableCellNumber{
            if let c = elementTable.cellForRow(at: IndexPath(row: number, section: 0)){
                if cell == c{
                    if let _ = indexCell[number]{
                        indexCell[number]![.color] = newColor.cgColor
                    }
                }
            }
        }
        guard let _ = rouletteViewController else{return}
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.changeTheLayer()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ElementTableCell
        let title = cell.nameTextField.text
        detailSetting = RouletteSettingDetailViewController()
        detailSetting.title = "\(title != nil ? title! : "")の詳細設定"
        detailSetting.totalArea = totalArea
        if cell.numberTextField.text != nil{
            if let number = Float(cell.numberTextField.text!) {
                detailSetting.beforeValue = number
            }
        }
        detailSetting.cell = cell
        detailSetting.titleText = cell.nameTextField.text
        detailSetting.colorBackgroundColor = cell.colorButtonLayer.backgroundColor
        detailSetting.areaText = cell.numberTextField.text
        detailSetting.hit = cell.hit
        detailSetting.stopSound = cell.stopSound
        detailSetting.delegate = self
        guard let navi = self.navigationController else{return}
        navi.pushViewController(detailSetting, animated: true)
    }
    
    public func settingElementTable(){
        sections = [
            "ルーレット項目設定"
        ]
        //常時2つ以上の要素は出現させておく
        tableCellNumber = Int(2)
        indexCell = Dictionary<Int,Dictionary<ElementEnum,Any?>>()
        elementTable = UITableView(frame:CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height)),style: .plain)
        elementTable.tableFooterView = UIView()
        elementTable.estimatedSectionHeaderHeight = 0
        elementTable.delegate = self
        elementTable.dataSource = self
        elementTable.register(ElementTableCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(elementTable)
        elementTable.reloadData()
        for i in 0..<tableCellNumber{
            if let cell = elementTable.cellForRow(at: IndexPath(row: i, section: 0)) as? ElementTableCell{
                indexCell[i] = [
                    .title : cell.nameTextField.text,
                    .color : cell.colorButtonLayer.backgroundColor,
                    .rate : ( cell.numberTextField.text!.count != 0 ? Float(cell.numberTextField.text!) : nil),
                    .stopSound : cell.stopSound,
                    .hit : cell.hit != nil ? cell.hit : RouletteResult.none
                ]
            }
        }
    }
    func keyboardCheckTrueElement(_ cell: ElementTableCell) {
        guard let _ = tableCellNumber else{return}
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
