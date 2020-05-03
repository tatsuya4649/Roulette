//
//  ElementTableCell.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/22.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

protocol ElementTableCellDelegate : AnyObject{
    func colorButtonClick(_ cell:ElementTableCell,_ button:UIButton)
    func areaChangeGetter(_ cell: ElementTableCell, _ area: Float,_ totalArea : Float?)
    func getNowTotalValue(_ cell:ElementTableCell,_ beforeValue:Float)
    func changeRouletteElementTitle(_ cell:ElementTableCell,_ title:String)
    func keyboardCheckTrueElement(_ cell:ElementTableCell)
}

class ElementTableCell: UITableViewCell {
    weak var delegate : ElementTableCellDelegate!
    ///ルーレット領域のカラーボタン
    var colorButton : UIButton!
    var colorButtonLayer : CALayer!
    ///ルーレット領域の名前を入力するテキストフィールド
    var nameTextField : UITextField!
    var numberTextField : UITextField!
    var percentLabel : UILabel!
    var stopSound : RouletteStopSound!
    var hit : RouletteResult!
    var totalArea:Float!
    var beforeValue : Float!
    var basicTitle : UITextField!
    public func setUp(_ width:CGFloat){
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        colorButton = UIButton()
        colorButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        colorButton.layer.cornerRadius = colorButton.frame.size.height/2
        colorButton.layer.shadowColor = UIColor.black.cgColor
        colorButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        colorButton.layer.shadowRadius = 2
        colorButton.layer.shadowOpacity = 0.1
        colorButton.backgroundColor = .white
        colorButton.layer.borderColor = UIColor.black.cgColor
        colorButton.layer.borderWidth = 0.1
        colorButtonLayer = CALayer()
        colorButtonLayer.bounds = CGRect(x: 0, y: 0, width: 0.8*colorButton.frame.size.width, height: 0.8*colorButton.frame.size.height)
        colorButtonLayer.position = CGPoint(x: colorButton.frame.size.width/2, y: colorButton.frame.size.height/2)
        colorButtonLayer.cornerRadius = colorButtonLayer.frame.size.height/2
        colorButtonLayer.backgroundColor = UIColor(red: CGFloat.random(in: 0...255)/255, green: CGFloat.random(in: 0...255)/255, blue: CGFloat.random(in: 0...255)/255, alpha: 1).cgColor
        colorButton.layer.addSublayer(colorButtonLayer)
        colorButton.center = CGPoint(x: 20 + colorButton.frame.size.width/2, y: self.contentView.frame.size.height/2)
        colorButton.addTarget(self, action: #selector(colorButtonClick), for: .touchUpInside)
        self.contentView.addSubview(colorButton)
        nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0.6*(width - colorButton.frame.maxX), height: 30))
        nameTextField.placeholder = "タイトルを入力..."
        nameTextField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        nameTextField.layer.cornerRadius = 5
        nameTextField.font = .systemFont(ofSize: 12)
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
        nameTextField.leftView = UIView(frame: CGRect(x:0, y:0, width:10, height:0))
        nameTextField.leftViewMode = UITextField.ViewMode.always
        nameTextField.center = CGPoint(x: colorButton.frame.maxX + 10 + nameTextField.frame.size.width/2, y: self.contentView.frame.size.height/2)
        nameTextField.addTarget(self, action: #selector(changeRouletteElementTitle), for: .editingChanged)
        self.contentView.addSubview(nameTextField)
        numberTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        numberTextField.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        numberTextField.placeholder = "0~100"
        numberTextField.layer.cornerRadius = 5
        numberTextField.font = .systemFont(ofSize: 12, weight: .semibold)
        numberTextField.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:0))
        numberTextField.leftViewMode = UITextField.ViewMode.always
        numberTextField.keyboardType = .numberPad
        numberTextField.delegate = self
        numberTextField.returnKeyType = .done
        numberTextField.center = CGPoint(x: nameTextField.frame.maxX + 10 + numberTextField.frame.size.width/2, y: self.contentView.frame.size.height/2)
        numberTextField.addTarget(self, action: #selector(areaNumberChange), for: .editingChanged)
        self.contentView.addSubview(numberTextField)
        percentLabel = UILabel()
        percentLabel.text = "%"
        percentLabel.font = .systemFont(ofSize: 12, weight: .light)
        percentLabel.sizeToFit()
        percentLabel.textColor = .gray
        percentLabel.center = CGPoint(x: numberTextField.frame.maxX + 5 + percentLabel.frame.size.width/2, y: self.contentView.frame.size.height/2)
        self.contentView.addSubview(percentLabel)
        stopSound = .stopSound1
        hit = RouletteResult.none
        
        if totalArea != nil{
            if numberTextField.text != nil{
                if let number = Float(numberTextField.text!){
                    totalArea -= number
                }
            }
        }else{
            totalArea = Float(0)
        }
    }
    @objc func changeRouletteElementTitle(_ sender:UITextField){
        guard let title = sender.text else{return}
        guard let delegate = delegate else {return}
        delegate.changeRouletteElementTitle(self,title)
    }
    @objc func colorButtonClick(_ sender:UIButton){
        print("カラーピッカーがクリックされました。")
        guard let delegate = delegate else{return}
        delegate.colorButtonClick(self,sender)
    }
    @objc func areaNumberChange(_ sender:UITextField){
        guard let delegate = delegate else{return}
        delegate.getNowTotalValue(self, beforeValue != nil ? beforeValue : 0)
        guard let text = sender.text else{return}
        print("``````")
        print(beforeValue)
        if var number = Int(text) {
            number =  Int(totalAreaCheck(Float(number)))
            if number > 100{
                number = 100
            }else if number < 0{
                number = 0
            }
            sender.text = "\(number)"
            delegate.areaChangeGetter(self, Float(number),Float(number))
            beforeValue = Float(number)
        }else{
            sender.text = nil
            delegate.areaChangeGetter(self, 0,nil)
            beforeValue = nil
        }
    }
    private func totalAreaCheck(_ number:Float)->Float{
        let changedNumber = totalArea + number
        if changedNumber > 100{
            numberTextField.text = "\(100 - totalArea)"
            return 100 - totalArea
        }else{
            return number
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
