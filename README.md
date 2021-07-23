# DeepScroll

## About

DeepScroll is an iOS toolkit that allows developers to create UITableViews that resize their cells based on where users scroll on the screen. The makers of DeepScroll developed the toolkit to help combat infinite scroll, a phenomenon commonly found in social media apps where feeds seem to never end. We also thought this was a useful way to interact with content to reduce cognitive load and parse through information more efficiently. The toolkit was developed for our final project in *CS 6456 - Principles of UI Software* at Georgia Tech.

## How it works

With DeepScroll, the screen is divided into 3 separate vertical columns, with each column collapsing cells into a different size when used to scroll. We use tags to assign each lane a priority (1-3). Tag 1 means it's a normal lane, so the content size is normal. Tag 2 means it's a half collapsed lane, so the content shrinks to a slightly smaller size. Finally, tag 3 mean it's a fully collapsed lane, so the cell shrinks to the smallest size possible. When the user scrolls, they can switch seamlessly between each lane without picking up their finger. Whenever the scroll lane is switched, an animation fills the new lane with a gray color and fades out.

| Normal | Half Collapsed | Full Collapsed |
| :---: | :---: | :---: |
| ![DeepScroll Normal Screenshot][normal-screenshot] | ![DeepScroll Half Collapsed Screenshot][half-collapsed-screenshot] | ![DeepScroll Full Collapsed Screenshot][full-collapsed-screenshot] |

## Example

To run the example project, clone the repo, and run `pod install` in your terminal from the *Example* directory.

## Installation

DeepScroll is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

``` pod 'DeepScroll' ```

## Built with

* [Swift](https://swift.org)
* [UIKit](https://developer.apple.com/documentation/uikit)

## License

DeepScroll is available under the MIT license. See the LICENSE file for more info.

[normal-screenshot]: Images/deepscroll-ss-1.png
[half-collapsed-screenshot]: Images/deepscroll-ss-2.png
[full-collapsed-screenshot]: Images/deepscroll-ss-3.png
