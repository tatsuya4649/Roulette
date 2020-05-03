//
//  TempleteListViewController.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/25.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

enum RouletteDataElement{
    case id
    case elements
    case elementFontColor
    case rouletteSound
    case rouletteSpin
    case rouletteSpeed
    case rouletteTime
    case rouletteTitle
    case rouletteBackgroundColor
    case saveData
}

class TempleteListViewController: UIViewController {
    
    weak var delegate : TempleteListDelegate!
    var rouletteData : Array<Roulette>!
    var rouletteMAnageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var collectionView : UICollectionView!
    var collectionViewLayout : TempleteCollectionViewLayout!
    var rouletteDataArray : Array<Dictionary<RouletteDataElement,Any?>>!
    var rouletteDataSearchArray : Array<Dictionary<RouletteDataElement,Any?>>!
    var searchBar : UISearchBar!
    var editNow : Bool!
    var surfaceHeigt:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if rouletteData != nil{
            rouletteDataToArray()
        }
        settingSearchBarInNavigation()
        settingTempleteCollection()
        
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
