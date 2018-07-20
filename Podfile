workspace 'FlickrImageGallery'
platform :ios, '11.4'
use_frameworks!

def common_pods
    pod 'Alamofire'
    pod 'SwiftyJSON'
end

target 'FlickrImageGallery' do
    # Podfiles
    common_pods
    pod 'SDWebImage'
    
    project 'FlickrImageGallery/FlickrImageGallery.xcodeproj'
end

target 'FlickrFetcherSDK' do
    #Podfiles
    common_pods
    
    project 'FlickrFetcherSDK/FlickrFetcherSDK.xcodeproj'
end

# Making sure acknowlegments (for the installed pods) are displayed properly under the Phone Settings -> FlickImageGallery->Acknowledgments.
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-FlickrImageGallery/Pods-FlickrImageGallery-acknowledgements.plist', 'FlickrImageGallery/FlickrImageGallery/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
