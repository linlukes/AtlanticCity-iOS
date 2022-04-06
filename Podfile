# Uncomment the next line to define a global platform for your project
platform :ios, '12.0' 
source 'https://cocoapods-cdn.netlify.app/'

target 'AtlanticCity' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire'
  pod 'AlamofireObjectMapper', :git => 'https://github.com/RomanPodymov/AlamofireObjectMapper.git'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftyJSON', '~> 4.0'
  pod "CDAlertView"
  pod 'Kingfisher'
  pod 'SideMenu'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'JGProgressHUD'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'AAPickerView', '~> 1.0'
  pod 'Apsara'
  pod 'TinderSwipeView' , '~> 1.1.8'
  pod 'MercariQRScanner'
  pod 'TTFortuneWheel'
  pod 'CountryPickerView'
  pod 'MTSlideToOpen'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'
  pod 'MBCheckboxButton'
  pod 'SVPinView', '~> 1.0'
  pod 'Pageboy', '~> 3.6'
  pod 'EZYGradientView', :git => 'https://github.com/Niphery/EZYGradientView'

  target 'AtlanticCityTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AtlanticCityUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end