//
//  SettingViewController.swift
//  
//
//  Created by 下川達也 on 2020/04/22.
//

import UIKit
import FloatingPanel

class SettingViewController: UIViewController {
    var rouletteViewController : RouletteViewController!
    var rouletteTextField : UITextField!
    var addSettingButton:UIButton!
    var elementTable : UITableView!
    var tableCellNumber : Int!
    var detailSetting : RouletteSettingDetailViewController!
    var colorPickerViewController : ColorPickerViewController!
    var elements : Array<Dictionary<ElementEnum,Any?>>!
    var totalArea : Float!
    var sections : Array<String>!
    var basicSettingViewController : RouletteBasicSettingViewController!
    var rouletteBackgroundColor : UIColor!
    var rouletteElementFontColor : UIColor!
    var rouletteTitle : String!
    var rouletteSound : RouletteSound!
    //データベースから保存したモデルを取り出すときに必要
    var rouletteData : Array<Roulette>!
    var newRouletteData : Roulette!
    var rouletteManageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //テンプレートがあったときに一覧を表示するためのビューコントローラー
    var fpc : FloatingPanelController!
    var templeteViewController : TempleteListViewController!
    var addPanel : Bool!
    var rouletteSpin : RouletteSpin!
    var rouletteSpeed : Float!
    var rouletteTime : Float!
    var tableHeaderRoulette : RouletteHeaderView!
    var tableFooterRoulette : RouletteFooterView!
    //ルーレットを保存・削除するために必要なプロパティ
    var id : String!
    var saveRoulette : Bool!
    var addTemplateButton : UIButton!
    var indexCell : Dictionary<Int,Dictionary<ElementEnum,Any?>>!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "ルーレットセッティング"
        
        //rouletteTextFieldSetting()
        settingElementTable()
        settingPlusButton()
        //ナビゲーションバーのセッティング
        settingNavi()
        settingTemplateAddingButton()
        // Do any additional setup after loading the view.
    }
    
    @objc func goToRoulette(_ sender:UIButton){        
        rouletteViewController = RouletteViewController()
        rouletteViewController.elementFontColor = (rouletteElementFontColor != nil ? rouletteElementFontColor!.cgColor : UIColor.black.cgColor)
        getElementEnum(completion:nil)
        rouletteViewController.elements = elements
        rouletteViewController.rouletteSound = rouletteSound
        rouletteViewController.rouletteSpin = rouletteSpin
        rouletteViewController.rouletteSpeed = rouletteSpeed
        rouletteViewController.rouletteTime = rouletteTime
        rouletteViewController.view.backgroundColor = rouletteBackgroundColor != nil ? rouletteBackgroundColor! : .white
        rouletteViewController.title = rouletteTitle != nil ? rouletteTitle! : "ルーレット"
        rouletteViewController.rouletteTitle = rouletteTitle
        rouletteViewController.rouletteBackgroundColor = rouletteBackgroundColor
        self.navigationController?.pushViewController(rouletteViewController, animated: true)
    }
    ///作成したテーブルビューからそれぞれの要素を取得する
    public func getElementEnum(completion:(()->Void)?){
        if totalArea == nil{
            totalArea = Float(0)
        }
        elements = Array<Dictionary<ElementEnum,Any?>>()
        var nilNumber = Float(0)
        print(tableCellNumber)
        
        for i in 0..<tableCellNumber{
            //print(elementTable.cellForRow(at: IndexPath(row: i, section: 0)))
            if let element = indexCell[i]{
                print(element[.rate]!)
                print(element[.rate]! == nil)
                
                if element[.rate]! == nil{
                    nilNumber += 1
                    print(nilNumber)
                    
                }
            }
        }
        //for i in elements{
            //if i[.rate] == nil{
                //nilNumber += 1
            //}
        //}
        //テーブルセルの数からセルを特定して要素を取得する
        for i in 0..<tableCellNumber{
            if var element = indexCell[i]{
                if element[.rate]! == nil{
                    element[.rate]! = (100-totalArea)/nilNumber      
                }
                elements.append(element)
                //elements.append([
                    //.title : cell.nameTextField.text,
                    //.color : cell.colorButtonLayer.backgroundColor,
                    //.rate : ( cell.numberTextField.text!.count != 0 ? Float(cell.numberTextField.text!) : (100-totalArea)/nilNumber),
                    //.stopSound : cell.stopSound,
                    //.hit : cell.hit != nil ? cell.hit : RouletteResult.none
                //])
            }
        }
        //for i in 0..<elements.count{
            //if elements[i][.rate] == nil{
                //elements[i][.rate] = (100-totalArea)/nilNumber
            //}
        //}
        print(elements)
        
        completion?()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if fpc != nil{
            fpc.removePanelFromParent(animated: false)
            addPanel = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(_ notification:Notification){
        guard let userInfo = notification.userInfo else{return}
        guard let keyBoardRect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect else{return}
        guard let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else{return}
        print(notification)
        let transformY = -keyBoardRect.height
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {[weak self] in
            guard let _ = self else{return }
            self!.view.transform = CGAffineTransform(translationX: 0, y: transformY)
        }, completion: nil)
    }
    @objc func keyboardWillHide(_ notification:Notification){
        guard let userInfo = notification.userInfo else{return}
        guard let keyBoardRect = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect else{return}
        guard let duration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] else{return}
        print(keyBoardRect)
        print(duration)
        let transformY = keyBoardRect.height
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
    }

}
