Pod::Spec.new do |s|
s.name = 'LDGCDTimer'
s.version = '0.0.1'
s.license = 'MIT'
s.summary = '一个GCD timer工具。'
s.description = '一个GCD timer简单工具类。'
s.homepage = 'https://github.com/alexiiio/LDGCDTimer'
s.author = { 'alexiiio' => '450145524@qq.com' }
s.source = { :git => "https://github.com/alexiiio/LDGCDTimer.git", :tag => "v0.0.1"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = "LDGCDTimer/LDGCDTimer/*.{h,m}"
s.frameworks = 'UIKit'
end
