//
//  SettingRouletteAnimation.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import StoreKit

extension RouletteViewController{
    public func rouletteSetting(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 5.0*rouletteSpeed..<5.25*rouletteSpeed)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
        guard let rouletteRotationSound = rouletteRotationSound else {return}
        rouletteRotationSound.play()
    }
    public func rouletteManualSetting(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 5.0*rouletteSpeed..<5.25*rouletteSpeed)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        startButton.removeTarget(nil, action: nil, for: .allEvents)
        startButton.addTarget(self, action: #selector(stopAnimation), for: .touchUpInside)
        guard let rouletteRotationSound = rouletteRotationSound else {return}
        rouletteRotationSound.play()
    }
    @objc func stopAnimation(_ sender:UIButton){
        guard let _ = spinAnimation else{return}
        rouletteView.layer.timeOffset = rouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        rouletteView.layer.beginTime = CACurrentMediaTime()
        rouletteView.layer.speed = 0
        startButton.isUserInteractionEnabled = false
        startButton.alpha = 0
        rouletteSoundStop()
        getNowAnimationAngle()
    }
    public func rouletteSemiAutoSetting(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 5.0*rouletteSpeed..<5.25*rouletteSpeed)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        startButton.removeTarget(nil, action: nil, for: .allEvents)
        startButton.addTarget(self, action: #selector(semiStopAnimation), for: .touchUpInside)
        guard let rouletteRotationSound = rouletteRotationSound else {return}
        rouletteRotationSound.play()
    }
    @objc func semiStopAnimation(_ sender:UIButton){
        startButton.isUserInteractionEnabled = false
        startButton.alpha = 0
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
    }
    ///ストップしたときの止まった角度を取得する関数
    private func getNowAnimationAngle(){
        guard let rouletteView = rouletteView else {return}
        let transform = rouletteView.layer.presentation()!.transform
        let radian = atan2(transform.m12,transform.m11)
        var angle = 360 - (radian * 180 / CGFloat(Double.pi))
        print(angle)
        if angle < 0{
            while angle<0{
                angle += 360
            }
        }
        if angle > 360{
            while angle>360 {
                angle -= 360
            }
        }
        print("結果の角度は...\(angle)")
        guard let number = rouletteView.returnElementFromAngle(angle) else{return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let _ = self else{return}
            self!.addStopLabelSetting(number)
            self!.soundStopSetting(number)
            self!.startButton.alpha = 1
            self!.startButton.isUserInteractionEnabled = true
            self!.restartRouletteButton()
            //ルーレットが終わるまで戻れなくする
            self!.navigationItem.setHidesBackButton(false, animated: true)
            //ルーレットが終了したらレビュー評価リクエストを出す
            SKStoreReviewController.requestReview()
        }
    }
    @objc func speedDown(_ timer:Timer){
        guard let _ = spinAnimation else{return}
        startButton.isUserInteractionEnabled = false
        rouletteView.layer.timeOffset = rouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        rouletteView.layer.beginTime = CACurrentMediaTime()
        print(rouletteView.layer.speed)
        print(rouletteTime)
        
        if rouletteView.layer.speed > 0.0025*rouletteSpeed{
            if rouletteView.layer.speed > 1.5*rouletteSpeed{
                rouletteView.layer.speed -= 0.1*rouletteSpeed/rouletteTime
            }else if rouletteView.layer.speed > 0.5*rouletteSpeed{
                rouletteView.layer.speed -= 0.05*rouletteSpeed/rouletteTime
            }else if rouletteView.layer.speed > 0.05*rouletteSpeed{
                rouletteView.layer.speed -= 0.03*rouletteSpeed/rouletteTime
            }else if rouletteView.layer.speed > 0{
                rouletteView.layer.speed -= 0.01*rouletteSpeed/rouletteTime
            }
        }else{
            rouletteView.layer.speed = 0
            //ルーレット中のサウンドを消す
            rouletteSoundStop()
            getNowAnimationAngle()
            guard let _ = animationTimer else{return}
            animationTimer.invalidate()
        }
    }
}
