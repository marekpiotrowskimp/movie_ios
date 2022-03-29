source "https://github.com/CocoaPods/Specs.git"

platform :ios, "14.0"

target "movie_ios" do
  use_frameworks!
  inhibit_all_warnings!

  #Networking
  pod "AlamofireImage", ">= 3.6.0"

  #RX
  pod "RxSwift", ">= 5.1.0"
  pod "RxGesture", ">= 3.0.0"
  pod "RxAlamofire", "5.1.0"

  target "movie_iosTests" do
    inherit! :search_paths
    
    pod "RxBlocking", ">= 5.1.0"
    pod "RxTest", ">= 5.0.0"
  end

  target "movie_iosUITests" do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"].to_f < 14.0
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "14.0"
      end
    end
  end
end
