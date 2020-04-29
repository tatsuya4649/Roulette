//
//  BasicCellSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum RouletteBasicSettingSection:Int{
    case title = 0
    case roulette = 1
    case design = 2
    case sound = 3
}

extension BasicDetailCellTableViewCell{
    public func setting(_ indexPath:IndexPath,_ title:String?,_ fontColor:UIColor?,_ backgroundColor:UIColor?,_ nowSound:RouletteSound?,_ rouletteSpeed:Float?,_ rouletteTime:Float?,_ rouletteSpin:RouletteSpin?){
        self.selectionStyle = .none
        switch indexPath.section {
        case RouletteBasicSettingSection.title.rawValue:
            titleSetting(indexPath,title)
        case RouletteBasicSettingSection.roulette.rawValue:
            rouletteSetting(indexPath,rouletteSpeed,rouletteTime,rouletteSpin)
        case RouletteBasicSettingSection.design.rawValue:
            designSetting(indexPath,fontColor,backgroundColor)
        case RouletteBasicSettingSection.sound.rawValue:
            soundSetting(indexPath,nowSound)
        default:break
        }
    }
    private func titleSetting(_ indexPath:IndexPath,_ title:String?){
        if indexPath.row == 0{
            titleTextSetting(title)
        }
    }
    private func rouletteSetting(_ indexPath:IndexPath,_ speed:Float?,_ time:Float?,_ spin:RouletteSpin?){
        if indexPath.row == 0{
            howToTurnSetting(spin)
        }else if indexPath.row == 1{
            rouletteSpeedSetting(speed)
        }else if indexPath.row == 2{
            rouletteTimeSetting(time)
        }
    }
    private func designSetting(_ indexPath:IndexPath,_ fontColor:UIColor?,_ backgroundColor:UIColor?){
        if indexPath.row == 0{
            backGroundDesign(backgroundColor)
        }else if indexPath.row == 1{
            fontDesign(fontColor)
        }
    }
    private func soundSetting(_ indexPath:IndexPath, _ nowSound:RouletteSound?){
        if indexPath.row == 0{
            rouletteSound(nowSound)
        }
    }
    
}
