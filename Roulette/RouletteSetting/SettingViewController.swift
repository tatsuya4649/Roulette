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
    var keyBoardCheck : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "ルーレットセッティング"
        
        //rouletteTextFieldSetting()
        settingElementTable()
        settingPlusButton()
        settingNavi()
        // Do any additional setup after loading the view.
    }
    @objc func goToRoulette(_ sender:UIButton){        
        rouletteViewController = RouletteViewController()
        rouletteViewController.elementFontColor = (rouletteElementFontColor != nil ? rouletteElementFontColor!.cgColor : UIColor.black.cgColor)
        getElementEnum()
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
    private func getElementEnum(){
        elements = Array<Dictionary<ElementEnum,Any?>>()
        if totalArea == nil{
            totalArea = Float(0)
        }
        var nilNumber = Float(0)
        for i in 0..<tableCellNumber{
            if let cell = elementTable.cellForRow(at: IndexPath(row: i, section: 1)) as? ElementTableCell{
                if cell.numberTextField.text!.count == 0{
                    nilNumber += 1
                }
            }
        }
        //テーブルセルの数からセルを特定して要素を取得する
        for i in 0..<tableCellNumber{
            if let cell = elementTable.cellForRow(at: IndexPath(row: i, section: 1)) as? ElementTableCell{
                print((100-totalArea)/nilNumber)
                elements.append([
                    .title : cell.nameTextField.text,
                    .color : cell.colorButtonLayer.backgroundColor,
                    .rate : ( cell.numberTextField.text!.count != 0 ? Float(cell.numberTextField.text!) : (100-totalArea)/nilNumber),
                    .stopSound : cell.stopSound,
                    .hit : cell.hit != nil ? cell.hit : RouletteResult.none
                ])
            }
        }        
    }
    public func addingNaviButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(goToRoulette))
    }
    public func removeNaviButton(){
        self.navigationItem.rightBarButtonItem = nil
    }
    public func removeCellCheck(){
        if tableCellNumber > 0{
            addingNaviButton()
        }else{
            removeNaviButton()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
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
        guard keyBoardCheck == nil else{return}
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
        keyBoardCheck = nil
    }

}
