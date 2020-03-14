Pod::Spec.new do |s|
  s.name             = 'LFTransferTool'
  s.version          = '0.1.0'
  s.summary          = 'iOS / Mac OS 平台点对点传输工具'
  s.swift_version = '5.0'

  s.description      = <<-DESC
  基于MultipeerConnectivity/MultipeerKit框架的iOS / Mac OS 平台点对点传输工具,实现高速传输内容.
                       DESC

  s.homepage         = 'https://github.com/loyfo/LFTransferTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'loyfo' => 'hwp_163@163.com' }
  s.source           = { :git => 'https://github.com/loyfo/LFTransferTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'

  s.ios.source_files = 'LFTransferTool/Classes/Core/**/*.{swift}','LFTransferTool/Classes/iOS/**/*.{swift}'
  s.osx.source_files = 'LFTransferTool/Classes/Core/**/*.{swift}','LFTransferTool/Classes/MacOS/**/*.{swift}'

end
