//
//  RouletteViewController.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/21.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import AVFoundation

class RouletteViewController: UIViewController {

    var rouletteView : RouletteView!
    var spinAnimation : CABasicAnimation!
    var animationTimer : Timer!
    var elements : Array<Dictionary<ElementEnum,Any?>>!
    var startButton : UIButton!
    var rouletteRotationSound : AVAudioPlayer!
    var rouletteStopSound : AVAudioPlayer!
    var arrowDown : UILabel!
    var stopLabel : UILabel!
    var saveRoulette : Bool!
    var elementFontColor : CGColor!
    var rouletteTitle : String!
    var rouletteBackgroundColor : UIColor!
    var rouletteSound : RouletteSound!
    var rouletteSpin : RouletteSpin!
    //セーブ・取り出しのときに必要なプロパティ
    var id : String!
    var rouletteData : Array<Roulette>!
    var newRouletteData : Roulette!
    var rouletteSpeed : Float!
    var rouletteTime : Float!
    var rouletteManageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "ルーレット"
        settingElement()
        settingRouletteSound()
        settingRouletteView()
        arrowDownSetting()
        startButtonSetting()
        
        navigationSetting()
        // Do any additional setup after loading the view.
    }
    
    private func settingRouletteView(){
        rouletteView = RouletteView(frame:CGRect(x:0,y:0,width:self.view.frame.size.width*0.8,height:self.view.frame.size.width*0.8),elements: elements,fontColor:elementFontColor)
        rouletteView.center = self.view.center
        self.view.addSubview(rouletteView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if rouletteRotationSound != nil{
            rouletteRotationSound = nil
        }
        if rouletteStopSound != nil{
            rouletteStopSound = nil
        }
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
