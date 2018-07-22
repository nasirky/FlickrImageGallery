# FlickrImageGallery
The purpose of this project is to access the public photos stream from `Flickr` public photo stream. The app is basically showing three types of photos (public photos, public photos tagged with either kitten or kittens, public photos tagged with either dog or dogs). Below are some of the features of the app:
1. Showing the photos feeds on the main screen 
    1. *Kittens*: Public photos tagged with either kitten or kittens
    2. *Dogs*: Public photos tags with either dog or dogs.
    3. *Public Feed*: Public photos (regardless of the tags)
2. Showing Detail (large size image along with ability to perform extra functions).
3. Ability to:
   1. Share the image (as well as download the image)
   2. Image caching
   3. Opening the image in browser
   4. Showing image metadata in a separate view (clicking the "i" button will show this view)
   5. Order image by date (no sorting, ascending and descending sort by publish date)
4. **FlickerFetcherSDK** to perform the network calls and returned the data in the form of well-defined models..
   1. Unit Tests (for Models and Network request)

## Workspace Structure:
- **FlickrImageGallery**: App that fetches and display the photos along with all the features listen above (points 1-3)
- **FlickrFetcherSDK**: SDK that makes the network requests and returned well defined Models to the calling app. *UnitTests* are included to test the core functionalities of the SDK.
- **Pods**: `CocoaPods` is used as the Dependency Manager (installing third party libraries)


### Some Points:
- **FlickrFetcherSDK** has been introduced as it is much easier to reuse the code. Another option would be to build the SDK as a Pod and upload it to Cocoapods.
- All the JSON parsing is done within the respective models (currently there is only 1 Model doing JSON parsing)
