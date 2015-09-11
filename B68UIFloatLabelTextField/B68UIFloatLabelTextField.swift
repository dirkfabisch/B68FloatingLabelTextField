//
//  B68UIFloatLabelTextField.swift
//  UIFloatLabelTextInput
//
//  Created by Dirk Fabisch on 07.09.14.
//  Copyright (c) 2014 Dirk Fabisch. All rights reserved.
//

import UIKit

public class B68UIFloatLabelTextField: UITextField {
  
  /**
  The floating label that is displayed above the text field when there is other
  text in the text field.
  */
  public var floatingLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
  
  /**
  The color of the floating label displayed above the text field when it is in
  an active state (i.e. the associated text view is first responder).
  
  @discussion Note: Default Color is blue.
  */
  @IBInspectable public var activeTextColorfloatingLabel : UIColor = UIColor.blueColor() {
    didSet {
      floatingLabel.textColor = activeTextColorfloatingLabel
    }
  }
  /**
  The color of the floating label displayed above the text field when it is in
  an inactive state (i.e. the associated text view is not first responder).
  
  @discussion Note: 70% gray is used by default if this is nil.
  */
  @IBInspectable public var inactiveTextColorfloatingLabel : UIColor = UIColor(white: 0.7, alpha: 1.0) {
    didSet {
      floatingLabel.textColor = inactiveTextColorfloatingLabel
    }
  }
  
  /**
   The default dynamic test size
  */
  public var placeHolderTextSize : String = UIFontTextStyleCaption2 {
    didSet {
      floatingLabel.font = UIFont.preferredFontForTextStyle(placeHolderTextSize)
    }
  }
  
  /**
  Used to cache the placeholder string.
  */
  private var cachedPlaceholder = NSString()
  
  /**
  Used to draw the placeholder string if necessary. Starting value is true.
  */
  private var shouldDrawPlaceholder = true
  
  /**
  default padding for floatingLabel
  */
  public var verticalPadding : CGFloat = 0
  public var horizontalPadding : CGFloat = 0
  
  
  //MARK: Initializer
  //MARK: Programmatic Initializer
  
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  
  //MARK: Setter & Getter
  override public var placeholder : String? {
    get {
      return super.placeholder
    }
    set (newValue) {
      super.placeholder = newValue
      if (cachedPlaceholder != newValue) {
        cachedPlaceholder = newValue!
        floatingLabel.text = self.cachedPlaceholder as String
        floatingLabel.sizeToFit()
      }
    }
  }
  
  override public func hasText() ->Bool {
    return !text!.isEmpty
  }
  
  //MARK: Setup
  private func setup() {
    setupObservers()
    setupFloatingLabel()
    applyFonts()
    setupViewDefaults()
  }
  
  private func setupObservers() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldTextDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "fontSizeDidChange:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldTextDidBeginEditing:", name: UITextFieldTextDidBeginEditingNotification, object: self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldTextDidEndEditing:", name: UITextFieldTextDidEndEditingNotification, object: self)
  }
  
  private func setupFloatingLabel() {
    // Create the floating label instance and add it to the view
    floatingLabel.alpha = 1
    floatingLabel.center = CGPointMake(horizontalPadding, verticalPadding)
    addSubview(floatingLabel)
    //TODO: Set tint color instead of default value
    
    // Setup default colors for the floating label states
    floatingLabel.textColor = inactiveTextColorfloatingLabel
    floatingLabel.alpha = 0
    
  }
  
  private func applyFonts() {
    
    // set floatingLabel to have the same font as the textfield
    floatingLabel.font = UIFont(name: font!.fontName, size: UIFont.preferredFontForTextStyle(placeHolderTextSize).pointSize)
  }
  
  private func setupViewDefaults() {
    
    // set vertical padding
    verticalPadding = 0.5 * CGRectGetHeight(self.frame)
    
    // make sure the placeholder setter methods are called
    if let ph = placeholder {
      placeholder = ph
    } else {
      placeholder = ""
    }
  }
  
  //MARK: - Drawing & Animations
  override public func layoutSubviews() {
    super.layoutSubviews()
    if (isFirstResponder() && !hasText()) {
      hideFloatingLabel()
    } else if(hasText()) {
      showFloatingLabelWithAnimation(true)
    }
  }
  
  func showFloatingLabelWithAnimation(isAnimated : Bool)
  {
    let fl_frame = CGRectMake(
      horizontalPadding,
      0,
      CGRectGetWidth(self.floatingLabel.frame),
      CGRectGetHeight(self.floatingLabel.frame)
    )
    if (isAnimated) {
      let options: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut]
      UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
        self.floatingLabel.alpha = 1
        self.floatingLabel.frame = fl_frame
        }, completion: nil)
    } else {
      self.floatingLabel.alpha = 1
      self.floatingLabel.frame = fl_frame
    }
  }
  
  func hideFloatingLabel () {
    let fl_frame = CGRectMake(
      horizontalPadding,
      verticalPadding,
      CGRectGetWidth(self.floatingLabel.frame),
      CGRectGetHeight(self.floatingLabel.frame)
    )
    let options: UIViewAnimationOptions = [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseIn]
    UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
      self.floatingLabel.alpha = 0
      self.floatingLabel.frame = fl_frame
      }, completion: nil
    )
  }

  
  //MARK: - Auto Layout
  override public func intrinsicContentSize() -> CGSize {
    return sizeThatFits(frame.size)
  }

  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override public func textRectForBounds (bounds :CGRect) -> CGRect
  {
    return UIEdgeInsetsInsetRect(super.textRectForBounds(bounds), floatingLabelInsets())
  }
  
  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override public func editingRectForBounds (bounds : CGRect) ->CGRect
  {
    return UIEdgeInsetsInsetRect(super.editingRectForBounds(bounds), floatingLabelInsets())
  }
  
  //MARK: - Helpers
  private func floatingLabelInsets() -> UIEdgeInsets {
    floatingLabel.sizeToFit()
    return UIEdgeInsetsMake(
      floatingLabel.font.lineHeight,
      horizontalPadding,
      0,
      horizontalPadding)
  }
  
  
  //MARK: - Observers
  func textFieldTextDidChange(notification : NSNotification) {
    let previousShouldDrawPlaceholderValue = shouldDrawPlaceholder
    shouldDrawPlaceholder = !hasText()
    
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
  func textFieldTextDidEndEditing(notification : NSNotification) {
    if (hasText())  {
      floatingLabel.textColor = inactiveTextColorfloatingLabel
    }
  }
  
  func textFieldTextDidBeginEditing(notification : NSNotification) {
    floatingLabel.textColor = activeTextColorfloatingLabel
  }
  
  //MARK: Font Size Change Oberver
  private func fontSizeDidChange (notification : NSNotification) {
    applyFonts()
    invalidateIntrinsicContentSize()
    setNeedsLayout()
  }
  
}
