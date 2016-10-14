//
//  ViewController.swift
//  UIFloatLabelTextInput
//
//  Created by Dirk Fabisch on 07.09.14.
//  Copyright (c) 2014 Dirk Fabisch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  @IBOutlet weak var firstNameTextField: B68UIFloatLabelTextField!
  @IBOutlet weak var lastNameTextField: B68UIFloatLabelTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // set for the lastNameTextField the placeHolder with an other dynamic text type
    firstNameTextField.placeHolderTextSize = UIFontTextStyle.subheadline.rawValue
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func dismissKeyboard(_ sender: AnyObject) {
    view.endEditing(true)
  }

 
  @IBAction func setTextForFirstName(_ sender: AnyObject) {
    firstNameTextField.text = "Firstname Dirk Fabisch"
  }
  
  @IBAction func addTextForSecondTextFiels (_ sender: AnyObject) {
    lastNameTextField.text = "Lastname Dirk Fabisch"
  }
}

