# restos

## Run the project
- Enable the 'Automatically manage signing' option on the 'restos' target on 'Signing & Capabilities' and choose your 'Team'
- Compile an hit 'Product -> Run' the 'restos' scheme into en emulator
- To run into a device you may need to go to 'General -> Device Management' on the System settings and select to Trust the 'restos' app.
- You can run the tests on 'Product -> Tests' or manually no each test

## Technical choices
- The app. was builded using the MVVM pattern architecture with a Repostory pattern
- Protocols are used to have abstracions and not implementations so the code is decoupled and reliying on dependency injection testing is enhanced
- SwiftUI has been selected to build the views
- Combine is helping with the functional reactive programming to communicate the diferents layers
- Core data is storing the Favorites ID

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