# Uncomment this line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
#            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = false
        end
    end
end

platform :ios, '9.0'

target 'LeControl' do
  use_frameworks!

pod 'Alamofire', '~> 4.4'
pod 'SwiftyJSON'
pod 'CocoaAsyncSocket'
pod 'PureLayout'
pod 'ASValueTrackingSlider'
pod 'JDStatusBarNotification'

end
