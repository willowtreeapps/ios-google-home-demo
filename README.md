# smart-speaker-detector-sample-ios

Amazon Alexa and Google Home detection example for iOS

Features: 
- Library to detect Amazon Alexa and Google Home devices on local
network
- Application example called Grocr to test the library and notify user
about detected devices

## Approach

We are using an arp table lookup to find devices on the local network.

Since Google Home uses Cast SDK, detection should be reliable.

Amazon Alexa device detection update will be coming soon.

## Example of Detected Google Home Device

<img src="artwork/grocr_screenshot.png" alt="screenshot" style="height: 150px;"/>