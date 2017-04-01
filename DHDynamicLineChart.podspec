#
#  Be sure to run `pod spec lint DHDynamicLineChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DHDynamicLineChart"
  s.version      = "1.0.1"
  s.summary      = "A Line chart that can be fully controlled at runtime."
  s.homepage     = "https://github.com/DavidHSW/DHDynamicLineChart"
  s.license      = "MIT"
  s.author       = { "David Hu" => "david.mr.who@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/DavidHSW/DHDynamicLineChart.git", :tag => "1.0.1" }
  s.source_files  = "DHDynamicLineChart", "DHDynamicLineChart/**/*.{h,m}"
  s.framework    = "UIKit", "CoreGraphics"

end
