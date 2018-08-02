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
4. **Network Layer** to perform the network calls and returned the data in the form of well-defined models..
   1. Unit Tests (for Models and Network request)

## Workspace Structure:
- **FlickrImageGallery**: App that fetches and display the photos along with all the features listen above (points 1-3)
- **Pods**: `CocoaPods` is used as the Dependency Manager (installing third party libraries).
    - Alamofire
    - SwiftyJSON
    - SDWebImage


## Network Layer  
### Components - Generic  
Visual Representation can be found [here](https://goo.gl/bf7Hnc).

- **Request**: Represents the Network Request Object. It also has a convenience method to transform the Request into *URLRequest* which can then be provided to *URLSession* or any other networking library such as *Alamofire* etc.
- **TaskProtocol**: Represents a Task. Task is one unit of work (such as fetching public photos, user login etc.). Task makes a network call (via Service) and then transform the returning (JSON) response into a model.
- **Service** and **ServiceProtocol**: The layer/component making the network calls. It takes request object and returns a response object (enum). Error handling and *Data* to JSON conversion is performed inside *Response*. *Service Protocol* defines structure of the Service(s).
- **Response**: Represents the response returned by the Service to the Task (Service is the entity executing the network calls and task represents one API call). It returns well defined output (error or JSON object) to the task.

## Implementation Specific:
Visual representation can be found [here](https://goo.gl/ZeEMz1).

- **PublicStreamRequest**: Implements *Request* protocol for Public Stream specific requests such as fetch public photos etc. Here we define all the components for each of the public stream requests.
- **PublicPhotosTask**: Represents the Public Photos Fetching Task. It fetches the public stream from Flickr and returns a List object. Conforms to *Task* protocol.
- **MockService**: Special Service that skips the network call and returns contents (already passed to it). It is used for Testing purpose (Testing the network layer without actually making a network call).
