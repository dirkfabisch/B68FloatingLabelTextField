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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func dismissKeyboard(sender: AnyObject) {
    view.endEditing(true)
  }

 
  @IBAction func setTextForFirstName(sender: AnyObject) {
    firstNameTextField.text = "Firstname Dirk Fabisch"
  }
  
  @IBAction func addTextForSecondTextFiels (sender: AnyObject) {
    lastNameTextField.text = "Lastname Dirk Fabisch"
  }
}

