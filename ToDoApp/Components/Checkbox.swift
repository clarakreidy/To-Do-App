//
//  Checkbox.swift
//  ToDoApp
//
//  Created by Clara Elkreidy on 12/12/2021.
//

import UIKit

class Checkbox: UIButton {

    let checkedImage = UIImage(named: "ok")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setBackgroundImage(checkedImage, for: UIControl.State.normal)
                
            } else {
                self.setBackgroundImage(nil, for: UIControl.State.normal)
            }
        }
    }
        
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
        self.isUserInteractionEnabled = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }

}
