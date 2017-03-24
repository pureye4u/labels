//
//  RootViewController.swift
//  Labels
//
//  Created by pureye4u on 24/03/2017.
//  Copyright © 2017 slowslipper. All rights reserved.
//

import UIKit
import Material

class RootViewController: UIViewController {
    
    var sizes: [CGFloat] = []
    var text = ""
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedSizes = UserDefaults.standard.array(forKey: "sizes") as? [CGFloat] {
            sizes = storedSizes
        } else {
            sizes = [12, 13, 14, 15, 16, 17, 18, 19, 20, 30, 40, 50]
            UserDefaults.standard.set(sizes, forKey: "sizes")
        }
        if let storedText = UserDefaults.standard.string(forKey: "text") {
            text = storedText
        } else {
            text = "Labels"
            UserDefaults.standard.set(text, forKey: "text")
        }
        
        view.backgroundColor = .white
        
        var frame = CGRect(origin: .zero, size: view.bounds.size)
        frame.size.height -= 40
        scrollView.frame = frame
        view.addSubview(scrollView)
        
        let editButton = UIBarButtonItem(image: Icon.cm.pen, style: .plain, target: self, action: #selector(edit))
        navigationItem.setRightBarButton(editButton, animated: false)
        
        self.resetView()
    }
    
    func resetView() {
        if let storedText = UserDefaults.standard.string(forKey: "text") {
            text = storedText
        }
        
        _ = scrollView.subviews.map { (view: UIView) in
            view.removeFromSuperview()
        }
        
        var offset: CGFloat = 20
        var frame = scrollView.frame
        let margin: CGFloat = 20
        let tfWidth = frame.size.width - margin * 2
        var maxWidth: CGFloat = 0
        frame.size.height = 30
        for (i, size) in sizes.enumerated() {
            frame.origin.x = margin
            frame.origin.y = offset
            frame.size.width = tfWidth

            let label = UILabel(frame: frame)
            label.tag = i
            label.font = UIFont.systemFont(ofSize: size)
            label.backgroundColor = .black
            label.textColor = .white
            label.text = text
            label.sizeToFit()
//            frame.size = label.frame.size
            scrollView.addSubview(label)
            
            if(label.frame.size.width > maxWidth) {
                maxWidth = label.frame.size.width
            }
            offset += label.frame.size.height + 1
        }
        scrollView.contentSize = CGSize(width: maxWidth + margin * 2, height: offset + margin * 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func edit() {
        print("Edit")
        let editViewController = TextEditViewController()
        editViewController.delegate = self
        self.present(editViewController, animated: true, completion: nil)
    }

}
