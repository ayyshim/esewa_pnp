#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint esewa_pnp.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'esewa_pnp'
  s.version          = '1.0.0'
  s.summary          = 'Integrate native eSewa payment method in your flutter application with ease.'
  s.description      = <<-DESC
  Integrate native eSewa payment method in your flutter application with ease.
                       DESC
  s.homepage         = 'http://github.com/ayyshim/esewa_pnp'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ashim Upadhaya' => 'justayyme@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.preserve_paths = 'EsewaSDK.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework EsewaSDK' }
  s.vendored_frameworks = 'EsewaSDK.framework'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
