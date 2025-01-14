# TGK: DocuSign Sample Application

## Introduction
TGK is a DocuSign sample application demonstrating how the DocuSign iOS SDK can be used to in a Host iOS app related to Investments. TGK is written in Swift using UIKit and Story boards. [You can find a live instance running](https://appetize.io/embed/h04rcr0rzjkk9f8p9cgev233wg).

TGK demonstrates the following:
1. Authentication
    * [Authentication Code Grant](https://developers.docusign.com/platform/auth/authcode/)
2. Offline Enevelope Creation and Signing
    * Ability to create and DSEnvelopeDefinition Object with tabs and recipients.
    * Ability to start offline signing.
    * Ability to Sync the Offline signed envelopes back to DocuSign Cloud once the internet connection is available.
3. Captive Signing
    * Allowing users to sign even if they don't have a DocuSign account.

## Installation

### Prerequisites
* A DocuSign Developer account (email and password). If you don't already have a developer demo account, create a [free account](https://go.docusign.com/o/sandbox/).
* An app integration with Integrator Key, Client secret and redirect url, If you don't already have an app create [one](https://developers.docusign.com/platform/build-integration/).
* Xcode 12.4+

### Installation steps
1. Download or clone this repository to your workstation.
2. Open the TGK.xcworkspace in XCode
3. Confirm Swift Package manager sync is done successfully.
4. When you run the application make sure to add the app details in the settings before login with email and password.

## License information
This repository uses the MIT License. See the [LICENSE](./LICENSE) file for more information.
