//
//  B68UIFloatLabelTextField.swift
//  UIFloatLabelTextInput
//
//  Created by Dirk Fabisch on 07.09.14.
//  Copyright (c) 2014 Dirk Fabisch. All rights reserved.
//

import UIKit

open class B68UIFloatLabelTextField: UITextField {
  
  /**
  The floating label that is displayed above the text field when there is other
  text in the text field.
  */
  open var floatingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  
  /**
  The color of the floating label displayed above the text field when it is in
  an active state (i.e. the associated text view is first responder).
  
  @discussion Note: Default Color is blue.
  */
  @IBInspectable open var activeTextColorfloatingLabel : UIColor = UIColor.blue {
    didSet {
      floatingLabel.textColor = activeTextColorfloatingLabel
    }
  }
  /**
  The color of the floating label displayed above the text field when it is in
  an inactive state (i.e. the associated text view is not first responder).
  
  @discussion Note: 70% gray is used by default if this is nil.
  */
  @IBInspectable open var inactiveTextColorfloatingLabel : UIColor = UIColor(white: 0.7, alpha: 1.0) {
    didSet {
      floatingLabel.textColor = inactiveTextColorfloatingLabel
    }
  }
  
  /**
   The default dynamic test size
  */
  open var placeHolderTextSize : String = UIFontTextStyle.caption2.rawValue {
    didSet {
      floatingLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: placeHolderTextSize))
    }
  }
  
  /**
  Used to cache the placeholder string.
  */
  fileprivate var cachedPlaceholder = NSString()
  
  /**
  Used to draw the placeholder string if necessary. Starting value is true.
  */
  fileprivate var shouldDrawPlaceholder = true
  
  /**
  default padding for floatingLabel
  */
  open var verticalPadding : CGFloat = 0
  open var horizontalPadding : CGFloat = 0
  
  
  //MARK: Initializer
  //MARK: Programmatic Initializer
  
  override convenience init(frame: CGRect) {
    self.init(frame: frame)
    setup()
  }
  
  //MARK: Nib/Storyboard Initializers
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  //MARK: Unsupported Initializers
  init () {
    fatalError("Using the init() initializer directly is not supported. use init(frame:) instead")
  }
  
  //MARK: Deinit
  deinit {
    // remove observer
    NotificationCenter.default.removeObserver(self)
  }
  
  
  //MARK: Setter & Getter
  override open var placeholder : String? {
    get {
      return super.placeholder
    }
    set (newValue) {
      super.placeholder = newValue
      if (cachedPlaceholder as String != newValue) {
        cachedPlaceholder = newValue! as NSString
        floatingLabel.text = self.cachedPlaceholder as String
        floatingLabel.sizeToFit()
      }
    }
  }
  
  override open var hasText :Bool {
    return !text!.isEmpty
  }
  
  //MARK: Setup
  fileprivate func setup() {
    setupObservers()
    setupFloatingLabel()
    applyFonts()
    setupViewDefaults()
  }
  
  fileprivate func setupObservers() {
    NotificationCenter.default.addObserver(self, selector:#selector(B68UIFloatLabelTextField.textFieldTextDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(B68UIFloatLabelTextField.fontSizeDidChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(B68UIFloatLabelTextField.textFieldTextDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
    NotificationCenter.default.addObserver(self, selector:#selector(B68UIFloatLabelTextField.textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
  }
  
  fileprivate func setupFloatingLabel() {
    // Create the floating label instance and add it to the view
    floatingLabel.alpha = 1
    floatingLabel.center = CGPoint(x: horizontalPadding, y: verticalPadding)
    addSubview(floatingLabel)
    //TODO: Set tint color instead of default value
    
    // Setup default colors for the floating label states
    floatingLabel.textColor = inactiveTextColorfloatingLabel
    floatingLabel.alpha = 0
    
  }
  
  fileprivate func applyFonts() {
    
    // set floatingLabel to have the same font as the textfield
    floatingLabel.font = UIFont(name: font!.fontName, size: UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: placeHolderTextSize)).pointSize)
  }
  
  fileprivate func setupViewDefaults() {
    
    // set vertical padding
    verticalPadding = 0.5 * self.frame.height
    
    // make sure the placeholder setter methods are called
    if let ph = placeholder {
      placeholder = ph
    } else {
      placeholder = ""
    }
  }
  
  //MARK: - Drawing & Animations
  override open func layoutSubviews() {
    super.layoutSubviews()
    if (isFirstResponder && !hasText) {
      hideFloatingLabel()
    } else if(hasText) {
      showFloatingLabelWithAnimation(true)
    }
  }
  
  func showFloatingLabelWithAnimation(_ isAnimated : Bool)
  {
    let fl_frame = CGRect(
      x: horizontalPadding,
      y: 0,
      width: self.floatingLabel.frame.width,
      height: self.floatingLabel.frame.height
    )
    if (isAnimated) {
      let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut]
      UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
        self.floatingLabel.alpha = 1
        self.floatingLabel.frame = fl_frame
        }, completion: nil)
    } else {
      self.floatingLabel.alpha = 1
      self.floatingLabel.frame = fl_frame
    }
  }
  
  func hideFloatingLabel () {
    let fl_frame = CGRect(
      x: horizontalPadding,
      y: verticalPadding,
      width: self.floatingLabel.frame.width,
      height: self.floatingLabel.frame.height
    )
    let options: UIViewAnimationOptions = [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn]
    UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
      self.floatingLabel.alpha = 0
      self.floatingLabel.frame = fl_frame
      }, completion: nil
    )
  }

  
  //MARK: - Auto Layout
  override open var intrinsicContentSize : CGSize {
    return sizeThatFits(frame.size)
  }

  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override open func textRect (forBounds bounds :CGRect) -> CGRect
  {
    return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), floatingLabelInsets())
  }
  
  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override open func editingRect (forBounds bounds : CGRect) ->CGRect
  {
    return UIEdgeInsetsInsetRect(super.editingRect(forBounds: bounds), floatingLabelInsets())
  }
  
  //MARK: - Helpers
  fileprivate func floatingLabelInsets() -> UIEdgeInsets {
    floatingLabel.sizeToFit()
    return UIEdgeInsetsMake(
      floatingLabel.font.lineHeight,
      horizontalPadding,
      0,
      horizontalPadding)
  }
  
  
  //MARK: - Observers
  func textFieldTextDidChange(_ notification : Notification) {
    let previousShouldDrawPlaceholderValue = shouldDrawPlaceholder
    shouldDrawPlaceholder = !hasText
    
    // Only redraw if self.shouldDrawPlaceholder value was changed
    if (previousShouldDrawPlaceholderValue != shouldDrawPlaceholder) {
      if (self.shouldDrawPlaceholder) {
        hideFloatingLabel()
      } else {
        showFloatingLabelWithAnimation(true)
      }
    }
  }
  //MARK: TextField Editing Observer
  func textFieldTextDidEndEditing(_ notification : Notification) {
    if (hasText)  {
      floatingLabel.textColor = inactiveTextColorfloatingLabel
    }
  }
  
  func textFieldTextDidBeginEditing(_ notification : Notification) {
    floatingLabel.textColor = activeTextColorfloatingLabel
  }
  
  //MARK: Font Size Change Oberver
 func fontSizeDidChange (_ notification : Notification) {
    applyFonts()
    invalidateIntrinsicContentSize()
    setNeedsLayout()
  }
  
}
