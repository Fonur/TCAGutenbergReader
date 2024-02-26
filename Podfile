# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'FolioReaderKit', :git => 'https://github.com/FolioReader/FolioReaderKit.git', :branch => 'master'
end

target 'GutenbergReader' do
  shared_pods
end

target 'GutenbergReaderTests' do
  shared_pods
end

target 'GutenbergReaderUITests' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "16.0"
    end
  end
end
