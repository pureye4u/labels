//
//  LeftViewController.swift
//  Labels
//
//  Created by pureye4u on 24/03/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import Material

class LeftViewController: UIViewController, TextFieldDelegate {
    
    var sizes: [CGFloat] = []
    var fields: [TextField] = []
    var editingField: TextField?
    var scrollView = UIScrollView()
    var fullFrame: CGRect = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedSizes = UserDefaults.standard.array(forKey: "sizes") as? [CGFloat] {
            sizes = storedSizes
        }
        
        view.backgroundColor = .white
        
        let navigationBarHeight = navigationController?.navigationBar.bounds.size.height ?? 0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        fullFrame.size = view.bounds.size
        fullFrame.size.height -= (navigationBarHeight + statusBarHeight)
        scrollView.frame = fullFrame
        view.addSubview(scrollView)
        
        let addButton = UIBarButtonItem(image: Icon.cm.add, style: .plain, target: self, action: #selector(add))
        navigationItem.setLeftBarButton(addButton, animated: false)
        
        let saveButton = UIBarButtonItem(image: Icon.cm.check, style: .plain, target: self, action: #selector(save))
        navigationItem.setRightBarButton(saveButton, animated: false)
        
        self.resetView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func resetView() {
        _ = scrollView.subviews.map { (view: UIView) in
            view.removeFromSuperview()
        }
        
        fields.removeAll()
        var offset: CGFloat = 20
        var frame = scrollView.frame
        let margin: CGFloat = 20
        let btWidth: CGFloat = 30
        let tfWidth = frame.size.width - margin * 2 - 10 - btWidth
        frame.size.height = 30
        for (i, size) in sizes.enumerated() {
            let field = ErrorTextField()
            field.isClearIconButtonEnabled = false
            field.tag = i
            field.text = UInt(size * 10) % 10 == 0 ? String(format: "%d", Int(size)) : String(format: "%1f", size)
            field.font = UIFont.systemFont(ofSize: 14)
            field.delegate = self
            
            frame.origin.x = margin
            frame.origin.y = offset
            frame.size.width = tfWidth
            field.frame = frame
            scrollView.addSubview(field)
            fields.append(field)
            
            let button = IconButton(image: Icon.cm.close)
            button.tag = i
            button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
            frame.origin.x = scrollView.frame.size.width - margin - btWidth
            frame.size.width = btWidth
            button.frame = frame
            scrollView.addSubview(button)
            
            offset += 40
        }
        
//        scrollView.layout(addButton).left(20).right(20).height(30).top(offset + 10)
//        scrollView.layout(saveButton).left(20).right(20).height(30).top(offset + 50)
        scrollView.contentSize = CGSize(width: scrollView.width, height: offset + margin)
    }
    
    func deleteItem(sender: IconButton) {
        let i = sender.tag
        sizes.remove(at: i)
        self.resetView()
    }
    
    func add(sender: RaisedButton) {
        if let last = sizes.last {
            sizes.append(last)
        } else {
            sizes.append(12)
        }
        self.resetView()
        if let field = fields.last {
            let _ = field.becomeFirstResponder()
            field.selectedTextRange = field.textRange(from: field.beginningOfDocument, to: field.endOfDocument)
        }
    }
    
    func save(sender: RaisedButton) {
        self.saveFromFields()
        if let field = editingField {
            field.resignFirstResponder()
        }
        navigationController?.pushViewController(RootViewController(), animated: true)
    }
    
    func saveFromFields() {
        sizes.removeAll()
        for field in fields {
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: field.text!)
            guard let numberFloatValue = number?.floatValue else {
                continue
            }
            sizes.append(CGFloat(numberFloatValue))
        }
        UserDefaults.standard.set(sizes, forKey: "sizes")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let field = textField as? TextField {
            editingField = field
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let field = textField as? TextField {
            let i = field.tag
            if i < sizes.count {
                let numberFormatter = NumberFormatter()
                let number = numberFormatter.number(from: field.text!)
                if let numberFloatValue = number?.floatValue {
                    sizes[i] = CGFloat(numberFloatValue)
                }
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            var frame = CGRect(origin: .zero, size: view.bounds.size)
            frame.size.height -= keyboardHeight
            scrollView.frame = frame
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.frame = fullFrame
    }
}
