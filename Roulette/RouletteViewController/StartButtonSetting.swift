//
//  StartButtonSetting().swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

protocol RouletteViewControllerDelegtate:AnyObject {
    func startRouletteAnimation()
    func stopRouletteAnimation()
}
extension RouletteViewController{
    public func startButtonSetting(){
        startButton = UIButton()
        startButton.setTitle("ルーレットスタート！", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startButton.titleLabel?.sizeToFit()
        startButton.sizeToFit()
        startButton.removeTarget(nil, action: nil, for: .allEvents)
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        startButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - 10 - startButton.frame.size.height/2)
        self.view.addSubview(startButton)
    }
    public func restartRouletteButton(){
        guard let _ = startButton else{return}
        startButton.removeFromSuperview()
        startButton = nil
        startButton = UIButton()
        startButton.setTitle("ルーレットスタート！", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startButton.titleLabel?.sizeToFit()
        startButton.sizeToFit()
        startButton.removeTarget(nil, action: nil, for: .allEvents)
        startButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        startButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - 10 - startButton.frame.size.height/2)
        self.view.addSubview(startButton)
    }
    @objc func startAnimation(_ sender:UIButton){
        //ルーレットが終わるまで基本設定・テンプレート・テンプレート追加ボタンを押せなくする
        let rouletteSpin : RouletteSpin = self.rouletteSpin != nil ? self.rouletteSpin : RouletteSpin.auto
        if rouletteSpeed == nil{
            rouletteSpeed = Float(2.0)
        }
        if rouletteTime == nil{
            rouletteTime = Float(2.0)
        }
        rouletteButton.isUserInteractionEnabled = false
        switch rouletteSpin {
        case .auto:
            removeStopLabel()
            rouletteSetting()
            startButton.alpha = 0
        case .manual:
            removeStopLabel()
            rouletteManualSetting()
            startButtonToStopButton()
        case .semiAuto:
            removeStopLabel()
            rouletteSemiAutoSetting()
            startButtonToStopButton()
        default:
            break
        }
        guard let delegate = delegate else{return}
        delegate.startRouletteAnimation()
    }
    ///マニュアル・セミオート用のボタンに変換するためのメソッド
    private func startButtonToStopButton(){
        guard let _ = startButton else{return}
        startButton.setTitle("ルーレットストップ！", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        startButton.titleLabel?.sizeToFit()
        startButton.sizeToFit()
        startButton.center = CGPoint(x: self.view.center.x, y: rouletteView.frame.maxY + 20 + startButton.frame.size.height/2)
    }
}
