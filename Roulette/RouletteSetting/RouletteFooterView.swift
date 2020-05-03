//
//  RouletteFooterView.swift
//  Roulette
//
//  Created by 下川達也 on 2020/05/01.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol RouletteFooterViewDelegate:AnyObject {
    //func elementAddButtonClick(_ button:UIButton)
}

class RouletteFooterView: UITableViewHeaderFooterView {
    var button : UIButton!
    weak var delegate : RouletteFooterViewDelegate!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpButton(){
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setTitle(String.fontAwesomeIcon(name: .chevronDown), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        button.sizeToFit()
        button.titleLabel?.sizeToFit()
        button.center = self.contentView.center
        button.addTarget(self, action: #selector(elementAdd(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        self.contentView.backgroundColor = .clear
        self.backgroundView = UIView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        button.center = self.contentView.center
    }
    @objc func elementAdd(_ sender:UIButton){
        print("クリックされたので要素を1つ追加します。")
        //guard let delegate = delegate else{return}
        //delegate.elementAddButtonClick(sender)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
