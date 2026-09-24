#
# Be sure to run `pod lib lint SudMGP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SUDGI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SudMGPSDK.'
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/dingguanghui/SudMGPSDK'
  #s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dingguanghui' => 'dingguanghui@divtoss.com' }
  s.source       = {:path => '.'}
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  
  s.ios.deployment_target = '11.0'
  s.vendored_frameworks = [
#   'SUDSDK/frameworks/SUDCoreKit.xcframework',
  'SUDSDK/SUDGI.xcframework'
  ]
  s.dependency 'SUDCoreKit'
  s.dependency 'SUDReport'
  s.subspec 'shine' do |ss|
    ss.ios.deployment_target = '11.0'

    ss.vendored_frameworks = [
    'SUDSDK/frameworks/libshine_wrapper.xcframework',
    'SUDSDK/frameworks/shine.xcframework'
    ]
  end
end
