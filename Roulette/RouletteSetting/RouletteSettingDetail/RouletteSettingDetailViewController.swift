//
//  RouletteSettingDetailViewController.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/23.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

class RouletteSettingDetailViewController: UIViewController {
    
    var elementTable : UITableView!
    var elementDetailTitleArray : Array<String>!
    ///詳細ページの1つ前の画面のセル(詳細ページを変更したら同時にこっちも変更させる)
    var cell : ElementTableCell!
    var titleText : String?
    var colorBackgroundColor : CGColor!
    var areaText : String?
    var hit : RouletteResult!
    var stopSound : RouletteStopSound!
    var colorPickerViewController : ColorPickerViewController!
    var totalArea : Float!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        elementTableSetting()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
