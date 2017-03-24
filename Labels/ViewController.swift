//
//  ViewController.swift
//  Labels
//
//  Created by pureye4u on 24/03/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import Material

class ViewController: UIViewController, TextFieldDelegate {
    fileprivate var textField: ErrorTextField!
    fileprivate var sizeField: ErrorTextField!
    fileprivate var label: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sizeField = ErrorTextField()
        sizeField.text = "12"
        sizeField.placeholder = "Size"
        sizeField.detail = "Insert size of label"
        sizeField.isClearIconButtonEnabled = true
        sizeField.delegate = self
        view.layout(sizeField).bottom(20).left(20).right(20)
        
        textField = ErrorTextField()
        textField.text = "TEST"
        textField.placeholder = "Text"
        textField.detail = "Insert text"
        textField.isClearIconButtonEnabled = true
        textField.delegate = self
        view.layout(textField).bottom(70).left(20).right(20)
        
        label.backgroundColor = .black
        label.textColor = .white
        label.font = Font.systemFont(ofSize: 12)
        label.text = "TEST"
        view.layout(label).center()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resize() {
        label.text = textField.text
        
        let numberFormatter = NumberFormatter()
        let number = numberFormatter.number(from: self.sizeField.text!)
        guard let numberFloatValue = number?.floatValue else {
            return
        }
        
        label.font = Font.systemFont(ofSize: CGFloat(numberFloatValue))
    }
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
//    }
//
//    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
//        return true
//    }
//    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
//        return true
//    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resize()
        return true
    }
}
