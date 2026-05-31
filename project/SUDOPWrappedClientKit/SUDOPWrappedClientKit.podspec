#
# Be sure to run `pod lib lint SudMGP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SUDOPWrappedClientKit'
  s.version          = '1.0.0'
  s.summary          = 'A short description of SUDOPWrappedClientKit.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/dingguanghui/SudMGP'
  s.license          = { :type => 'MIT', :file => 'SUDOPWrappedClientKit/LICENSE' }
  s.author           = { 'dev' => 'dev@sud.tech' }
  s.source       = {:path => '.'}
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  #  s.static_framework = false
  
  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'global.sud.SUDOPWrappedClientKit' }
  
  default_resource_bundle = [
    'Resource/*.png',
  ]

  s.subspec 'SUDOPWrappedClientKit' do |ss|
      ss.ios.deployment_target = '11.0'
      ss.public_header_files = 'SUDOPWrappedClientKit/**/*.h'

      ss.source_files = [
        '*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'Common/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'Helper/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
        'Comonents/**/*.{h,m,mm,cpp,c,hpp,cc,swift}',
      ]
    #   ss.vendored_frameworks = [
    #      'SudSDK/SudGIP.xcframework'
    #   ]
    
    
      ss.resource_bundles = {
        'SUDOPWrappedClientKit_Res' => default_resource_bundle
      }
      # json
      ss.dependency 'MJExtension', '~> 3.4.1'
      ss.dependency 'Masonry'
      ss.dependency 'SUDGI'
    end
end
