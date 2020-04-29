//
//  BasicDetailCellTableViewCell.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import AVFoundation

protocol BasicDetailCellDelegate:AnyObject {
    func changeRouletteTitle(_ cell:BasicDetailCellTableViewCell,_ title:String)
    func clickDesignButton(_ button:ColorButton,_ cell:BasicDetailCellTableViewCell,_ design:BasicSettingColor)
    func changeRouletteSound(_ cell:BasicDetailCellTableViewCell,_ sound:RouletteSound)
    func changeRouletteSpin(_ spin:RouletteSpin)
    func chnageRouletteSpin(_ speed:Float) -> RouletteSpin?
    func changeRouletteTime(_ time:Float)
}

class BasicDetailCellTableViewCell: UITableViewCell {

    weak var delegate : BasicDetailCellDelegate!
    var titleText : UITextField!
    var cellTitle : UILabel!
    var backgroundColorButton : ColorButton!
    var fontColorButton : ColorButton!
    var soundPicker : UIPickerView!
    var soundSource : Array<RouletteSound>!
    var soundNameArray : Array<String>!
    var spinCollectionView : UICollectionView!
    var spinCollectionViewLayout : UICollectionViewFlowLayout!
    var spinArray : Array<String>!
    var rouletteSpin : RouletteSpin!
    //ルーレットのスピード調節に関するプロパティ
    var speendRouletteView : RouletteView!
    var speedChangeSlider : UISlider!
    var speedAnimationLayer : CABasicAnimation!
    var speedAnimationTimer : Timer!
    var speed : Float!
    //ルーレットの時間調節に関するプロパティ
    var time : Float!
    var timeRouletteView : RouletteView!
    var timeChangeSlider : UISlider!
    var timeAnimationLayer : CABasicAnimation!
    var timeAnimationTimer : Timer!
    var rouletteRotationSound : AVAudioPlayer!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
