//
//  ElementDetailTableCellSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

enum ElementDetailString:String{
    case title = "タイトル"
    case color = "カラー"
    case area = "エリア"
    case stopSound = "ストップサウンド"
    case result = "結果"
}
extension ElementDetailTableCell{
    private func detailTitleSet(_ title:String){
        self.selectionStyle = .none
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: 20 + titleLabel.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(titleLabel)
    }
    public func titleSetting(_ title:String?){
        detailTitleSet(ElementDetailString.title.rawValue)
        detailTitleSetting(title)
    }
    public func colorSetting(_ color:CGColor){
        detailTitleSet(ElementDetailString.color.rawValue)
        detailColorButtonSetting(color)
    }
    public func areaSetting(_ area:String?){
        detailTitleSet(ElementDetailString.area.rawValue)
        detailAreaSetting(area)
    }
    //public func soundSetting(){
        //detailTitleSet(ElementDetailString.sound.rawValue)
        //detailSoundSetting()
    //}
    public func stopSoundSetting(_ stopSound:RouletteStopSound?){
        detailTitleSet(ElementDetailString.stopSound.rawValue)
        detailStopSoundSetting(stopSound)
    }
    public func resultSetting(_ hit:RouletteResult?){
        detailTitleSet(ElementDetailString.result.rawValue)
        detailResultSetting(hit)
    }
}
