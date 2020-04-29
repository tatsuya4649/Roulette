//
//  SearchBarInNavigationBar.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/26.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension TempleteListViewController:UISearchBarDelegate{
    public func settingSearchBarInNavigation(){
        guard let navi = self.navigationController else { return }
        searchBar = UISearchBar(frame: navi.navigationBar.bounds)
        searchBar.delegate = self
        searchBar.placeholder = "タイトルで検索"
        searchBar.tintColor = .gray
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(collectionEdit))
            //UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(collectionEdit))
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("検索開始")
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("検索ボタンが押されましたよ")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        //キャンセルが押されたら元に戻す
        rouletteDataSearchArray = rouletteDataArray
        collectionView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        ///コレクションビューに表示されているルーレットのタイトルに真苗が含まれているものを探しだす処理をここから
        if searchText.count == 0{
            rouletteDataSearchArray = rouletteDataArray
        }else{
            rouletteDataSearchArray.removeAll()
            for roulette in rouletteDataArray{
                if let title = roulette[.rouletteTitle] as? String{
                    if title.contains(searchText){
                        rouletteDataSearchArray.append(roulette)
                    }
                }
            }
        }
        collectionView.reloadData()
    }
    @objc func collectionEdit(_ sender:UIBarButtonItem){
        if editNow == nil{
            guard let rouletteDataArray = rouletteDataArray else{return}
            let count = rouletteDataArray.count
            print(count)
            for i in rouletteDataArray{
                print(i[.id])
            }
            
            for i in 0..<count{
                if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? TempleteListCell{
                    cell.addRemoveButton()
                }
            }
            editNow = Bool(true)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(collectionEdit))
        }else{
            guard let rouletteDataArray = rouletteDataArray else{return}
            let count = rouletteDataArray.count
            for i in 0..<count{
                if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? TempleteListCell{
                    cell.removeRemoveButton()
                }
            }
            editNow = nil
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .edit, style: .regular, textColor: .black, size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(collectionEdit))
        }
        
    }
}
