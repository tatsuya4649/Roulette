//
//  DatabaseOrganize.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/26.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension TempleteListViewController{
    public func rouletteDataToArray(){
        if rouletteDataArray == nil{
            rouletteDataArray = Array<Dictionary<RouletteDataElement,Any?>>()
        }
        var dict = Dictionary<RouletteDataElement,Any?>()
        for data in rouletteData{
            if let elementData = data.elements as? Data{
                do{
                    if let dataToArray = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(elementData) as? Array<Dictionary<String,Any?>>{
                        //rint(dataToArray)
                        dict[RouletteDataElement.elements] = chageFormat(dataToArray)
                    }
                }catch{
                    print("データから配列への変換に失敗しました。")
                }
            }
            if let elementFontColorData = data.elementFontColor as? Data{
                do{
                    if let fontColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(elementFontColorData) as? UIColor{
                        //print(fontColor)
                        dict[RouletteDataElement.elementFontColor] = fontColor
                    }
                }catch{
                    print("データからフォントカラーへの変換に失敗しました。")
                }
            }
            if let backgroundColorData = data.rouletteBackgroundColor as? Data{
                do{
                    if let backgroundColor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(backgroundColorData) as? UIColor{
                        //print(backgroundColor)
                        dict[RouletteDataElement.rouletteBackgroundColor] = backgroundColor
                    }
                }catch{
                    print("データから背景色への変換に失敗しました。")
                }
            }
            if let rouletteSoundString = data.rouletteSound as? String{
                dict[RouletteDataElement.rouletteSound] = RouletteSound(rawValue: rouletteSoundString)
            }
            if let rouletteSpin = data.rouletteSpin as? Int16{
                dict[RouletteDataElement.rouletteSpin] = RouletteSpin(rawValue: Int(rouletteSpin))
            }
            if let rouletteSpeed = data.rouletteSpeed as? Float{
                dict[RouletteDataElement.rouletteSpeed] = rouletteSpeed
            }
            if let rouletteTime = data.rouletteTime as? Float{
                dict[RouletteDataElement.rouletteTime] = rouletteTime
            }
            if let rouletteTitle = data.rouletteTitle as? String{
                dict[RouletteDataElement.rouletteTitle] = rouletteTitle
            }
            if let saveData = data.saveDate as? Date{
                dict[RouletteDataElement.saveData] = saveData
            }
            if let id = data.id as? String{
                dict[RouletteDataElement.id] = id
            }
            rouletteDataArray.append(dict)
        }
        rouletteDataSearchArray = rouletteDataArray
        guard let collectionView = collectionView else{return}
        collectionView.reloadData()
    }
    private func chageFormat(_ dataToArray:Array<Dictionary<String,Any?>>)->Array<Dictionary<ElementEnum,Any?>>{
        var elements = Array<Dictionary<ElementEnum,Any?>>()
        for dic in dataToArray{
            var rouletteElements = Dictionary<ElementEnum,Any?>()
            if let rate = dic[ElementEnum.rate.rawValue] as? Float{
                rouletteElements[ElementEnum.rate] = rate
            }
            if let colorData = dic[ElementEnum.color.rawValue] as? Data{
                do{
                    if let color = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor{
                        rouletteElements[ElementEnum.color] = color.cgColor
                    }
                }catch{
                    print("colorの変換に失敗しました。")
                }
            }
            if let hit = dic[ElementEnum.hit.rawValue] as? String?{
                if hit == nil{
                    rouletteElements[ElementEnum.hit] = RouletteResult.none
                }else{
                    rouletteElements[ElementEnum.hit] = RouletteResult(rawValue: hit!)
                }
            }
            if let title =  dic[ElementEnum.title.rawValue] as? String?{
                rouletteElements[ElementEnum.title] = title
            }
            if let stopSound = dic[ElementEnum.stopSound.rawValue] as? String{
                rouletteElements[ElementEnum.stopSound] = RouletteStopSound(rawValue: stopSound)
            }else{
                rouletteElements[ElementEnum.stopSound] = RouletteStopSound.stopSound1
            }
            elements.append(rouletteElements)
        }
        print(elements)
        return elements
    }
}
