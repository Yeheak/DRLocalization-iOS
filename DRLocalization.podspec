Pod::Spec.new do |s|
  s.name         = "DRLocalization"
  s.version      = "0.1.1"
  s.summary      = "Simple Objective-C library created to make non-stadard localizations of iOS applicaions easier."
  s.homepage     = "http://github.com/darrarski/DRLocalization"
  s.license      = 'MIT'
  s.author       = { "Darrarski" => "darrarski@gmail.com" }
  s.source       = { :git => "https://github.com/darrarski/DRLocalization.git", :tag => "0.1.1" }
  s.platform     = :ios
  s.source_files = 'DRLocalization'
  s.requires_arc = true
end
