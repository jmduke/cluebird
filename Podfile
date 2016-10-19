# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Crossword Helper' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Armchair', :git => 'https://github.com/UrbanApps/Armchair.git', :branch => 'swift3'
  pod 'AsyncSwift'
  pod 'Crashlytics'
  pod 'DZNEmptyDataSet'
  pod 'Fabric'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'Localize-Swift', '~> 1.6'
  pod 'MBProgressHUD'
  pod 'Popover', :git => 'https://github.com/corin8823/Popover.git'
  # Pods for Crossword Helper
  pod 'SugarRecord', :git => 'https://github.com/carambalabs/SugarRecord.git'
  pod 'SugarRecord/CoreData', :git => 'https://github.com/carambalabs/SugarRecord.git'
  pod 'SQLite.swift', :git => 'https://github.com/stephencelis/SQLite.swift.git'
  pod 'Zip'
  target 'Crossword HelperTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Crossword HelperUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
    end
  end
end
