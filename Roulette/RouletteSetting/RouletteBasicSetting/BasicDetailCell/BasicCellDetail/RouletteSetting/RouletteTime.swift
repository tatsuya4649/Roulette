//
//  RouletteTime.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/27.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension BasicDetailCellTableViewCell{
    public func rouletteTimeSetting(_ time:Float?){
        cellTitleSetting("時間")
        timeRouletteView = RouletteView(frame: CGRect(x: 0, y: 0, width: (self.frame.size.width - 20)/3, height: ((self.frame.size.width - 20)/3)*0.8), elements: [
            [
                ElementEnum.stopSound : RouletteStopSound.stopSound1,
                ElementEnum.color : UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 1).cgColor,
                ElementEnum.hit : RouletteResult.none,
                ElementEnum.title : nil,
                ElementEnum.rate : Float(50.0)
            ],
            [
                ElementEnum.stopSound : RouletteStopSound.stopSound1,
                ElementEnum.color : UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 1).cgColor,
                ElementEnum.hit : RouletteResult.none,
                ElementEnum.title : nil,
                ElementEnum.rate : Float(50.0)
            ]
        ], fontColor: UIColor.black.cgColor)
        timeRouletteView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(timeRouletteView)
        timeChangeSlider = UISlider(frame: CGRect(x: 0, y: 0, width: (self.frame.size.width - 20)/1.5, height: 30))
        timeChangeSlider.center = CGPoint(x: timeRouletteView.center.x, y: 10 + timeRouletteView.frame.maxY + 10 + timeChangeSlider.frame.size.height/2)
        timeChangeSlider.minimumValue = 1.0
        timeChangeSlider.maximumValue = 3.0
        timeChangeSlider.value = time != nil ? time! : Float(2.0)
        self.time = time != nil ? time! : Float(2.0)
        timeChangeSlider.addTarget(self, action: #selector(timeSliderChange), for: .touchUpInside)
        self.contentView.addSubview(timeChangeSlider)
        timeRouletteView.translatesAutoresizingMaskIntoConstraints = false
        timeRouletteView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant:10).isActive = true
        timeRouletteView.widthAnchor.constraint(equalToConstant: (self.frame.size.width - 20)/3).isActive = true
        timeRouletteView.heightAnchor.constraint(equalToConstant: ((self.frame.size.width - 20)/3)*0.8).isActive = true
        timeRouletteView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-(10 + timeChangeSlider.frame.size.height + 10)).isActive = true
        //speendRouletteView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -10.0).isActive = true
        timeRouletteView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        timeRouletteView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        timeChangeSlider.translatesAutoresizingMaskIntoConstraints = false
        timeChangeSlider.centerXAnchor.constraint(equalTo:  self.contentView.centerXAnchor).isActive = true
        timeChangeSlider.widthAnchor.constraint(equalToConstant: timeChangeSlider.frame.size.width).isActive = true
        timeChangeSlider.heightAnchor.constraint(equalToConstant: timeChangeSlider.frame.size.height).isActive = true
        timeChangeSlider.centerYAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-(10+timeChangeSlider.frame.size.height/2)).isActive = true
        let slowLabel = UILabel()
        slowLabel.text = "短"
        slowLabel.textColor = .black
        slowLabel.font = .systemFont(ofSize: 10, weight: .light)
        slowLabel.sizeToFit()
        self.contentView.addSubview(slowLabel)
        slowLabel.translatesAutoresizingMaskIntoConstraints = false
        slowLabel.centerXAnchor.constraint(equalTo: timeChangeSlider.leftAnchor,constant:-(20-slowLabel.frame.size.width/2)).isActive = true
        slowLabel.centerYAnchor.constraint(equalTo: timeChangeSlider.centerYAnchor).isActive = true
        let fastLabel = UILabel()
        fastLabel.text = "長"
        fastLabel.textColor = .black
        fastLabel.font = .systemFont(ofSize: 10, weight: .light)
        fastLabel.sizeToFit()
        self.contentView.addSubview(fastLabel)
        fastLabel.translatesAutoresizingMaskIntoConstraints = false
        fastLabel.centerXAnchor.constraint(equalTo: timeChangeSlider.rightAnchor,constant:(10+fastLabel.frame.size.width/2)).isActive = true
        fastLabel.centerYAnchor.constraint(equalTo: timeChangeSlider.centerYAnchor).isActive = true
    }
    @objc func timeSliderChange(_ sender:UISlider){
        time = sender.value
        guard let delegate = delegate else{return}
        delegate.changeRouletteTime(sender.value)
        removeTimeAnimation()
        spinAuto(time)
    }
    private func removeTimeAnimation(){
        timeRouletteView.layer.removeAllAnimations()
    }
    private func spinAuto(_ time:Float){
        timeAnimationLayer = CABasicAnimation(keyPath: "transform.rotation")
        timeAnimationLayer.isRemovedOnCompletion = false
        timeAnimationLayer.fillMode = .forwards
        timeAnimationLayer.fromValue = 0
        timeAnimationLayer.toValue = -.pi/2.0
        timeAnimationLayer.duration = 0.1
        timeAnimationLayer.isCumulative = true
        timeAnimationLayer.repeatCount = MAXFLOAT
        timeRouletteView.layer.speed = Float.random(in: 5.00*(2)..<5.25*(2))
        timeRouletteView.layer.add(timeAnimationLayer, forKey: "spinAnimation")
        timeAnimationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeSpeedDown), userInfo: nil, repeats: true)
    }
    @objc func timeSpeedDown(_ sender:Timer){
        guard let _ = timeAnimationLayer else{return}
        timeRouletteView.layer.timeOffset = timeRouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        timeRouletteView.layer.beginTime = CACurrentMediaTime()
        if timeRouletteView.layer.speed > 0.0025*2{
            if timeRouletteView.layer.speed > 1.5*2{
                timeRouletteView.layer.speed -= 0.05*4/time
            }else if timeRouletteView.layer.speed > 0.5*2{
                timeRouletteView.layer.speed -= 0.025*4/time
            }else if timeRouletteView.layer.speed > 0.05*2{
                timeRouletteView.layer.speed -= 0.015*4/time
            }else if timeRouletteView.layer.speed > 0{
                timeRouletteView.layer.speed -= 0.005*4/time
            }
        }else{
            timeRouletteView.layer.speed = 0
            guard let _ = timeAnimationTimer else{return}
            timeAnimationTimer.invalidate()
        }
    }
}
