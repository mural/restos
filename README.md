# restos

## Run the project
- Enable the 'Automatically manage signing' option on the 'restos' target on 'Signing & Capabilities' and choose your 'Team'
- Compile an hit 'Product -> Run' the 'restos' scheme into en emulator
- To run into a device you may need to go to 'General -> Device Management' on the System settings and select to Trust the 'restos' app.
- You can run the tests on 'Product -> Tests' or manually no each test

## Technical choices
- The app. was builded using the MVVM pattern architecture with a Repostory pattern
- Protocols are used to have abstracions and not implementations so the code is decoupled and reliying on dependency injection testing is enhanced
- UIKit programatically was used to create the views by requirement, also there is a SwiftUI support module
- Combine is helping with the functional reactive programming to communicate the diferents layers
- Core data is storing the Favorites ID

### UIKit <> SwiftUI config
- set UI_MODE_SWIFT_UI to YES (1) to enable SwiftUI or NO (0) to use UIKit on the Info.plist file
<img width="787" alt="image" src="https://user-images.githubusercontent.com/759739/168874755-c97a18fd-eece-4cca-bc19-19c2516f2c71.png">

## Potential difficulties
- Navigation is super simple at the moment
- Pagination is not implemented
- Network calls are not cached nor optimized
- Data is not encrypted
- Core data is just storing favorites ID, but that con growth and also data migrations can occur

## Future Enhancements
- Make generic components to improve reuse
- Separate Parsing objects from Domain ones and persistance ones
- Improve UI, like adding animations, customize the iPad view

## Screenshots UIKit

![image](https://user-images.githubusercontent.com/759739/168875239-b2cdb199-6d44-4181-81ff-a1baf135f856.png)
![image](https://user-images.githubusercontent.com/759739/168874991-928f9c98-2dc2-4d5d-8618-316741798643.png)

## Screenshots SwiftUI

![image](https://user-images.githubusercontent.com/759739/168617211-f6005db6-fe7c-46d6-897e-9bd5c5670963.png)
![image](https://user-images.githubusercontent.com/759739/168617276-9bd1f270-3c9e-47ad-8b67-027eb93865c5.png)
