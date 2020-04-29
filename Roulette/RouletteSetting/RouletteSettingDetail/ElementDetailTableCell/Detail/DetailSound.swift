//
//  DetailSound.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum RouletteSound:String{
    case sound1 = "rouletteSound1"
    case sound2 = "rouletteSound2"
    case sound3 = "rouletteSound3"
    case sound4 = "rouletteSound4"
    case sound5 = "rouletteSound5"
    case none = "none"
}
extension ElementDetailTableCell:UIPickerViewDataSource,UIPickerViewDelegate{
    
    public func detailSoundSetting(){
        detailSoundPickerArray = Array<RouletteSound>()
        detailSoundPickerArray = [
            .sound1,
            .sound2,
            .sound3,
            .sound4,
            .sound5
        ]
        detailSoundPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0.5*(self.frame.size.width - titleLabel.frame.maxX), height: 70))
        detailSoundPicker.center = CGPoint(x: self.frame.size.width - 10 - detailSoundPicker.frame.size.width/2,y: self.contentView.frame.size.height/2)
        detailSoundPicker.delegate = self
        detailSoundPicker.dataSource = self
        self.contentView.addSubview(detailSoundPicker)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == detailSoundPicker{
            return detailSoundPickerArray != nil ? detailSoundPickerArray[row].rawValue : nil
        }else{
            return detailStopSoundPickerArray != nil ? detailStopSoundPickerArray[row].rawValue : nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == detailStopSoundPicker{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            label.textAlignment = .center
            label.text = detailStopSoundNameArray != nil ? detailStopSoundNameArray[row] : nil
            label.font = .systemFont(ofSize: 13, weight: .regular)
            label.textColor = .black
            return label
        }else{
            return UIView()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == detailSoundPicker{
            return detailSoundPickerArray != nil ? detailSoundPickerArray.count : 0
        }else{
            return detailStopSoundPickerArray != nil ? detailStopSoundPickerArray.count : 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == detailSoundPicker{
            guard let delegate = delegate else{return}
            delegate.rouletteChangeSound(self, detailSoundPickerArray[row])
        }else{
            guard let delegate = delegate else{return}
            delegate.rouletteChangeStopSound(self, detailStopSoundPickerArray[row])
            guard let detailStopSoundPickerArray = detailStopSoundPickerArray else {return}
            guard let path = Bundle.main.path(forResource: detailStopSoundPickerArray[row].rawValue, ofType: "m4a") else {return}
            guard detailStopSoundPickerArray[row] != .none else{return}
            do{
                rouletteStopSoundPlayer = try? AVAudioPlayer(contentsOf : URL(fileURLWithPath: path))
                rouletteStopSoundPlayer.play()
            }catch{
                print("サウンドの再生に失敗しました。")
            }
        }
    }
    private func removeAVAudioPlayer(){
        guard let _ = rouletteStopSoundPlayer else{return}
        rouletteStopSoundPlayer = nil
    }

}
