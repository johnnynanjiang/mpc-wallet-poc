# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UniWallet' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UniWallet
pod 'UniPass_Swift', :git => 'git@github.com:LevenWin/UniPass-Swift.git'
	

end

post_install do |pi|
    
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end

