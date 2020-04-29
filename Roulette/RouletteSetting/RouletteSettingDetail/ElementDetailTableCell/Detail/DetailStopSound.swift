//
//  DetailStopSound.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum RouletteStopSound:String{
    case stopSound1 = "rouletteStopSound1"
    case stopSound2 = "rouletteStopSound2"
    case stopSound3 = "rouletteStopSound3"
    case stopSound4 = "rouletteStopSound4"
    case stopSound5 = "rouletteStopSound5"
    case none = "none"
}

extension ElementDetailTableCell{
    public func detailStopSoundSetting(_ stopSound:RouletteStopSound?){
        detailStopSoundPickerArray = Array<RouletteStopSound>()
        detailStopSoundPickerArray = [
            .stopSound1,
            .stopSound2,
            .stopSound3,
            .stopSound4,
            .stopSound5,
            .none
        ]
        detailStopSoundNameArray = Array<String>()
        detailStopSoundNameArray = [
            "シンバル",
            "太鼓1",
            "太鼓2",
            "ラッパ",
            "時代劇",
            "音無し"
        ]
        detailStopSoundPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0.5*(self.frame.size.width - titleLabel.frame.maxX), height: 70))
        detailStopSoundPicker.center = CGPoint(x: self.frame.size.width - 10 - detailStopSoundPicker.frame.size.width/2,y: self.contentView.frame.size.height/2)
        detailStopSoundPicker.delegate = self
        detailStopSoundPicker.dataSource = self
        self.contentView.addSubview(detailStopSoundPicker)
        
        guard let stopSound = stopSound else{return}
        switch stopSound{
        case .stopSound1:
            detailStopSoundPicker.selectRow(0, inComponent: 0, animated: false)
        case .stopSound2:
            detailStopSoundPicker.selectRow(1, inComponent: 0, animated: false)
        case .stopSound3:
            detailStopSoundPicker.selectRow(2, inComponent: 0, animated: false)
        case .stopSound4:
            detailStopSoundPicker.selectRow(3, inComponent: 0, animated: false)
        case .stopSound5:
            detailStopSoundPicker.selectRow(4, inComponent: 0, animated: false)
        case .none:
            detailStopSoundPicker.selectRow(5, inComponent: 0, animated: false)
        default:break
        }
    }
}
