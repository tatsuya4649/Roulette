//
//  StopLabelSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension RouletteViewController{
    public func addStopLabelSetting(_ number:Int){
        if number < elements.count{
            if let title = elements[number][.title] as? String{
                stopLabel = UILabel()
                stopLabel.text = title
                stopLabel.font = .systemFont(ofSize: 30, weight: .semibold)
                if let hit = elements[number][.hit] as? RouletteResult{
                    switch hit {
                    case .hit:
                        stopLabel.textColor = .red
                    case .lost:
                        stopLabel.textColor = .blue
                    case .none:
                        stopLabel.textColor = .black
                    default:
                        stopLabel.textColor = .black
                    }
                }
                stopLabel.sizeToFit()
                stopLabel.center = CGPoint(x: self.view.center.x, y: arrowDown.frame.minY + 10 - stopLabel.frame.size.height/2)
                self.view.addSubview(stopLabel)
            }
        }
    }
    public func removeStopLabel(){
        guard let _ = stopLabel else{return}
        stopLabel.removeFromSuperview()
        stopLabel = nil
    }
}
