//
//  B68UIFloatLabelTextField.swift
//  UIFloatLabelTextInput
//
//  Created by Dirk Fabisch on 07.09.14.
//  Copyright (c) 2014 Dirk Fabisch. All rights reserved.
//

import UIKit

class B68UIFloatLabelTextField: UITextField {

  /**
  Enum to switch between upward and downward animation of the floating label.
  */
  enum B68FloatingPlacehoderAnimationOptions {
    case Upward
    case Downward
  }
  
  var animationDirection = B68FloatingPlacehoderAnimationOptions.Downward

  /**
  The floating label that is displayed above the text field when there is other
  text in the text field.
  */
  var floatingLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
  
  /**
  The color of the floating label displayed above the text field when it is in
  an active state (i.e. the associated text view is first responder).
  
  @discussion Note: Default Color is blue.
  */
  var floatingLabelActiveTextColor = UIColor.greenColor()
  
  /**
  The color of the floating label displayed above the text field when it is in
  an inactive state (i.e. the associated text view is not first responder).
  
  @discussion Note: 70% gray is used by default if this is nil.
  */
  var floatingLabelInactiveTextColor = UIColor(white: 0.7, alpha: 1.0)

  /**
  Used to cache the placeholder string.
  */
  var cachedPlaceholder = NSString()
  
  /**
  Used to draw the placeholder string if necessary. Starting value is true.
  */
  var shouldDrawPlaceholder = true
  
  /**
  Frames used to animate the floating label and text field into place.
  */
  var originalTextFieldFrame : CGRect?
  var offsetTextFieldFrame : CGRect?
  var originalFloatingLabelFrame : CGRect?
  var offsetFloatingLabelFrame : CGRect?


  //MARK: Initializer
  //MARK: Programmatic Initializer
  
  override convenience init(frame: CGRect) {
    self.init(frame: frame)
    setupViewDefaults()
    setupDefaultColorStates()
  }
  
