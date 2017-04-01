#
#  Be sure to run `pod spec lint DHDynamicLineChart.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DHDynamicLineChart"
  s.version      = "1.0.0"
  s.summary      = "A Line chart that can be fully controlled at runtime."
  s.description  = <<-DESC
                  This chart allows you to:
                    1. Customize the control position of line.
                    2. Dynamically control turning points at runtime.
                    3. Update the labels of x/y axis at runtime.
                  and it is:
                    Self-adjusting in views of different size(Autolayout).
                   DESC
  s.homepage     = "https://github.com/DavidHSW/DHDynamicLineChart"
  s.license      = "MIT"
  s.author       = { "David Hu" => "david.mr.who@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/DavidHSW/DHDynamicLineChart.git", :tag => "1.0.0" }
  s.source_files  = "DHDynamicLineChart", "DHDynamicLineChart/**/*.{h,m}"
  s.framework    = "UIKit", "CoreGraphics"

end
