
workspace 'FlickrImageGallery'
platform :ios, '11.4'
use_frameworks!

target 'FlickrImageGallery' do
    # Podfiles
    pod 'SwiftyJSON'
    pod 'SDWebImage'
    
    target 'FlickrImageGalleryTests' do
        inherit! :search_paths
    end
    
    project 'FlickrImageGallery/FlickrImageGallery.xcodeproj'
end

# Making sure acknowledgments (for the installed pods) are displayed properly under the Phone Settings -> FlickImageGallery->Acknowledgments.
post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-FlickrImageGallery/Pods-FlickrImageGallery-acknowledgements.plist', 'FlickrImageGallery/FlickrImageGallery/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    
end