  //MARK: Nib/Storyboard Initializers
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
      setupViewDefaults()
  }
  
  override func awakeFromNib() {
    println("\(__FUNCTION__)")
    super.awakeFromNib()
    
    // This must be done in awakeFromNib since global tint color isn't set by the time initWithCoder: is called
    setupDefaultColorStates()
    
    // Ensures that the placeholder & text are set through our custom setters
    // when loaded from a nib/storyboard.
    if let ph = placeholder {
      placeholder = ph
    } else {
      placeholder = ""
    }
    
    if let ttext = text {
      text = ttext
    } else {
      text = ""
    }
  }

  //MARK: Unsupported Initializers
  override init () {
    super.init()
    fatalError("Using the init() initializer directly is not supported. use init(frame:) instead")
  }
  

  //MARK: Deinit
  deinit {
    // remove observer
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  
  //MARK: Setter & Getter
  
  override var text : String!  {
    get {
      return super.text
    }
    set {
      super.text = self.text
      //TODO: Avoid textFieldTextDidChange notification
    }
  }
  
  override var placeholder : String? {
    get {
      return super.placeholder
    }
    set {
      println("\(__FUNCTION__)")
      if (cachedPlaceholder != placeholder) {
        
        // We draw the placeholder ourselves so we can control when it is shown
        // during the animations
        
        cachedPlaceholder = self.placeholder!
        super.placeholder = ""
        
        floatingLabel.text = self.cachedPlaceholder
        adjustFramesForNewPlaceholder()
        
        // Flags the view to redraw
        setNeedsDisplay()
      }
    }
    
  }
  
  override func hasText() ->Bool {
    println("\(__FUNCTION__)")
    return !text.isEmpty
  }
  
//MARK: Setup Views
  
  func setupViewDefaults() {
    println("\(__FUNCTION__)")
    // Add observers for the text field state changes
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidBeginEditing:", name:UITextFieldTextDidBeginEditingNotification,object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidEndEditing:", name:UITextFieldTextDidEndEditingNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldTextDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    
    // Forces drawRect to be called when the bounds change
    contentMode = UIViewContentMode.Redraw;
    
    // Set the default animation direction
    animationDirection = .Upward;
    
    // Create the floating label instance and add it to the view
    floatingLabel.font = UIFont.boldSystemFontOfSize(12)
    floatingLabel.backgroundColor = UIColor.clearColor()
    floatingLabel.alpha = 1
    
    // Adjust the top margin of the text field and then cache the original
    // view frame
    originalTextFieldFrame = UIEdgeInsetsInsetRect(self.frame,UIEdgeInsetsMake(5, 0, 2, 0))
    frame = originalTextFieldFrame!
    
    // Set the background to a clear color
    backgroundColor = UIColor.clearColor()
  }
  
  func setupDefaultColorStates() {
    //TODO: Set tint color instead of blue
    
    // Setup default colors for the floating label states
    let defaultActiveColor = UIColor.greenColor()
    floatingLabelActiveTextColor = defaultActiveColor
    floatingLabelInactiveTextColor = UIColor(white: 0.7, alpha: 1.0)
    floatingLabel.textColor = floatingLabelActiveTextColor
    floatingLabel.alpha = 1
  }
  

//MARK: - Drawing & Animations
  
  override func layoutSubviews() {
    println("\(__FUNCTION__)")
    super.layoutSubviews()
    // Check if we need to redraw for pre-existing text
    if (isFirstResponder()) {
      checkForExistingText()
    }
  }
  
  override func drawRect(rect: CGRect) {
    println("\(__FUNCTION__)")
    super.drawRect(rect)

    // Check if we should draw the placeholder string.
    // Use RGB values found via Photoshop for placeholder color #c7c7cd.
    if (self.shouldDrawPlaceholder) {
      var placeholderGray = UIColor.greenColor()
      var placeholderFrame = CGRectMake(
        5,
        CGFloat(floorf(Float(frame.size.height - font.lineHeight) / 2)),
        frame.width,
        frame.height)

      let placeholderAttributes = NSDictionary(objects:[NSFontAttributeName,NSForegroundColorAttributeName], forKeys: [self.font,placeholderGray])
      cachedPlaceholder.drawInRect(placeholderFrame, withAttributes: placeholderAttributes)
      
    }
  }

  override func didMoveToSuperview() {
    println("\(__FUNCTION__)")
    if (self.floatingLabel.superview != self.superview) {
      if ((superview != nil) && self.hasText()) {
        superview?.addSubview(floatingLabel)
      } else {
        floatingLabel.removeFromSuperview()
      }
    }
  }
  
  func checkForExistingText()
  {
    println("\(__FUNCTION__)")
    // Check if we need to redraw for pre-existing text
    shouldDrawPlaceholder = !hasText()
    if (hasText()) {
      self.floatingLabel.textColor = self.floatingLabelInactiveTextColor;
      showFloatingLabelWithAnimation(false)
    }
  }
  
  func showFloatingLabelWithAnimation(isAnimated : Bool)
  {
    // Add it to the superview
    if (floatingLabel.superview != superview) {
      superview?.addSubview(floatingLabel)
    }
  
    // Flags the view to redraw
    setNeedsDisplay()
  
    if (isAnimated) {
      let options = UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseOut
      UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
        self.floatingLabel.alpha = 1
        if (self.animationDirection == .Downward) {
          self.frame = self.offsetTextFieldFrame!
        } else {
          self.floatingLabel.frame = self.offsetFloatingLabelFrame!
        }
      }, completion: nil)
    } else {
      self.floatingLabel.alpha = 1
      if (self.animationDirection == .Downward) {
        self.frame = self.offsetTextFieldFrame!
      } else {
        self.floatingLabel.frame = self.offsetFloatingLabelFrame!
      }
    }
  }

  func hideFloatingLabel () {
    let options = UIViewAnimationOptions.BeginFromCurrentState |
                  UIViewAnimationOptions.CurveEaseIn
    UIView.animateWithDuration(0.2, delay: 0, options: options, animations: {
      self.floatingLabel.alpha = 0
      if (self.animationDirection == .Downward) {
        self.frame = self.originalTextFieldFrame!
      } else {
        self.floatingLabel.frame = self.originalFloatingLabelFrame!
      }
      }, completion: { finished in
        self.setNeedsDisplay()
      })
  }

  func adjustFramesForNewPlaceholder (){
    println("\(__FUNCTION__)")

    floatingLabel.sizeToFit()
  
    let offset = ceil(self.floatingLabel.font.lineHeight)
   
    originalFloatingLabelFrame = CGRectMake(
      originalTextFieldFrame!.origin.x + 5,
      originalTextFieldFrame!.origin.y,
      originalTextFieldFrame!.size.width - 10,
      floatingLabel.frame.size.height)
    
    floatingLabel.frame = originalFloatingLabelFrame!
    
    offsetFloatingLabelFrame = CGRectMake(
      originalFloatingLabelFrame!.origin.x,
      originalFloatingLabelFrame!.origin.y - offset,
      originalFloatingLabelFrame!.size.width,
      originalFloatingLabelFrame!.size.height)
  
    offsetTextFieldFrame = CGRectMake(
      originalTextFieldFrame!.origin.x,
      originalTextFieldFrame!.origin.y + offset,
      originalTextFieldFrame!.size.width,
      originalTextFieldFrame!.size.height)
  }
  
  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override func textRectForBounds (bounds :CGRect) -> CGRect
  {
    println("\(__FUNCTION__)")
    return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds,
      UIEdgeInsetsMake(0, 5, 0, 5)))
  }
  
  // Adds padding so these text fields align with B68FloatingPlaceholderTextView's
  override func editingRectForBounds (bounds : CGRect) ->CGRect
  {
    println("\(__FUNCTION__)")
    return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 5, 0, 5)))
  }
  
  //MARK: Text Field Observers
  func textFieldDidBeginEditing (notification : NSNotification) {
    //TODO: Color animation missing
    floatingLabel.textColor = floatingLabelActiveTextColor
  }
  
  func textFieldDidEndEditing (notification : NSNotification) {
    floatingLabel.textColor = floatingLabelInactiveTextColor
  }
  
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

}
