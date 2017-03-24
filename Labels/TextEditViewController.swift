//
//  TextEditViewController.swift
//  Labels
//
//  Created by pureye4u on 25/03/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import Material

class TextEditViewController: UIViewController {
    
    var field = ErrorTextField()
    var delegate: RootViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let closeButton = IconButton(image: Icon.cm.close)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.layout(closeButton).top(30).right(10)
        
        let saveButton = RaisedButton(title: "Submit", titleColor: .white)
        saveButton.pulseColor = .white
        saveButton.backgroundColor = Color.blue.base
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.layout(saveButton).center().left(20).right(20)
        
        let storedText = UserDefaults.standard.string(forKey: "text") ?? ""
        field.isClearIconButtonEnabled = true
        field.placeholder = "Text for label"
        field.text = storedText
        field.font = UIFont.systemFont(ofSize: 22)
        view.layout(field).center(offsetY: -saveButton.height * 0.5 - field.height - 30).left(20).right(20)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        UserDefaults.standard.set(field.text, forKey: "text")
        if delegate != nil {
            delegate?.resetView()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
