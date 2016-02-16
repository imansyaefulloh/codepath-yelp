# Project 3 - *Yelp*

**Yelp** is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] Table rows for search results should be dynamic height according to the content height.
- [X] Custom cells should have the proper Auto Layout constraints.
- [X] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

The following **optional** features are implemented:

- [X] Search results page
   - [X] Infinite scroll for restaurant results.
   - [X] Implement map view of restaurant results.
- [X] Implement the restaurant detail page.

The following **additional** features are implemented:

- [X] Uses **current location** to get relevant search results
- [X] Explore a **restaurant's menu** from within the app
- [X] **Call a business** from within the app
- [X] Read a **review highlight** from within the app
- [X] Tap to **get directions** to a business
- [X] Map all search results; **tap a pin on the map** to segue to business details view
- [X] Multiple navigation controllers with **Tab Bar**
- [X] List of **categories** to search from (static table view controller)
- [X] Pull-to-refresh (useful if your location has changed!)
- [X] **Sort** by distance or rating
- [X] **Filter** by multiple distance levels
- [X] Search bars are connected to Yelp Search API (not limited to searching table view cells; can search for any local business)
- [X] Search terms and filters persist between relaunches, **using NSUserDefaults**
- [X] App Icon resembles the real Yelp app
- [X] Launch screen resembles the real Yelp app
- [X] Navigation bars, buttons, icons, and theme **resembles the real Yelp app**

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

[<img src='http://img.tejen.net/4aa8eb5ca00b98dcf94736162d041d73.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />](http://x.tejen.net/js3)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Shakeel repairs EVERYTHING, not just iPhones... LOL

Auto Layouts became much easier as I got the hang of it. One pro-tip we should have learned offically is the fact that you can Control+Drag from one storyboard element to another in order to relate both of them in a new Auto Layout constraint... for me, this was an essential technique, since there were occasions when an element couldn't "see" another element in drop-down menus when setting new constraints the "proper" way.

## License

    Copyright ©2016 Tejen Hasmukh Patel

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
