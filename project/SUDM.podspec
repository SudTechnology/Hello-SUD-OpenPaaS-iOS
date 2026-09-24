#
# Be sure to run `pod lib lint SudMGP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SUDM'
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
  
  s.ios.deployment_target = '13.0'
  s.default_subspec = 'full'

  s.subspec 'base' do |ss|
    ss.vendored_frameworks = [
      'SUDSDK/SUDM.xcframework'
    ]
    ss.dependency 'SUDCoreKit'
    ss.dependency 'SUDReport'
  end

  s.subspec 'carty' do |ss|
    ss.vendored_frameworks = [
      'SUDSDK/SUDMAdapterCarty.xcframework'
    ]
    ss.dependency "#{s.name}/base"
    ss.dependency "CartySDK", "1.10.0"
  end

  s.subspec 'admob' do |ss|
    ss.vendored_frameworks = [
      'SUDSDK/SUDMAdapterAdmob.xcframework'
    ]
    ss.dependency "#{s.name}/base"
    ss.dependency "Google-Mobile-Ads-SDK", "~> 13.7.0"
  end

  s.subspec 'max' do |ss|
    ss.vendored_frameworks = [
      'SUDSDK/SUDMAdapterMax.xcframework'
    ]
    ss.dependency "#{s.name}/base"
    ss.dependency "AppLovinSDK", "~> 13.6.3"
  end

  s.subspec 'topon' do |ss|
    ss.vendored_frameworks = [
      'SUDSDK/SUDMAdapterTopOn.xcframework'
    ]
    ss.dependency "#{s.name}/base"
    ss.dependency "TPNiOS", "~> 6.5.73"
  end

  s.subspec 'full' do |ss|
    ss.dependency "#{s.name}/carty"
    ss.dependency "#{s.name}/admob"
    ss.dependency "#{s.name}/max"
    ss.dependency "#{s.name}/topon"
  end
  
end
