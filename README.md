# TGK: DocuSign Sample Application

## Introduction
TGK is a DocuSign sample application demonstrating how the DocuSign iOS SDK can be used to in a Host iOS app related to Investments. TGK is written in Swift using UIKit and Story boards. You can find a live instance running at "Link needed here for Appetize"

TGK demonstrates the following:
1. Authentication
    * [Authentication Code Grant](https://developers.docusign.com/esign-rest-api/guides/authentication/oauth2-code-grant)
2. Offline Enevelope Creation and Signing
    * Ability to create and DSEnvelopeDefinition Object with tabs and recipients.
    * Ability to start offline signing.
    * Ability to Sync the Offline signed envelopes back to DocuSign Cloud once the internet connection is available.
3. Captive Signing
    * Allowing users to sign even if they don't have a DocuSign account.

## Installation

### Prerequisites
* A DocuSign Developer account (email and password). If you don't already have a developer demo account, create a [free account](https://go.docusign.com/o/sandbox/).
* Xcode 12.4+
* Cocoapods

### Installation steps
1. Download or clone this repository to your workstation.
2. From your terminal do "pod install".
3. Once the pod install is successful you should see TGK.xcworkspace in your folder.
4. Open the TGK.xcworkspace in XCode

## License information
This repository uses the MIT License. See the [LICENSE](./LICENSE) file for more information.
