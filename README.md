# JGIApp

JGI Map mobile app - the iOS version and the backend

A platform applicaton built for the DevPost DocuSign Hackathon For Jane Goodall Institution.

The application consist of the mobile app front end and backend which is meant for users to create, edit, store conservation maps 
and collaborate with other users for finalizing the conservation maps of the Eastern Chimpanzee for Jane Goodall Institution. A demo
video of its features are available on https://youtu.be/usvb-vnXS-E

The app allows users to have their accounts and store their editing of versions of the conservation maps to the backend.
Users can add or draw points, lines, polygons on the map provided by ArcGIS base map and save different versions of the maps and edit them
before coming to the desired version.

Users can collaborate with other roles of users, sign the map with DocuSign and send the map for other roles for reviewing and signing.

The iOS native app version built by the use of the following frameworks :

1. Esri ArcGIS iOS runtime API for the base map, drawing of points, lines & polygons etc. https://developers.arcgis.com/ios/
2. DocuSign iOS SDK for signing of the maps for finalization etc https://developers.docusign.com/docs/ios-sdk/index.html
3. SwiftUI framework for the front-end UI of and Swift

4. All SwiftUI views and the Swift part written by myself, including the ApiClient that communicates with the PHP backend. Coding is taken with 
the MVVM (Model View ViewModel) approach for cleaner code and reusability. 

5. Other frameworks : SwiftKeychainWrapper for saving data like UsersDefault on the KeyChain

The backend is meant for storing the user's profile, their edited versions of maps with points, lines and polygons etc. The backend was built
with PHP and MySQL backend. The backend code resides in the folder PHPbackend.



License MIT license https://github.com/ketyung/JGIApp/blob/main/license.txt
