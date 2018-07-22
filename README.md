# FlickrImageGallery
The purpose of this project is to access the public photos stream from `Flickr` public photo stream. The app is basically showing three types of photos (public photos, public photos tagged with either kitten or kittens, public photos tagged with either dog or dogs). Below are some of the features of the app:
1. Showing the photos feeds on the main screen (with `Pull to Refresh` feature)
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
- **Pods**: `CocoaPods` is used as the Dependency Manager (installing third party libraries).
   - **FlickImageGallery** and **FlickrFetcherSDK**: 
       - Common
          - Alamofire
          - SwiftyJSON
       - FlickrImageGallery Additional
          - SDWebImage
   - **FlickrFetcherSDKTests**
       - OHHTTPStubs/Swift


## Design Decision:
### 1. Network

<dl>
    <dt>Q: Why use an SDK for Network Calls?</dt>
    <dd>A: There are a number of advantages of using SDK.
        <ul>
            <li>All the network related code is present (and structured) at one place.</li>
            <li>It is much easier to reuse the code in a different project.</li>
            <li>The SDK can be built into a Pod and uploaded to Cocoapods.</li>
        </ul>
    </dd>
    <dt>Q: Why use <i>SwiftyJON</i> for JSON Parsing?</dt>
    <dd>A: SwiftyJSON provides a lot of convenience when dealing with JSON data. </dd>
    <dt>Q: Why is JSON parsing done in the Models?</dt>
    <dd>A: 
        <ul>
            <li> Doing the JSON parsing in their respective Models relieve the API controller from a lot of overhead (and keeps all the code modular and clean).</li>
            <li> It makes it much easer to test the models independent of the Controllers.</li>
        </ul>       
    </dd>
    </dd>
    <dt>Q: Why use SDWebImage?</dt>
    <dd>A: SDWebImage is a library for downloading (and caching images).
        <ul>
            <li>Downloading (asynchronously) and caching images.</li>
            <li>Progressive Download (Loading the image while it is being downloaded)</li>
        </ul>
    </dd>

</dl>


### 2. UI/Application
<dl>
    <dt>Q: Why is the main screen designed with a <u>UITableView</i> with a <i>UICollectionView</i> as the child of each section?</dt>
    <dd>A: First of all, the design is that we have a <i>UITableView</i> where every section (having 1 row) represents the list (using <i>UICollectionView</i>. Now answering one by one why each element was chosen:
        <ul>
            <li> <b>Why using <i>UITableView</i> as the main container</b>: 
                <ul>
                    <li> It is quite an elegant solution (both in terms of UI as well as code).</li>
                    <li> The design is scalable (It is much easier to add more lists). </li>
                    <li> Scrolling and Cell reuse ability (better memory management). </li>
                </ul>
            </li>
            <li> <b>Why using sections instead of rows (in <i>UITableView</i>)?</b>: 
                <ul>
                    <li>The reason for using sections is that I wanted to utilize the section headers (for list titles) and footers (spacing below the list). </li>
                </ul>
            </li>
        </ul>
    </dd>
</dl>
