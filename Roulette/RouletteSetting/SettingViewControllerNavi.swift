//
//  NavigationSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/24.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift
import SPAlert
import CoreData
import FloatingPanel

extension SettingViewController:FloatingPanelControllerDelegate,TempleteListDelegate{
    
    public func settingNavi(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(getTemplete))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .cog, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)),style: .plain, target: self,action: #selector(goBasicSetting(_:)))
    }
    
    @objc func getTemplete(_ sender:UIBarButtonItem){
        rouletteData = Array<Roulette>()
        let preFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Roulette")
        do{
            rouletteData = try rouletteManageObjectContext.fetch(preFetch) as? Array<Roulette>
        }catch{
            print("データベースからデータの取り出しに失敗しました。")
        }
        if rouletteData.count == 0{
            SPAlert.present(title: "テンプレートがありません", message: nil, preset: .exclamation)
        }else{
            //テンプレート一覧がまだ追加されていないときの処理(テンプレート一覧を追加する)
            if fpc == nil || addPanel == nil{
                settingTempleteRoulette()
                //テンプレート一覧がすでに出ているので仕舞う処理
            }else{
                fpc.removePanelFromParent(animated: true)
                addPanel = nil
            }
        }
    }
    private func settingTempleteRoulette(){
        fpc = FloatingPanelController()
        fpc.surfaceView.cornerRadius = 10
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        templeteViewController = TempleteListViewController()
        templeteViewController.delegate = self
        templeteViewController.rouletteData = rouletteData
        fpc.set(contentViewController: UINavigationController(rootViewController: templeteViewController))
        fpc.track(scrollView: templeteViewController.collectionView)
        fpc.addPanel(toParent: self, belowView: nil, animated: true)
        addPanel = Bool(true)
    }
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        print(vc.surfaceView.frame)
        templeteViewController.surfaceHeigt = vc.surfaceView.frame.size.height
        templeteViewController.changeCollectionSize()
    }
    ///テンプレートがクリックされたときに呼び出されるデリゲートメソッド
    func templeteDidClick(_ cell:TempleteListCell,_ elements:Array<Dictionary<ElementEnum, Any?>>,_ rouletteData:Dictionary<RouletteDataElement,Any?>){
        rouletteViewController = RouletteViewController()
        rouletteViewController.elementFontColor = (rouletteElementFontColor != nil ? rouletteElementFontColor!.cgColor : UIColor.black.cgColor)
        rouletteViewController.elements = elements
        if let rouletteSound = rouletteData[.rouletteSound] as? RouletteSound{
            rouletteViewController.rouletteSound = rouletteSound
        }
        if let rouletteSpin = rouletteData[.rouletteSpin] as? RouletteSpin{
            rouletteViewController.rouletteSpin = rouletteSpin
        }
        if let rouletteSpeed = rouletteData[.rouletteSpeed] as? Float{
            rouletteViewController.rouletteSpeed = rouletteSpeed
        }
        if let rouletteTime = rouletteData[.rouletteTime] as? Float{
            rouletteViewController.rouletteTime = rouletteTime
        }
        if let title = rouletteData[.rouletteTitle] as? String{
            rouletteViewController.rouletteTitle = title
        }else{
            rouletteViewController.rouletteTitle = "ルーレット"
        }
        if let backgroundColor =  rouletteData[.rouletteBackgroundColor] as? UIColor{
            rouletteViewController.view.backgroundColor = backgroundColor
            rouletteViewController.rouletteBackgroundColor = backgroundColor
        }
        print(rouletteData)
        
        if let id = rouletteData[.id] as? String{
            print(id)
            rouletteViewController.id = id
            rouletteViewController.navigationSetting()
            newRouletteData = Roulette(context: rouletteManageObjectContext)
            newRouletteData.id = id
        }
        self.elements = elements
        self.tableCellNumber = elements.count
        self.indexCell = Dictionary<Int,Dictionary<ElementEnum,Any?>>()
        for count in 0..<elements.count{
            self.indexCell[count] = self.elements[count]
        }
        rouletteViewController.changeTheLayer()
        elementTable.reloadData()
        self.totalArea = Float(0)
        for number in 0..<elements.count{
            if let cell = elementTable.cellForRow(at: IndexPath(row: number, section: 0)) as? ElementTableCell{
                guard let element = indexCell[number] else{return}
                if let cgColor = element[.color]{
                    cell.colorButtonLayer.backgroundColor = cgColor as! CGColor
                }
                if let title = element[.title] as? String{
                    cell.nameTextField.text = title
                }
                if let rate = element[.rate] as? Float{
                    cell.numberTextField.text = String(Int(rate))
                    cell.beforeValue = rate
                    totalArea += rate
                }
                if let hit = element[.hit] as? RouletteResult{
                    cell.hit = hit
                }
                if let stopSound = element[.stopSound] as? RouletteStopSound{
                    cell.stopSound = stopSound
                }
            }
        }
        if fpc != nil{
            fpc.removePanelFromParent(animated: false)
            addPanel = nil
        }
        saveRoulette = Bool(true)
        addTemplateButton.setTitleColor(.white, for: .normal)
        addTemplateButton.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1)
        print(totalArea)
    
    }
    ///テンプレートのデータ数が0になったときに呼ばれるデリゲートメソッド
    func templateDataCountZero() {
        guard let _ = fpc else{return}
        fpc.removePanelFromParent(animated: true)
        addPanel = nil
    }
}

