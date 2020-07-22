//
//  UITextFieldAddingDoneButton.swift
//  Roulette
//
//  Created by 下川達也 on 2020/05/03.
//  Copyright © 2020 下川達也. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
 func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
    let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
    let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
    let toolbar: UIToolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.isTranslucent = true
    toolbar.backgroundColor = .white
    toolbar.items = [
        UIBarButtonItem(title: "キャンセル", style: .plain, target: onCancel.target, action: onCancel.action),
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        UIBarButtonItem(title: "完了", style: .done, target: onDone.target, action: onDone.action)
    ]
    toolbar.sizeToFit()
    self.inputAccessoryView = toolbar
 }

 // Default actions:
 @objc func doneButtonTapped() { self.resignFirstResponder() }
 @objc func cancelButtonTapped() { self.resignFirstResponder() }
}

