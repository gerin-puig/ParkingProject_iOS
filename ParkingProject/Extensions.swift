//
//  Extensions.swift
//  ParkingProject
//
//  Created by Gerin Puig on 2021-05-23.
//

import UIKit

private var maxLengths = [UITextField:Int]()

extension UITextField{
    
    @IBInspectable var maxLength:Int{
        get{
            guard let length = maxLengths[self] else {
                return 100
            }
            return length
        }
        set{
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField){
        guard let userText = textField.text, userText.count > maxLength else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = userText.index(userText.startIndex, offsetBy: maxLength)
        //text = userText.substring(to: maxCharIndex)
        text = String(userText[..<maxCharIndex])
        isSelected = (selection != nil)
    }
}

extension UIViewController{
    func showAlert(title:String,msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
