
Pod::Spec.new do |s|
  s.name         = "TestPod"
  s.version      = "0.0.1"
  s.summary      = "a sample top scrollview"

  s.homepage     = "https://github.com/caohuoxia/TestPod"

  s.license      = "MIT"

  s.author             = { "曹火霞" => "caohuoxiasoft@163.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/caohuoxia/TestPod.git", :tag => "#{s.version}" }

  s.source_files  =  "Top/*.{h,m}"

  s.framework  = "UIKit"

  s.requires_arc = true

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "YYKit", "~> 1.0.9"

end
