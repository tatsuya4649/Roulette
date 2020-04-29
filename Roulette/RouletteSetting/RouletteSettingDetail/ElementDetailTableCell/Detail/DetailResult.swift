//
//  DetailResult.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum RouletteResult:String{
    case hit = "アタリ"
    case lost = "ハズレ"
    case none = "なし"
}

extension ElementDetailTableCell{
    public func detailResultSetting(_ hit:RouletteResult?){
        detailResultSegment = UISegmentedControl(items: [
            RouletteResult.hit.rawValue,
            RouletteResult.lost.rawValue,
            RouletteResult.none.rawValue
        ])
        if hit == nil{
            detailResultSegment.selectedSegmentIndex = 2
        }else{
            switch hit{
            case .hit:
                detailResultSegment.selectedSegmentIndex = 0
            case .lost:
                detailResultSegment.selectedSegmentIndex = 1
            case .none:
                detailResultSegment.selectedSegmentIndex = 2
            default:
                detailResultSegment.selectedSegmentIndex = 2
            }
        }
        
        detailResultSegment.sizeToFit()
        detailResultSegment.center = CGPoint(x: self.frame.size.width - 10 - detailResultSegment.frame.size.width/2, y: self.contentView.frame.size.height/2)
        detailResultSegment.addTarget(self, action: #selector(resultChange), for: .valueChanged)
        self.contentView.addSubview(detailResultSegment)
    }
    @objc func resultChange(_ sender:UISegmentedControl){
        if let value = sender.titleForSegment(at: sender.selectedSegmentIndex){
            guard let delegate = delegate else{return}
            delegate.rouletteChangeResult(self, RouletteResult(rawValue: value))
        }
    }
}
