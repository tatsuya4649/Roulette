//
//  RouletteSetting.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/26.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension BasicDetailCellTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spinArray != nil ? spinArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spin", for: indexPath) as! SpinCollectionViewCell
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        cell.setUp(spinArray[indexPath.item])
        if rouletteSpin != nil{
            if RouletteSpin(rawValue: indexPath.item) == rouletteSpin{
                cell.addSelectLayer()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<spinArray.count{
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? SpinCollectionViewCell{
                cell.removeSelectLayer()
            }
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? SpinCollectionViewCell{
            cell.addSelectLayer()
            switch indexPath.item{
            case RouletteSpin.auto.rawValue:
                cell.autoRotation()
            case RouletteSpin.manual.rawValue:
                cell.manualRotation()
            case RouletteSpin.semiAuto.rawValue:
                cell.semiAutoRotation()
            default:
                break
            }
        }
        guard let delegate = delegate else{return}
        guard let spin = RouletteSpin(rawValue: indexPath.item) else{return}
        delegate.changeRouletteSpin(spin)
    }
    
    public func howToTurnSetting(_ spin:RouletteSpin?){
        cellTitleSetting("回り方")
        self.rouletteSpin = spin != nil ? spin! : nil
        spinArray = Array<String>()
        spinArray = [
            "自動",
            "手動",
            "半手動"
        ]
        spinCollectionViewLayout = UICollectionViewFlowLayout()
        spinCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: max(self.frame.size.width - 20 - cellTitle.frame.maxX,150), height: max((self.frame.size.width - 20 - cellTitle.frame.maxX)/3,150)), collectionViewLayout: spinCollectionViewLayout)
        spinCollectionView.register(SpinCollectionViewCell.self, forCellWithReuseIdentifier: "spin")
        spinCollectionView.delegate = self
        spinCollectionView.dataSource = self
        spinCollectionView.center = CGPoint(x: self.frame.size.width - 10 - spinCollectionView.frame.size.width/2, y: self.frame.size.height/2)
        spinCollectionViewLayout.itemSize = CGSize(width: (spinCollectionView.frame.size.width - 10*4)/3, height: spinCollectionView.frame.size.height)
        spinCollectionViewLayout.minimumInteritemSpacing = 5
        spinCollectionView.backgroundColor = .white
        self.contentView.addSubview(spinCollectionView)
        spinCollectionView.translatesAutoresizingMaskIntoConstraints = false
        spinCollectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        spinCollectionView.widthAnchor.constraint(equalToConstant: spinCollectionView.frame.size.width).isActive = true
        spinCollectionView.heightAnchor.constraint(equalToConstant: spinCollectionView.frame.size.height).isActive = true
        spinCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        spinCollectionView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -10.0).isActive = true
        spinCollectionView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
}
enum RouletteSpin:Int{
    case auto = 0
    case manual = 1
    case semiAuto = 2
}


class SpinCollectionViewCell:UICollectionViewCell{
    var rouletteView : RouletteView!
    var spinLabel : UILabel!
    var layerView : UIView!
    var spinAnimation : CABasicAnimation!
    var animationTimer : Timer!
    public func setUp(_ spinTitle:String){
        layerView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width * 1, height: self.contentView.frame.size.height * 0.8))
        layerView.layer.cornerRadius = 15
        layerView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(layerView)
        var elementts = Array<Dictionary<ElementEnum, Any?>>()
        elementts = [
            [
                ElementEnum.stopSound : RouletteStopSound.stopSound1,
                ElementEnum.color : UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 1).cgColor,
                ElementEnum.hit : RouletteResult.none,
                ElementEnum.title : nil,
                ElementEnum.rate : Float(50.0)
            ],
            [
                ElementEnum.stopSound : RouletteStopSound.stopSound1,
                ElementEnum.color : UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 1).cgColor,
                ElementEnum.hit : RouletteResult.none,
                ElementEnum.title : nil,
                ElementEnum.rate : Float(50.0)
            ]
        ]
        rouletteView = RouletteView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * 0.8, height: self.frame.size.width * 0.8), elements: elementts, fontColor: UIColor.black.cgColor)
        rouletteView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.contentView.addSubview(rouletteView)
        spinLabel =  UILabel()
        spinLabel.text = spinTitle
        spinLabel.font = .systemFont(ofSize: 12)
        spinLabel.textColor = .black
        spinLabel.sizeToFit()
        spinLabel.center = CGPoint(x:self.frame.size.width/2,y:rouletteView.frame.maxY + 5 + spinLabel.frame.size.height/2)
        self.contentView.addSubview(spinLabel)
    }
    public func removeSelectLayer(){
        rouletteView.layer.removeAllAnimations()
        spinAnimation = nil
        if animationTimer != nil{
            animationTimer.invalidate()
            animationTimer = nil
        }
        guard let layerView = layerView else{return}
        layerView.layer.borderColor = UIColor.clear.cgColor
        layerView.layer.borderWidth = 0
    }
    public func addSelectLayer(){
        guard let layerView = layerView else{return}
        layerView.layer.borderColor = UIColor.red.cgColor
        layerView.layer.borderWidth = 1
    }
    ///自動回転(スタートからストップまで自動で行う)
    public func autoRotation(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 10.00..<10.50)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
    }
    @objc func speedDown(_ timer:Timer){
        guard let _ = spinAnimation else{return}
        rouletteView.layer.timeOffset = rouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        rouletteView.layer.beginTime = CACurrentMediaTime()
        if rouletteView.layer.speed > 0.005{
            rouletteView.layer.speed -= 0.1
        }else{
            rouletteView.layer.speed = 0
            guard let _ = animationTimer else{return}
            animationTimer.invalidate()
        }
    }
    public func manualRotation(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 10.00..<10.50)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        animationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(speedStop), userInfo: nil, repeats: false)
    }
    @objc func speedStop(_ timer:Timer){
        rouletteView.layer.timeOffset = rouletteView.layer.convertTime(CACurrentMediaTime(), from: nil)
        rouletteView.layer.beginTime = CACurrentMediaTime()
        rouletteView.layer.speed = 0
    }
    public func semiAutoRotation(){
        spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.isRemovedOnCompletion = false
        spinAnimation.fillMode = .forwards
        spinAnimation.fromValue = 0
        spinAnimation.toValue = -.pi/2.0
        spinAnimation.duration = 0.1
        spinAnimation.isCumulative = true
        spinAnimation.repeatCount = MAXFLOAT
        rouletteView.layer.speed = Float.random(in: 10.00..<10.50)
        rouletteView.layer.add(spinAnimation, forKey: "spinAnimation")
        animationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(speedSemiAuto), userInfo: nil, repeats: false)
    }
    @objc func speedSemiAuto(_ timer:Timer){
        animationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(speedDown), userInfo: nil, repeats: true)
    }
}
