Pod::Spec.new do |s|
s.name = 'LDGCDTimer'
s.version = '0.0.3'
s.license = 'MIT'
s.summary = '一个GCD timer简单工具类'
s.description = '一个GCD timer简单工具类。支持循环次数，循环到某日，暂停和恢复。'
s.homepage = 'https://github.com/alexiiio/LDGCDTimer'
s.author = { 'alexiiio' => '450145524@qq.com' }
s.source = { :git => "https://github.com/alexiiio/LDGCDTimer.git", :tag => "v0.0.3"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = "LDGCDTimer/LDGCDTimer/"
s.frameworks = 'UIKit'
end
