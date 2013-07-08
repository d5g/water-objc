D5G Water Data API SDK
======================

Leverages D5G Water API, which fronts web services from the following
agencies:

* United States Geological Survey
* United States Army Corps of Engineers

The underlying D5G Water API makes stream gauge data available from these
agencies, generally for metrics such as current height level, discharge flow,
precipitation amounts, and water temperature.

Initial framework will be available for OS X 10.9+ and iOS 7+.

This framework is built for use within [FloodWatch for iOS, v2.0.0+](http://floodwatchapp.com/),
but is available as an open source project under a BSD 2-clause license.

Underlying sample API requests can be seen below:

* [USGS gauge 02336910; all data](https://api.d5gtech.com/water/v1/gauge/usgs/02336910)
* [USGS gauges 02335910, 02337000; basic data](https://api.d5gtech.com/water/v1/gauges/basic/usgs:02336910,usgs:02337000)

[D5G Technology, LLC](http://d5gtech.com/)
