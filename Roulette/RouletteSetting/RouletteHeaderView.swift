//
//  RouletteHeaderView.swift
//  Roulette
//
//  Created by 下川達也 on 2020/04/30.
//  Copyright © 2020 下川達也. All rights reserved.
//

import UIKit

protocol RouletteHeaderViewDelegate:AnyObject{
    func rouletteVieChange() -> RouletteViewController
    func startRouletteAnimation()
    func stopRouletteAnimation()
    func toRecommendShare(_ rouletteImage:UIImage)
}
class RouletteHeaderView: UITableViewHeaderFooterView,RouletteViewControllerDelegtate {
    func startRouletteAnimation() {
        guard let delegate = delegate else{return}
        delegate.startRouletteAnimation()
    }
    
    func stopRouletteAnimation() {
        guard let delegate = delegate else{return}
        delegate.stopRouletteAnimation()
    }
    
    func toRecommendShare(_ rouletteImage:UIImage){
        guard let delegate = delegate else{return}
        delegate.toRecommendShare(rouletteImage)
    }
    weak var delegate : RouletteHeaderViewDelegate!
    var rouletteViewController : RouletteViewController!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let delegate = delegate else{return}
        rouletteViewController = delegate.rouletteVieChange()
        rouletteViewController.setUp()
        rouletteViewController.delegate = self
        self.contentView.addSubview(rouletteViewController.view)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
