Pod::Spec.new do |s|
  s.name             = 'SUDReport'
  s.version          = '0.1.0'
  s.summary          = 'A common report runtime for SUD SDK.'

  s.description      = <<-DESC
  SUDReport provides common event persistence, scheduling and transport abstractions.
  DESC

  s.homepage         = 'https://github.com/dingguanghui/SudMGPSDK'
  s.license          = { :type => 'MIT', :file => 'SUDCoreKit/LICENSE' }
  s.author           = { 'dingguanghui' => 'dingguanghui@divtoss.com' }
  s.source           = { :path => '.' }

  s.frameworks       = 'Foundation', 'UIKit', 'Security'
  s.requires_arc     = true
  s.ios.deployment_target = '13.0'

  s.vendored_frameworks = [
    'SUDSDK/SUDReport.xcframework'
  ]

  s.dependency 'SUDCoreKit'

end
