#
# Morsel.podspec — CocoaPods distribution of the same source tree that
# Package.swift ships via SPM. One set of Swift files, two manifests.
# Validate with: pod lib lint Morsel.podspec --quick
#
Pod::Spec.new do |s|
  s.name             = 'Morsel'
  s.version          = '0.1.1'
  s.summary          = 'A tiny in-app snackbar / toast for UIKit and SwiftUI.'
  s.description      = <<-DESC
    Morsel shows a short, auto-dismissing bar (a snackbar / toast) at the bottom
    of your app's screen. No permissions or notifications — pure in-app UI, with
    a queue and delay-based scheduling, for both UIKit and SwiftUI.
  DESC
  s.homepage         = 'https://github.com/zetro-nayatel/Morsel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zetro-nayatel' => 'zetro.work@gmail.com' }
  s.source           = { :git => 'https://github.com/zetro-nayatel/Morsel.git', :tag => s.version.to_s }

  s.swift_version         = '6.0'
  s.ios.deployment_target = '15.0'

  # Subspecs mirror the SPM targets:
  #   pod 'Morsel/UIKit'
  #   pod 'Morsel/SwiftUI'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/MorselCore/**/*.swift'
    core.frameworks   = 'Foundation'
  end

  s.subspec 'UIKit' do |ui|
    ui.source_files = 'Sources/MorselUIKit/**/*.swift'
    ui.frameworks   = 'UIKit'
    ui.dependency 'Morsel/Core'
  end

  s.subspec 'SwiftUI' do |sui|
    sui.source_files = 'Sources/MorselSwiftUI/**/*.swift'
    sui.frameworks   = 'SwiftUI'
    sui.dependency 'Morsel/Core'
  end
end
