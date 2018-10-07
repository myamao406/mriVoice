# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'mrivoice' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mrivoice
  pod 'FontAwesomeKit', :git => 'https://github.com/PrideChung/FontAwesomeKit.git'
  pod 'RealmSwift'
#  pod 'Alamofire', '~> 4.7'
#  pod 'MRProgress'
  pod 'KRProgressHUD'
  #  pod 'SlideMenuControllerSwift'
  pod 'KYDrawerController'
  pod 'lottie-ios'
  pod 'EZAudio', '~> 1.1.4'
  pod 'EZAudio/Core', '~> 1.1.4'
  pod 'FilesProvider'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'SwiftCop'
  pod 'Toast-Swift', '~> 3.0.1'
  
  pod 'GradientCircularProgress', :git => 'https://github.com/keygx/GradientCircularProgress'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.1'
          end
      end
  end

  target 'mrivoiceTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mrivoiceUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
