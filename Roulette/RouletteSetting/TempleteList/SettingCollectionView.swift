//
//  SettingCollectionView.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit
import SPAlert
import CoreData

protocol TempleteListDelegate:AnyObject {
    func templeteDidClick(_ cell:TempleteListCell,_ elements:Array<Dictionary<ElementEnum, Any?>>,_ rouletteData:Dictionary<RouletteDataElement,Any?>)
    func templateDataCountZero()
}

extension TempleteListViewController:TempleteCollectionViewLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TempleteCellDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rouletteDataSearchArray != nil ? rouletteDataSearchArray.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TempleteListCell
        for i in cell.contentView.subviews{
            i.removeFromSuperview()
        }
        if let rouletteData = rouletteDataSearchArray[indexPath.item] as? Dictionary<RouletteDataElement,Any?>{
            print(rouletteData)
            if let elements = rouletteData[.elements] as? Array<Dictionary<ElementEnum, Any?>>{
                cell.delegate = self
                cell.elements = elements
                cell.rouletteData = rouletteData
                cell.setUp()
            }
        }
        return cell
    }
    
    public func settingTempleteCollection(){
        collectionViewLayout = TempleteCollectionViewLayout()
        collectionViewLayout.delegate = self
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout:collectionViewLayout)
        collectionView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TempleteListCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView,_ width:CGFloat,heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat{
        if let rouletteData = rouletteDataSearchArray[indexPath.item] as? Dictionary<RouletteDataElement,Any?>,
            let elements = rouletteData[.elements] as? Array<Dictionary<ElementEnum, Any?>>
            {
                return TempleteListCell.cellHeight(width,elements,rouletteData)
        }
        return 0
    }
    ///テンプレートがクリックされたときに行う処理
    ///具体的には、テンプレートからすぐにルーレットページに飛ばす
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TempleteListCell{
            guard let delegate = delegate else{return}
            delegate.templeteDidClick(cell, cell.elements, cell.rouletteData)
        }
    }
    ///セルの削除ボタンが押されたときに呼び出されるデリゲートメソッド(該当のデータを削除する)
    func templateDeleteButtonClick(_ cell:TempleteListCell,_ button:UIButton,_ id:String,_ title:String?){
        //ルーレットを削除してコレクションビューを整理する処理をここから
        for number in 0..<rouletteDataSearchArray.count{
            if collectionView.cellForItem(at: IndexPath(item: number, section: 0)) == cell{
                print(number)
                rouletteDataSearchArray.remove(at: number)
                collectionView.performBatchUpdates({[weak self] in
                    guard let _ = self else{return}
                    self!.collectionView.deleteItems(at: [IndexPath(item: number, section: 0)])
                }, completion: {[weak self] _ in
                    guard let _ = self else{return}
                    self!.removeDataBaseId(id)
                    //配列からもデータを削除しておく
                    self!.rouletteDataArray.remove(at: number)
                    if self!.rouletteDataArray.count == 0{
                        guard let delegate = self!.delegate else{return}
                        delegate.templateDataCountZero()
                    }
                })
            }
        }
        //ユーザーに削除したことを知らせる
        SPAlert.present(title: "\(title != nil ? title! : "ルーレット")を削除しました", message: nil, preset: .done)
    }
    private func removeDataBaseId(_ id:String){
        rouletteData = Array<Roulette>()
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Roulette")
        let predict = NSPredicate(format: "%K=%@", "id", id)
        fetchReq.predicate = predict
        do{
            rouletteData = try rouletteMAnageObjectContext.fetch(fetchReq) as? Array<Roulette>
        }catch{
            print("データの読み込みに失敗しました。")
        }
        for i in rouletteData{
            rouletteMAnageObjectContext.delete(i)
        }
        do{
            try rouletteMAnageObjectContext.save()
        }catch{
            print("データベースの保存に失敗しました。")
        }
    }
}
