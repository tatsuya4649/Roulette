//
//  ElementDetailTableCell.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import AVFoundation

class ElementDetailTableCell: UITableViewCell {

    ///詳細設定の変更を反映させるためのデリゲートメソッド
    weak var delegate : DetailSettingDelegate!
    var titleLabel : UILabel!
    ///詳細設定のタイトル入力のためのテキストフィールド
    var detailTitleTextField : UITextField!
    ///詳細設定のカラー設定のためのカラーボタン
    var detailColorButton : UIButton!
    var detailColorButtonLayer : CALayer!
    ///詳細設定のエリア設定のためのテキストフィールド
    var detailAreaTextField : UITextField!
    var detailAreaPercent : UILabel!
    ///詳細設定のサウンド設定のためのボタン
    var detailSoundPicker : UIPickerView!
    var detailSoundPickerArray : Array<RouletteSound>!
    ///詳細設定のサウンド設定のためのボタン
    var detailStopSoundPicker : UIPickerView!
    var detailStopSoundPickerArray : Array<RouletteStopSound>!
    var detailStopSoundNameArray : Array<String>!
    ///詳細設定の結果設定のためのセグメントやつ
    var detailResultSegment : UISegmentedControl!
    ///現在の指定されたトータルの数値0~100%
    var totalArea : Float!
    var beforeValue : Float!
    var rouletteStopSoundPlayer : AVAudioPlayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
