#
# Be sure to run `pod lib lint sdlrkx.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "sdlrkx"
  s.version          = "0.3.0"
  s.summary          = "SDL visual self-report for ResearchKit"

  s.description      = "The Small Data Lab ResearchKit Extensions package is the easiest way to include SDL visual self-report (YADL, MEDL, PAM) into a ResearchKit application."

  s.homepage         = "https://github.com/cornelltech/sdl-rkx"
  s.license          = { :type => "Apache 2", :file => "LICENSE" }
  s.author           = { "James Kizer, Cornell Tech Foundry" => "jdk288 at cornell dot edu" }
  s.source           = { :git => "https://github.com/cornelltech/sdl-rkx.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |core|
    core.source_files = 'source/Core/Classes/**/*'
    core.resources = 'source/Core/Assets/PAM.xcassets', 'source/Core/Assets/PAM.json'
    core.dependency 'ResearchKit', '~> 1.3.1'
  end

  s.subspec 'RSTBSupport' do |rstb|
    rstb.source_files = 'source/RSTBSupport/Classes/**/*'
    rstb.dependency 'sdlrkx/Core'
    rstb.dependency 'ResearchSuiteTaskBuilder', '~> 0.2.0'
    rstb.dependency 'Gloss', '~> 1'
  end

end
