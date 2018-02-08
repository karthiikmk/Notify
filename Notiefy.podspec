
Pod::Spec.new do |s|
  s.name             = 'Notiefy'
  s.version          = '1.3'
  s.summary          = 'Sweet For Notify'

  s.description      = "A sweet for notify updates"

  s.homepage         = 'https://github.com/karthikAdaptavant/Notify'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'karthikAdaptavant' => 'karthik.samy@a-cti.com' }
  s.source           = { :git => 'https://github.com/karthikAdaptavant/Notify.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Notify/Classes/**/*'

  s.resource_bundles = {
    'Notify' => ['Notify/Classes/**/*.{xib}', 'Notify/Assets/**/*.{xcassets}']
  }

end
