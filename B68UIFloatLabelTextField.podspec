#
# Be sure to run `pod lib lint B68UIFloatLabelTextField.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "B68UIFloatLabelTextField"
  s.version          = "0.1.0"
  s.summary          = "Swift implementation of the Float Label Design Pattern by Matt D. Smith as a sub call from UITextField"
  s.homepage         = "https://github.com/dirkfabisch/B68FloatingLabelTextField"
  s.license          = 'MIT'
  s.author           = { "Dirk Fabisch" => "dirk@base68.com" }
  s.source           = { :git => "https://github.com/dirkfabisch/B68FloatingLabelTextField.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dirkfabisch'
  s.source_files      = "B68FloatingLabelTextField///B68FloatingLabelTextField.swift"
  
  s.platform     = :ios, '7.0'
  s.requires_arc = true
end
