//
//  RouletteBasicSettingViewController.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

protocol RouletteBasicSettingDelegate:AnyObject {
    func changeTitle(_ title:String)
    func changeBackgroundColor(_ rouletteBackgroundColor:UIColor)
    func chnageElementFontColor(_ rouletteElementFontColor:UIColor)
    func changeRouletteSound(_ sound:RouletteSound)
    func changeRouletteSpin(_ spin:RouletteSpin)
    func changeRouletteSpeed(_ speed:Float)
    func changeRouletteTime(_ time:Float)
}

class RouletteBasicSettingViewController: UIViewController {

    weak var delegate:RouletteBasicSettingDelegate!
    var basicTable : UITableView!
    var sections : Array<String>!
    var rouletteTitle : String!
    var rouletteBackgroundColor:UIColor!
    var rouletteElementFontColor:UIColor!
    var colorPicker : ColorPickerViewController!
    var rouletteSound : RouletteSound!
    var rouletteSpin : RouletteSpin!
    var rouletteSpeed : Float!
    var rouletteTime : Float!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        basicTableViewSetting()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSound()
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
