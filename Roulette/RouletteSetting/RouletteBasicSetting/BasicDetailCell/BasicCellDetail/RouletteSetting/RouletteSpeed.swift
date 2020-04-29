//
//  RouletteSpeed.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/27.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension BasicDetailCellTableViewCell{
    public func rouletteSpeedSetting(_ speed : Float?){
        cellTitleSetting("スピード")
        speendRouletteView = RouletteView(frame: CGRect(x: 0, y: 0, width: (self.frame.size.width - 20)/3, height: ((self.frame.size.width - 20 )/3)*0.8), elements: [
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
        speendRouletteView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(speendRouletteView)
        speedChangeSlider = UISlider(frame: CGRect(x: 0, y: 0, width: (self.frame.size.width - 20)/1.5, height: 30))
        speedChangeSlider.center = CGPoint(x: speendRouletteView.center.x, y: 10 + speendRouletteView.frame.maxY + 10 + speedChangeSlider.frame.size.height/2)
        speedChangeSlider.minimumValue = 1.0
        speedChangeSlider.maximumValue = 3.0
        speedChangeSlider.value = speed != nil ? speed! : Float(2.0)
        self.speed = speed != nil ? speed! : Float(2.0)
        speedChangeSlider.addTarget(self, action: #selector(speedSliderChange), for: .touchUpInside)
        self.contentView.addSubview(speedChangeSlider)
        speendRouletteView.translatesAutoresizingMaskIntoConstraints = false
        speendRouletteView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant:10).isActive = true
        speendRouletteView.widthAnchor.constraint(equalToConstant: (self.frame.size.width - 20)/3).isActive = true
        speendRouletteView.heightAnchor.constraint(equalToConstant: ((self.frame.size.width - 20)/3)*0.8).isActive = true
        speendRouletteView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-(10 + speedChangeSlider.frame.size.height + 10)).isActive = true
        //speendRouletteView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -10.0).isActive = true
        speendRouletteView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        speendRouletteView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        speedChangeSlider.translatesAutoresizingMaskIntoConstraints = false
        speedChangeSlider.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        speedChangeSlider.widthAnchor.constraint(equalToConstant: speedChangeSlider.frame.size.width).isActive = true
        speedChangeSlider.heightAnchor.constraint(equalToConstant: speedChangeSlider.frame.size.height).isActive = true
        speedChangeSlider.centerYAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant:-(10+speedChangeSlider.frame.size.height/2)).isActive = true
        let slowLabel = UILabel()
        slowLabel.text = "遅"
        slowLabel.textColor = .black
        slowLabel.font = .systemFont(ofSize: 10, weight: .light)
        slowLabel.sizeToFit()
        self.contentView.addSubview(slowLabel)
        slowLabel.translatesAutoresizingMaskIntoConstraints = false
        slowLabel.centerXAnchor.constraint(equalTo: speedChangeSlider.leftAnchor,constant:-(20-slowLabel.frame.size.width/2)).isActive = true
        slowLabel.centerYAnchor.constraint(equalTo: speedChangeSlider.centerYAnchor).isActive = true
        let fastLabel = UILabel()
        fastLabel.text = "速"
        fastLabel.textColor = .black
        fastLabel.font = .systemFont(ofSize: 10, weight: .light)
        fastLabel.sizeToFit()
        self.contentView.addSubview(fastLabel)
        fastLabel.translatesAutoresizingMaskIntoConstraints = false
        fastLabel.centerXAnchor.constraint(equalTo: speedChangeSlider.rightAnchor,constant:(10+fastLabel.frame.size.width/2)).isActive = true
        fastLabel.centerYAnchor.constraint(equalTo: speedChangeSlider.centerYAnchor).isActive = true
    }
    @objc public func speedSliderChange(_ sender:UISlider){
        print("早さスライダーが変更されました:\(sender.value)")
        speed = Float(sender.value)
        guard let delegate = delegate else {return}
        let spin : RouletteSpin? = delegate.chnageRouletteSpin(sender.value)
        removeAnimation()
        if spin == RouletteSpin.manual{
            spinManual(sender.value)
        }else if spin == RouletteSpin.semiAuto{
            spinSemiAuto(sender.value)
        }else{
            spinAuto(sender.value)
        }
    }
    private func removeAnimation(){
        speendRouletteView.layer.removeAllAnimations()
    }
    private func spinAuto(_ speed:Float){
        speedAnimationLayer = CABasicAnimation(keyPath: "transform.rotation")
        speedAnimationLayer.isRemovedOnCompletion = false
        speedAnimationLayer.fillMode = .forwards
        speedAnimationLayer.fromValue = 0
        speedAnimationLayer.toValue = -.pi/2.0
        speedAnimationLayer.duration = 0.1
        speedAnimationLayer.isCumulative = true
        speedAnimationLayer.repeatCount = MAXFLOAT
        speendRouletteView.layer.speed = Float.random(in: 5.00*(speed)..<5.25*(speed))
        speendRouletteView.layer.add(speedAnimationLayer, forKey: "spinAnimation")
        speedAnimationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
    }
    @objc func speedDown(_ sender:Timer){
        guard let _ = speedAnimationLayer else{return}
        speendRouletteView.layer.timeOffset = speendRouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        speendRouletteView.layer.beginTime = CACurrentMediaTime()
        if speendRouletteView.layer.speed > 0.0025*speed{
            if speendRouletteView.layer.speed > 1.5*speed{
                speendRouletteView.layer.speed -= 0.05*speed
            }else if speendRouletteView.layer.speed > 0.5*speed{
                speendRouletteView.layer.speed -= 0.025*speed
            }else if speendRouletteView.layer.speed > 0.05*speed{
                speendRouletteView.layer.speed -= 0.015*speed
            }else if speendRouletteView.layer.speed > 0{
                speendRouletteView.layer.speed -= 0.005*speed
            }
        }else{
            speendRouletteView.layer.speed = 0
            guard let _ = speedAnimationTimer else{return}
            speedAnimationTimer.invalidate()
        }
    }
    private func spinSemiAuto(_ speed:Float){
        speedAnimationLayer = CABasicAnimation(keyPath: "transform.rotation")
        speedAnimationLayer.isRemovedOnCompletion = false
        speedAnimationLayer.fillMode = .forwards
        speedAnimationLayer.fromValue = 0
        speedAnimationLayer.toValue = -.pi/2.0
        speedAnimationLayer.duration = 0.1
        speedAnimationLayer.isCumulative = true
        speedAnimationLayer.repeatCount = MAXFLOAT
        speendRouletteView.layer.speed = Float.random(in: 5.00*(speed)..<5.25*(speed))
        speendRouletteView.layer.add(speedAnimationLayer, forKey: "spinAnimation")
        speedAnimationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(speedSemiAuto), userInfo: nil, repeats: false)
    }
    @objc func speedSemiAuto(_ timer:Timer){
        speedAnimationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
    }
    private func spinManual(_ speed:Float){
        speedAnimationLayer = CABasicAnimation(keyPath: "transform.rotation")
        speedAnimationLayer.isRemovedOnCompletion = false
        speedAnimationLayer.fillMode = .forwards
        speedAnimationLayer.fromValue = 0
        speedAnimationLayer.toValue = -.pi/2.0
        speedAnimationLayer.duration = 0.1
        speedAnimationLayer.isCumulative = true
        speedAnimationLayer.repeatCount = MAXFLOAT
        speendRouletteView.layer.speed = Float.random(in: 5.00*(speed)..<5.25*(speed))
        speendRouletteView.layer.add(speedAnimationLayer, forKey: "spinAnimation")
        speedAnimationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(speedStop), userInfo: nil, repeats: false)
    }
    @objc func speedStop(_ timer:Timer){
        speendRouletteView.layer.timeOffset = speendRouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        speendRouletteView.layer.beginTime = CACurrentMediaTime()
        speendRouletteView.layer.speed = 0
    }
}
