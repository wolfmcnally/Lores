Pod::Spec.new do |s|
  s.name             = 'Lores'
  s.version          = '0.2.0'
  s.summary          = 'A framework for learning programming using low-resolution (lores) graphics.'

  s.description      = <<-DESC
A framework for learning programming using low-resolution (lores) graphics. This is how I learned how to program back in the Apple // days, with the Apple's "lores mode" being 40x40 pixels and 16 colors, and the "hires mode" being 280x192 and 8 colors. This library lets you select your resolution and lets you use full 32-bit colors, but the principle of learning is the same.
                       DESC

  s.homepage         = 'https://github.com/wolfmcnally/Lores'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wolfmcnally' => 'wolf@wolfmcnally.com' }
  s.source           = { :git => 'https://github.com/wolfmcnally/Lores.git', :tag => s.version.to_s }

  s.swift_version = '4.1'

  s.ios.deployment_target = '11.3'
  s.macos.deployment_target = '10.13'

  s.source_files = 'Lores/Classes/**/*'
  s.dependency 'WolfCore', '~> 2.2'
end
