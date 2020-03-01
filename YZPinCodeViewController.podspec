Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "YZPinCodeViewController"
s.summary = "This is a simple pin code UIViewController"
s.requires_arc = true

s.version = "1.1.0"

s.author = { "Yaroslav Zavyalov" => "yaroslavzavyalov1@gmail.com" }

s.homepage = "https://github.com/YarZav/YZPinCodeViewController"

s.source = { :git => "https://github.com/YarZav/YZPinCodeViewController.git", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "YZPinCodeViewController/**/*.{swift}"

s.resources = "YZPinCodeViewController/**/*.{png,jpeg,jpg,storyboard,xib}"
s.resource_bundles = {
'YZPinCodeViewController' => ['YZPinCodeViewController/**/*.xcassets']
}
end
