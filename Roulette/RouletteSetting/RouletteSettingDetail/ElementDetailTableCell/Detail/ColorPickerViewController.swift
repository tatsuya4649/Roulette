//
//  ColorPickerViewController.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

@objc protocol ColorPickerViewDelegate:AnyObject {
    @objc optional func onColorChangedDetail(newColor: UIColor,_ cell:ElementDetailTableCell)
    @objc optional func onColorChanged(newColor: UIColor,_ cell:ElementTableCell)
    @objc optional func onColorChangedBasic(newColor:UIColor,_ cell:BasicDetailCellTableViewCell,_ design:String)
}

class ColorsView: UIView {
    // 細かさの設定
    var xCount = 15
    var yCount = 20
    
    var blockSize: CGSize! = nil
    var size: CGSize! = nil
    
    func setUp() {
        self.size = self.bounds.size
    }
    
    func colorFromPos(posH: Int, posS: Int) -> UIColor {
        if posH == 0 {
            return UIColor(hue: 0, saturation: 0, brightness: 1.0-CGFloat(posS)/CGFloat(xCount-1), alpha: 1.0)
        } else {
            return UIColor(hue: CGFloat(posH-1)/CGFloat(yCount-1), saturation: CGFloat(posS+1)/CGFloat(xCount), brightness: 1.0, alpha: 1.0)
        }
    }
    
    func colorFromPoint(point: CGPoint) -> UIColor {
        let posX = Int(point.x * CGFloat(xCount) / size.width)
        let posY = Int(point.y * CGFloat(yCount) / size.height)
        return colorFromPos(posH: posY, posS: posX)
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let blockSize = CGSize(width: size.width/CGFloat(xCount), height: size.height/CGFloat(yCount))
        
        for i in 0...yCount {
            for j in 0...xCount {
                let color = colorFromPos(posH: i, posS: j)
                color.setFill()
                let blockRect = CGRect(
                    origin: CGPoint(x: blockSize.width*CGFloat(j), y: blockSize.height*CGFloat(i)),
                    size: blockSize
                )
                context!.fill(blockRect)
            }
        }
    }
}

class ColorPickerViewController: UIViewController {
    weak var delegate: ColorPickerViewDelegate!
    
    var colorsView: ColorsView!
    
    var detailCell : ElementDetailTableCell!
    var cell : ElementTableCell!
    var basicCell : BasicDetailCellTableViewCell!
    var design : BasicSettingColor!
    var currentColor: UIColor = UIColor.white
    
    override func viewDidLoad() {
        self.view.layer.cornerRadius = 1.0
        
        if colorsView == nil {
            colorsView = ColorsView(frame: CGRect(origin: CGPoint.zero, size: self.preferredContentSize))
            colorsView.setUp()
            self.view.addSubview(colorsView)
        }
    }
    
    override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self.view)
        updateColor(color: colorsView.colorFromPoint(point: touch!))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self.view)
        updateColor(color: colorsView.colorFromPoint(point: touch!))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first?.location(in: self.view)
        updateColor(color: colorsView.colorFromPoint(point: touch!))
        
        closeView()
    }
    
    func closeView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func updateColor(color: UIColor) {
        self.currentColor = color
        if self.cell != nil{
            delegate?.onColorChanged!(newColor: self.currentColor,self.cell)
        }else if self.basicCell != nil{
            delegate?.onColorChangedBasic?(newColor: self.currentColor,self.basicCell,self.design.rawValue)
        }else{
            delegate?.onColorChangedDetail!(newColor: self.currentColor,self.detailCell)
        }
        
        
    }
}
