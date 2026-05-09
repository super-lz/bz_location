#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bz_location.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bz_location'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for AMap location SDK.'
  s.description      = <<-DESC
Flutter plugin for AMap location SDK.
                       DESC
  s.homepage         = 'https://lbs.amap.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'bz' => 'dev@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AMapLocation'
  s.static_framework = true
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
