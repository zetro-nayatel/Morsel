#
# Snackbar.podspec — CocoaPods distribution of the same source tree that
# Package.swift ships via SPM. One set of Swift files, two manifests.
# Validate with: pod lib lint Snackbar.podspec --quick
#
Pod::Spec.new do |s|
  s.name             = 'Snackbar'
  s.version          = '0.1.0'
  s.summary          = 'A tiny in-app snackbar / toast for UIKit and SwiftUI.'
  s.description      = <<-DESC
    Snackbar shows a short, auto-dismissing bar at the bottom of your app's
    screen. No permissions or notifications — pure in-app UI, with a queue and
    delay-based scheduling, for both UIKit and SwiftUI.
  DESC
  s.homepage         = 'https://github.com/your-org/Snackbar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'you@example.com' }
  s.source           = { :git => 'https://github.com/your-org/Snackbar.git', :tag => s.version.to_s }

  s.swift_version         = '6.0'
  s.ios.deployment_target = '15.0'

  # Subspecs mirror the SPM targets:
  #   pod 'Snackbar/UIKit'
  #   pod 'Snackbar/SwiftUI'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/SnackbarCore/**/*.swift'
    core.frameworks   = 'Foundation'
  end

  s.subspec 'UIKit' do |ui|
    ui.source_files = 'Sources/SnackbarUIKit/**/*.swift'
    ui.frameworks   = 'UIKit'
    ui.dependency 'Snackbar/Core'
  end

  s.subspec 'SwiftUI' do |sui|
    sui.source_files = 'Sources/SnackbarSwiftUI/**/*.swift'
    sui.frameworks   = 'SwiftUI'
    sui.dependency 'Snackbar/Core'
  end
end
