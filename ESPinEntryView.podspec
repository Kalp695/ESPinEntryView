Pod::Spec.new do |s|

  s.name         = "ESPinEntryView"
  s.version      = "1.0.1"
  s.author       = { "bvkuijck" => "bas@e-sites.nl" }
  s.license 	   = { :type => "BSD", :file => "LICENSE" }
  s.summary      = "iOS7 style passcode lock. Fully customizable."
  s.source       = { :git => "https://github.com/e-sites/ESPinEntryView.git", :tag => s.version.to_s   }
  s.homepage     = "https://github.com/e-sites/ESPinEntryView"
  s.source_files = "Classes/*.{h,m}"
  s.platform     = :ios, '7.0'
  s.dependency 'Masonry', '~> 0.6'
  s.dependency 'ReactiveCocoa', '~> 2.4'
  s.dependency 'FXBlurView', '~> 1.6'
  s.frameworks = 'QuartzCore', 'AudioToolbox'
  s.requires_arc = true
end