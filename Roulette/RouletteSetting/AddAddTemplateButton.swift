//
//  AddAddTemplateButton.swift
//  Roulette
//
//  Created by 下川達也 on 2020/05/01.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SPAlert

extension SettingViewController{
    public func settingTemplateAddingButton(){
        addTemplateButton = UIButton()
        addTemplateButton.setTitle(String.fontAwesomeIcon(name: .star), for: .normal)
        addTemplateButton.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1), for: .normal)
        addTemplateButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        addTemplateButton.backgroundColor = .white
        addTemplateButton.sizeToFit()
        addTemplateButton.layer.borderColor = UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1).cgColor
        addTemplateButton.layer.borderWidth = 1
        addTemplateButton.titleLabel?.sizeToFit()
        addTemplateButton.titleLabel?.textAlignment = .center
        addTemplateButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        addTemplateButton.layer.cornerRadius = addTemplateButton.frame.size.height/2
        addTemplateButton.clipsToBounds = true
        addTemplateButton.center = CGPoint(x: self.view.frame.size.width - 20 - addTemplateButton.frame.size.width/2, y: self.view.frame.size.height - 30 - addTemplateButton.frame.size.height/2)
        addTemplateButton.addTarget(self, action: #selector(addTemplateButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(addTemplateButton)
    }
    ///現在回しているルーレットを保存・削除を行うメソッド
    @objc func addTemplateButtonClick(_ sender:UIButton){
        if saveRoulette == nil{
            saveRoulette = Bool(true)
            saveRouletteData()
            SPAlert.present(title: "テンプレート登録完了", message: nil, preset: .done)
            addTemplateButton.setTitleColor(.white, for: .normal)
            addTemplateButton.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1)
        }else{
            saveRoulette = nil
            deleteRouletteData()
            SPAlert.present(title: "テンプレート解除完了", message: nil, preset: .done)
            addTemplateButton.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1), for: .normal)
            addTemplateButton.backgroundColor = .white
        }
    }
    private func saveRouletteData(){
        print("ルーレットデータを保存します。")
        rouletteData = Array<Roulette>()
        newRouletteData = Roulette(context: rouletteManageObjectContext)
        guard let elements = elements else{return}
        print(elements)
        
        let newElements = changeElement(elements)
        print(newElements)
        guard let elementData = try? NSKeyedArchiver.archivedData(withRootObject: newElements, requiringSecureCoding: false) else{return}
        newRouletteData.elements = elementData
        do{
            let elementFontColorData = try? NSKeyedArchiver.archivedData(withRootObject: rouletteElementFontColor != nil ? rouletteElementFontColor! : UIColor.black, requiringSecureCoding: false)
            newRouletteData.elementFontColor = elementFontColorData
        }catch{
            print("フォントカラーのデータ化に失敗しました。")
        }
        do{
            let backgroundColorData = try? NSKeyedArchiver.archivedData(withRootObject: rouletteBackgroundColor != nil ? rouletteBackgroundColor! : UIColor.white, requiringSecureCoding: false)
            newRouletteData.rouletteBackgroundColor = backgroundColorData
        }catch{
            print("背景色のデータ化に失敗しました。")
        }
        newRouletteData.rouletteSound = rouletteSound != nil ? rouletteSound.rawValue : RouletteSound.sound1.rawValue
        newRouletteData.rouletteSpin = rouletteSpin != nil ? Int16(rouletteSpin.rawValue) : Int16(RouletteSpin.auto.rawValue)
        newRouletteData.rouletteTime = rouletteTime != nil ? rouletteTime : Float(2.0)
        newRouletteData.rouletteSpeed = rouletteSpeed != nil ? rouletteSpeed : Float(2.0)
        newRouletteData.rouletteTitle = rouletteTitle != nil ? rouletteTitle! : "ルーレット"
        newRouletteData.id = NSUUID().uuidString
        newRouletteData.saveDate = Date()
        rouletteData.append(newRouletteData)
        guard let id = newRouletteData.id else{return}
        print(newRouletteData.saveDate)
        print("ID:\(id)で保存が完了しました")
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    ///データベースに保存できる形式にそれぞれの値の型を変換するためのプライベートメソッド(データ整理関数)
    private func changeElement(_ elements:Array<Dictionary<ElementEnum,Any?>>)->Array<Dictionary<String,Any?>>{
        var newElements = Array<Dictionary<String,Any?>>()
        for element in elements{
            var stopSound : String!
            var rate : Float!
            var colorData : Data!
            var hit : String!
            var title : String!
            if let stop = element[.stopSound] as? RouletteStopSound{
                stopSound = stop.rawValue
            }
            if let _ = element[.rate] as? Float{
                rate = element[.rate] as? Float
            }
            do{
                if let color = element[.color]{
                    if color is CGColor?{
                        let uiColor = UIColor(cgColor: color as! CGColor)
                        colorData = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
                    }
                }
            }catch{
            }
            if let newHit = element[.hit] as? RouletteResult{
                hit = newHit.rawValue
            }
            if let newTitle = element[.title] as? String{
                title = newTitle
            }
            newElements.append(
                [
                    ElementEnum.stopSound.rawValue:stopSound,
                    ElementEnum.rate.rawValue:rate,
                    ElementEnum.color.rawValue:colorData,
                    ElementEnum.hit.rawValue:hit,
                    ElementEnum.title.rawValue:title
                ]
            )
        }
        return newElements
    }
    private func deleteRouletteData(){
        print("保存したルーレットデータを削除します。")
        guard let id = newRouletteData.id else{return}
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Roulette")
        let predict = NSPredicate(format: "%K=%@", "id", id)
        fetchReq.predicate = predict
        rouletteData = Array<Roulette>()
        do{
            rouletteData = try rouletteManageObjectContext.fetch(fetchReq) as? Array<Roulette>
        }catch{
            print("先ほど削除したデータの取得に失敗しました。")
        }
        for data in rouletteData{
            rouletteManageObjectContext.delete(data)
        }
        do{
            try rouletteManageObjectContext.save()
        }catch{
            print("データベースの保存に失敗しました。")
        }
        print("ID:\(id)の削除が完了しました")
    }
}
