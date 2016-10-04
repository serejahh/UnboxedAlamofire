Pod::Spec.new do |s|
  s.name = "UnboxedAlamofire"
  s.version = "2.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.summary = "Alamofire + Unbox: the easiest way to download and decode JSON into swift objects."
  s.homepage = "https://github.com/serejahh/UnboxedAlamofire"
  s.author = { "Serhii Butenko" => "sereja.butenko@gmail.com" }
  s.source = { :git => 'https://github.com/serejahh/UnboxedAlamofire.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = 'true'
  s.source_files = 'UnboxedAlamofire/**/*.swift'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'Unbox', '~> 2.0'
end
