Pod::Spec.new do |s|

  s.name         = "ESPinEntryView"
  s.version      = "1.0"
  s.author       = { "bvkuijck" => "bas@e-sites.nl" }
  s.license 	= "MIT"
  s.source       = { :git => "https://bitbucket.org/esites-mobile/ios-library.git" }
  s.source_files  = "#{s.name}/objc/versions/#{s.version}/*.*"
  s.platform     = :ios
  s.dependency 'Masonry', '~> 0.6'
  s.dependency 'ReactiveCocoa', '~> 2.4'
  s.dependency 'FXBlurView', '~> 1.6'
  s.frameworks = 'QuartzCore', 'AudioToolbox'
  s.requires_arc = true
end