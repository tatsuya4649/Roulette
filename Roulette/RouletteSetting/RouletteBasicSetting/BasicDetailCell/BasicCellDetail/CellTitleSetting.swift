//
//  CellTitleSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension BasicDetailCellTableViewCell{
    public func cellTitleSetting(_ title:String){
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.font = .systemFont(ofSize: 17, weight: .semibold)
        cellTitle.textColor = .black
        cellTitle.sizeToFit()
        cellTitle.center = CGPoint(x: 20 + cellTitle.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(cellTitle)
    }
}
