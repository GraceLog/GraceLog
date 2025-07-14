# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GraceLog' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GraceLog
	pod 'KakaoSDKAuth'
	pod 'KakaoSDKUser'
	pod 'Firebase/Core'
	pod 'Firebase/Database'
	pod 'Firebase/Firestore'
	pod 'Firebase/Storage'
	pod 'Firebase/Messaging'
	pod 'Firebase/Auth'
	pod 'GoogleSignIn'
	pod 'IQKeyboardManagerSwift'
	pod 'Then' 
  	pod 'NVActivityIndicatorView'
	pod 'UITextView+Placeholder'
	pod 'SDWebImage'
	pod 'Alamofire' 
	pod 'JGProgressHUD', '~>2.0.3'
	pod 'Toast-Swift', '~> 5.1.1'
	pod 'YPImagePicker'
	pod 'SnapKit'
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RxGesture'
	pod 'NSObject+Rx'
	pod 'RxKeyboard'
	pod 'RxDataSources'
	pod 'ReactorKit'
        pod 'KeychainAccess'
        pod 'Kingfisher', '~> 8.0'
  	pod 'Swinject', '~> 2.8.0'

  target 'GraceLogUseCaseTests' do
    inherit! :search_paths
    pod 'RxTest'
    pod 'RxSwift'
    pod 'RxRelay'
  end

  target 'GraceLogUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end

    installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end

