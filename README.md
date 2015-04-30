B68FloatingLabelTextField
=========================

Swift implementation of the [Float Label Design Pattern](http://mattdsmith.com/float-label-pattern/) by Matt D. Smith as a sub call from UITextField

Implementing an input field for a device with limited screen estate is challenging. Matt has developed an pattern for combining a placeholder text wit a floating label if needed.

![Floating Label Animation Example](https://d13yacurqjgara.cloudfront.net/users/6410/screenshots/1254439/form-animation-_gif_.gif)

I implemented the pattern in SWIFT and enabled some of the internal propertiers in Xcode 6 Interface Builder (see screenshot)

![Screenshot](/xcode_screenshot.png)

####Exposed Properties
- Active Color: Text color of the floating label if focused
- Inactive Color: Text Color of the floating label if unfocused

### Installation

#### Manual
Just clone and add ```B68UIFloatLabelTextField.swift``` to your project.

#### Cocoapods
- Make sure that your Cocoapods version is >= 0.36: `pod --version`
- If not, update it: `sudo gem install cocoapods`
- `pod init` in you project root dir
- `nano Podfile`, add:

```
pod 'B68UIFloatLabelTextField', '~> 0.1.0'
use_frameworks! 
``` 
- Save it: `ctrl-x`, `y`, `enter`
- `pod update`
- Open generated `.xcworkspace`


####Requirements
- iOS 7.0+ (8.0+ if you use Cocoapods)
- Xcode 6.3
- Swift 1.2 

####License
MIT

Based on the Objectiv-C implementations from:
- [jverdi](https://github.com/jverdi/JVFloatLabeledTextField)
- [ArtSabintsev](https://github.com/ArtSabintsev/UIFloatLabelTextView)
