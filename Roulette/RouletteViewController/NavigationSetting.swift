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

extension RouletteViewController{
    public func navigationSetting(){
        if id == nil{
            saveRoulette = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .star, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(tapSabeRoulette))
        }else{
            newRouletteData = Roulette(context: rouletteManageObjectContext)
            newRouletteData.id = id
            saveRoulette = Bool(true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(tapSabeRoulette))
        }
    }
    ///タップされたら保存・保存解除を行う
    @objc func tapSabeRoulette(_ sender:UIBarButtonItem){
        if saveRoulette == nil{
            saveRoulette = Bool(true)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(tapSabeRoulette))
            saveRouletteData()
            SPAlert.present(title: "テンプレート登録完了", message: nil, preset: .done)
        }else{
            saveRoulette = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .star, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(tapSabeRoulette))
            deleteRouletteData()
            SPAlert.present(title: "テンプレート解除完了", message: nil, preset: .done)
        }
    }
    private func saveRouletteData(){
        print("ルーレットデータを保存します。")
        rouletteData = Array<Roulette>()
        newRouletteData = Roulette(context: rouletteManageObjectContext)
        guard let elements = elements else{return}
        let newElements = changeElement(elements)
        print(newElements)
        guard let elementData = try? NSKeyedArchiver.archivedData(withRootObject: newElements, requiringSecureCoding: false) else{return}
        newRouletteData.elements = elementData
        do{
            let elementFontColorData = try? NSKeyedArchiver.archivedData(withRootObject: elementFontColor != nil ? elementFontColor! : UIColor.black, requiringSecureCoding: false)
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
