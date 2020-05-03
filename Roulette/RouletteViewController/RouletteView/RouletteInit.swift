//
//  RouletteInit.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

public enum ElementEnum : String {
    case color = "color"
    case rate = "rate"
    case title = "title"
    case stopSound = "stopSound"
    case hit = "hit"
}

extension RouletteView{
    public func settingElementLayer(){
        keyRange = Array<Range<CGFloat>>()
        for i in 0..<elements.count{
            guard let value = elements[i] as? [ElementEnum:Any?] else{return}
            print(value)
            addLayer(value[.title] as! String?,value[.color] as! CGColor?,value[.rate] as! Float)
        }
        
    }
    ///キーはルーレットの要素のタイトル、colorはその領域の色、rateはその領域が占める割合(全体を100とする)
    ///rouletteViewに渡された要素からLayerを作成してaddLayerしていく
    private func addLayer(_ title:String?,_ color:CGColor?,_ rate:Float){
        let center = CGPoint(x:self.bounds.size.width/2,y:self.bounds.size.height/2)
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to:center)
        let start = CGFloat(nowAngle != nil ? nowAngle : CGFloat(-Double.pi/2))
        let rate = rate/100
        let end = start + CGFloat(Double(360*rate)*(Double.pi)/180)
        keyRange.append(CGFloat((Double(start*180)/Double.pi) + 90)..<CGFloat((Double(end*180)/Double.pi) + 90))
        nowAngle =  end
        path.addArc(withCenter: center, radius: self.bounds.size.height/2, startAngle: start, endAngle: end, clockwise: true)
        layer.frame = self.bounds
        layer.fillColor = (color != nil ? color : UIColor.white.cgColor)
        layer.path = path.cgPath
        self.layer.insertSublayer(layer, at: 0)
        
        if let title = title as? String{
            let textLayer = CATextLayer()
            textLayer.string = title
            textLayer.foregroundColor = elementFontColor != nil ? elementFontColor : UIColor.black.cgColor
            textLayer.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            textLayer.fontSize = fontSize != nil ? fontSize! : 15
            textLayer.contentsScale = UIScreen.main.scale
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.sizeToFit()
            let size = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.size.height))
            textLayer.frame = CGRect(x:0,y:0,width:size.width,height:size.height)
            let radius = self.frame.size.width/4
            let newStart = start + CGFloat.pi/2
            let newEnd = end + CGFloat.pi/2
            let titleAngle = newStart + (newEnd - newStart)/2
            textLayer.position = CGPoint(x: center.x + radius * sin(titleAngle) , y: center.y - radius * cos(titleAngle))
            self.layer.addSublayer(textLayer)
        }
        
    }
}
