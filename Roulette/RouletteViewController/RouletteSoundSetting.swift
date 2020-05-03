//
//  RouletteSoundSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import AVFoundation

extension RouletteViewController:AVAudioPlayerDelegate{
    public func settingRouletteSound(){
        //もしもサウンド設定がnoneのままだった場合は、流さない
        guard let path = Bundle.main.path(forResource: rouletteSound != nil ? rouletteSound.rawValue : "rouletteSound1", ofType: "m4a") else {return}
        do{
            rouletteRotationSound = try? AVAudioPlayer(contentsOf : URL(fileURLWithPath: path))
            rouletteRotationSound.delegate = self
        }catch{
            print("サウンドの再生に失敗しました。")
        }
    }
    public func soundStopSetting(_ number:Int){
        guard let element = elements[number] as? [ElementEnum : Any?] else{return}
        guard let sound = element[.stopSound] as? RouletteStopSound else{return}
        //ストップサウンドに何も選択していなかったら流さない
        guard sound != RouletteStopSound.none else { return }
        guard let stopPath = Bundle.main.path(forResource: sound.rawValue, ofType: "m4a") else {return}
        do{
            rouletteStopSound = try? AVAudioPlayer(contentsOf : URL(fileURLWithPath: stopPath))
            //ルーレットがストップしたとき用のサウンドを流す
            stopSoundPlay()
            print("ストップサウンドが流れました")
        }catch{
            print("ストップサウンドの再生に失敗しました。")
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("オーディオが終了しました")
        if player == rouletteRotationSound{
            player.play()
        }
    }
    public func rouletteSoundStop(){
        guard let rouletteRotationSound = rouletteRotationSound else {return}
        rouletteRotationSound.stop()
    }
    public func stopSoundPlay(){
        guard let rouletteStopSound = rouletteStopSound else{return}
        rouletteStopSound.play()
    }
}
