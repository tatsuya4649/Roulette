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
    //ルーレットをボタン化させる
    var rouletteButton : UIButton!
    weak var delegate : RouletteViewControllerDelegtate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ルーレット"
        // Do any additional setup after loading the view.
        do{
            try AVAudioSession.sharedInstance().setCategory(.ambient,mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print("オーティオの設定に失敗しました。")
        }
    }
    
    func setUp(){
        
        settingElement()
        settingRouletteSound()
        settingRouletteView()
        arrowDownSetting()
        startButtonSetting()
        
        navigationSetting()
    }
    
    private func settingRouletteView(){
        print(self.view.frame.size.height/self.view.frame.size.width)
        let height = self.view.frame.size.height/self.view.frame.size.width < 1.2 ? min(self.view.frame.size.width*0.6,500) : min(self.view.frame.size.width*0.8,500)
        
        rouletteView = RouletteView(frame:CGRect(x:0,y:0,width:height,height:height),elements: elements,fontColor:elementFontColor)
        rouletteView.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 10)
        self.view.addSubview(rouletteView)
        rouletteButton = UIButton(frame:rouletteView.frame)
        rouletteButton.layer.cornerRadius = rouletteView.layer.cornerRadius
        rouletteButton.center = rouletteView.center
        rouletteButton.addTarget(self, action: #selector(startAnimation), for: .touchUpInside)
        self.view.addSubview(rouletteButton)
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
    
    public func changeTheLayer(){
        guard let _ = rouletteView else{return}
        rouletteView.removeFromSuperview()
        rouletteView = nil
        settingRouletteView()
    }
    public func changeTheSound(){
        settingRouletteSound()
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
