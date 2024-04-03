#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint notification_mode.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'notification_mode'
  s.version          = '0.0.1'
  s.summary          = 'Plugin used to obtain the status of an incoming notification in Android and iOS'
  s.description      = <<-DESC
Plugin used to obtain the status of an incoming notification in Android and iOS
                       DESC
  s.homepage         = 'https://github.com/longtn-imt/notification_mode'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LongTN IMT' => 'longtn@imt-soft.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Mute'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
