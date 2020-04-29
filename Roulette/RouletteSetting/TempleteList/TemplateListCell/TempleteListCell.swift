//
//  TempleteListCell.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TempleteListCell: UICollectionViewCell {
    weak var delegate : TempleteCellDelegate!
    var rouletteView : RouletteView!
    var dateLabel : UILabel!
    var dateIconLabel : UILabel!
    var rouletteTitleLabel : UILabel!
    var offsetY : CGFloat!
    var elements : Array<Dictionary<ElementEnum,Any?>>!
    var rouletteData : Dictionary<RouletteDataElement,Any?>!
    var deleteButton : UIButton!
    public func setUp(){
        offsetY = CGFloat(0)
        self.contentView.layer.cornerRadius = 10
        guard let elements = elements else{return}
        guard let rouletteData = rouletteData else{return}
        var fontCgColor : CGColor!
        if let fontColor = rouletteData[.elementFontColor] as? UIColor{
            fontCgColor = fontColor.cgColor
        }
        rouletteView = RouletteView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width*0.8, height: self.frame.size.width*0.8), elements: elements, fontColor: fontCgColor != nil ? fontCgColor : UIColor.black.cgColor)
        rouletteView.center = CGPoint(x: self.frame.size.width/2, y: 10 + rouletteView.frame.size.height/2)
        self.contentView.addSubview(rouletteView)
        offsetY += 10 + rouletteView.frame.size.height
        if let backgroundColor = rouletteData[.rouletteBackgroundColor] as? UIColor{
            self.contentView.backgroundColor = backgroundColor
        }
        if let date = rouletteData[.saveData] as? Date{
            dateLabel = UILabel()
            dateLabel.text = getDateString(date)
            dateLabel.font = .systemFont(ofSize: 9, weight: .light)
            dateLabel.textColor = .black
            dateLabel.sizeToFit()
            dateLabel.center = CGPoint(x: self.frame.size.width/2, y: offsetY + 15 + dateLabel.frame.size.height/2)
            self.contentView.addSubview(dateLabel)
            dateIconLabel = UILabel()
            dateIconLabel.text = String.fontAwesomeIcon(name: .clock)
            dateIconLabel.font = UIFont.fontAwesome(ofSize: 12, style: .regular)
            dateIconLabel.sizeToFit()
            dateIconLabel.textColor = .black
            dateIconLabel.center = CGPoint(x: dateLabel.frame.minX - 5 - dateIconLabel.frame.size.width/2, y: dateLabel.center.y)
            self.contentView.addSubview(dateIconLabel)
            offsetY += 15 + max(dateLabel.frame.size.height,dateIconLabel.frame.size.height)
        }
        if let title = rouletteData[.rouletteTitle] as? String{
            rouletteTitleLabel = UILabel()
            rouletteTitleLabel.text = title
            rouletteTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            rouletteTitleLabel.textColor = .black
            rouletteTitleLabel.numberOfLines = 0
            rouletteTitleLabel.lineBreakMode = .byWordWrapping
            let size = rouletteTitleLabel.sizeThatFits(CGSize(width: self.frame.size.width*0.8, height: CGFloat.greatestFiniteMagnitude))
            rouletteTitleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rouletteTitleLabel.center = CGPoint(x: self.frame.size.width/2, y: offsetY + 5 + rouletteTitleLabel.frame.size.height/2)
            self.contentView.addSubview(rouletteTitleLabel)
        }
    }
    static func cellHeight(_ width:CGFloat,_ elements:Array<Dictionary<ElementEnum,Any?>>,_ rouletteData:Dictionary<RouletteDataElement,Any?>)->CGFloat{
        var height = CGFloat(0)
        var fontCgColor : CGColor!
        if let fontColor = rouletteData[.elementFontColor] as? UIColor{
            fontCgColor = fontColor.cgColor
        }
        var rouletteView = RouletteView(frame: CGRect(x: 0, y: 0, width: width*0.8, height: width*0.8), elements: elements, fontColor: fontCgColor != nil ? fontCgColor : UIColor.black.cgColor)
        rouletteView.center = CGPoint(x: width/2, y: 10 + rouletteView.frame.size.height/2)
        height += 10 + rouletteView.frame.size.height
        if let date = rouletteData[.saveData] as? Date{
            var dateLabel = UILabel()
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
            dateLabel.text = formatter.string(from: date)
            dateLabel.font = .systemFont(ofSize: 9, weight: .light)
            dateLabel.textColor = .black
            dateLabel.sizeToFit()
            dateLabel.center = CGPoint(x: width/2, y: height + 15 + dateLabel.frame.size.height/2)
            var dateIconLabel = UILabel()
            dateIconLabel.text = String.fontAwesomeIcon(name: .clock)
            dateIconLabel.font = UIFont.fontAwesome(ofSize: 12, style: .regular)
            dateIconLabel.sizeToFit()
            dateIconLabel.textColor = .black
            dateIconLabel.center = CGPoint(x: dateLabel.frame.minX - 5 - dateIconLabel.frame.size.width/2, y: dateLabel.center.y)
            height += (15 + max(dateLabel.frame.size.height,dateIconLabel.frame.size.height))
        }
        if let title = rouletteData[.rouletteTitle] as? String{
            var rouletteTitleLabel = UILabel()
            rouletteTitleLabel.text = title
            rouletteTitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            rouletteTitleLabel.textColor = .black
            rouletteTitleLabel.numberOfLines = 0
            rouletteTitleLabel.lineBreakMode = .byWordWrapping
            let size = rouletteTitleLabel.sizeThatFits(CGSize(width: width*0.8, height: CGFloat.greatestFiniteMagnitude))
            rouletteTitleLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            rouletteTitleLabel.center = CGPoint(x: width/2, y: height + 5 + rouletteTitleLabel.frame.size.height/2)
            height += (5 + rouletteTitleLabel.frame.size.height)
        }
        return height
    }
    private func getDateString(_ date : Date)->String{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        return formatter.string(from: date)
    }
}
