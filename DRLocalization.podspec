Pod::Spec.new do |s|
  s.name         = "DRLocalization"
  s.version      = "0.1.2"
  s.summary      = "Simple Objective-C library created to make non-stadard localizations of iOS applicaions easier."
  s.homepage     = "https://github.com/darrarski/DRLocalization-iOS"
  s.license      = 'MIT'
  s.author       = { "Darrarski" => "darrarski@gmail.com" }
  s.source       = { :git => "https://github.com/darrarski/DRLocalization-iOS.git", :tag => "0.1.2" }
  s.platform     = :ios
  s.source_files = 'DRLocalization'
  s.requires_arc = true
end
