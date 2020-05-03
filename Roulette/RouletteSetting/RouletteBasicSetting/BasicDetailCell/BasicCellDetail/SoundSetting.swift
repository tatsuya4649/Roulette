//
//  SoundSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension BasicDetailCellTableViewCell:UIPickerViewDelegate,UIPickerViewDataSource{
    
    public func rouletteSound(_ nowSound:RouletteSound?){
        cellTitleSetting("ルーレット中")
        soundSource = Array<RouletteSound>()
        soundSource = [
            .sound1,
            .sound2,
            .sound3,
            .sound4,
            .sound5,
            .none
        ]
        soundNameArray = Array<String>()
        soundNameArray = [
            "ドラムロール1",
            "ドラムロール2",
            "ティンパニロール",
            "鼓動",
            "クッキング",
            "音無し"
        ]
        soundPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0.6*(self.frame.size.width - cellTitle.frame.maxX), height: 50))
        soundPicker.delegate = self
        soundPicker.dataSource = self
        soundPicker.center = CGPoint(x:self.frame.size.width - 10 - soundPicker.frame.size.width/2,y:self.contentView.frame.size.height/2)
        self.contentView.addSubview(soundPicker)
        
        guard let nowSound = nowSound else{return}
        switch nowSound{
        case .sound1:
            soundPicker.selectRow(0, inComponent: 0, animated: false)
        case .sound2:
            soundPicker.selectRow(1, inComponent: 0, animated: false)
        case .sound3:
            soundPicker.selectRow(2, inComponent: 0, animated: false)
        case .sound4:
            soundPicker.selectRow(3, inComponent: 0, animated: false)
        case .sound5:
            soundPicker.selectRow(4, inComponent: 0, animated: false)
        case .none:
            soundPicker.selectRow(5, inComponent: 0, animated: false)
        default:break
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = soundNameArray[row]
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return soundSource != nil ? soundSource.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let delegate = delegate else{return}
        delegate.changeRouletteSound(self,soundSource[row])
        removeAVAudioPlayer()
        guard let soundSource = soundSource else {return}
        guard let path = Bundle.main.path(forResource: soundSource[row].rawValue, ofType: "m4a") else {return}
        guard soundSource[row] != .none else{return}
        do{
            rouletteRotationSound = try? AVAudioPlayer(contentsOf : URL(fileURLWithPath: path))
            rouletteRotationSound.play()
        }catch{
            print("サウンドの再生に失敗しました。")
        }
    }
    ///ページから離れるときに呼び出して、オーディオを止めるための関数
    public func stopSound(){
        removeAVAudioPlayer()
    }
    private func removeAVAudioPlayer(){
        guard let _ = rouletteRotationSound else{return}
        rouletteRotationSound = nil
    }
}
