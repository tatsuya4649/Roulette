//
//  ColorButton.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    var backgroundLayer : CALayer!
    init(frame:CGRect,backgroundColor:CGColor){
        super.init(frame:frame)
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.1
        backgroundLayer = CALayer()
        backgroundLayer.frame = CGRect(x: 0, y: 0, width: 0.8*self.frame.size.width, height: 0.8*self.frame.size.height)
        backgroundLayer.backgroundColor = backgroundColor
        backgroundLayer.cornerRadius = backgroundLayer.frame.size.height/2
        backgroundLayer.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.layer.addSublayer(backgroundLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
