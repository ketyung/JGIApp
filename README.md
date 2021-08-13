# JGIApp

JGI Map mobile app - the iOS version and the backend

A mobile applicaton (iOS) built for the DevPost DocuSign Good Code Hackathon For Jane Goodall Institute. https://devpost.com/software/jgi-map

The application consist of the mobile app front end and backend which is meant for users to create, edit, store conservation maps 
and collaborate with other users for finalizing the conservation maps of the Eastern Chimpanzee for Jane Goodall Institution. A demo
video of its features are available on YouTube

[![Demo Video Of JGI Map App](https://yt-embed.herokuapp.com/embed?v=usvb-vnXS-E)](https://youtu.be/usvb-vnXS-E "Demo Video Of JGI Map App")

The app allows users to have their accounts and store their editing of versions of the conservation maps to the backend.
Users can add or draw points, lines, polygons, define map legend on the map provided by ArcGIS base map and save different versions of the maps and edit them
before coming to the desired version.

Users can collaborate with other roles of users, sign the map with DocuSign and send the map for other roles for reviewing and signing.

The iOS native app version built by the use of the following frameworks :

1. Esri ArcGIS iOS runtime API for the base map, drawing of points, lines & polygons etc. https://developers.arcgis.com/ios/
2. DocuSign iOS SDK for signing of the maps for finalization etc https://developers.docusign.com/docs/ios-sdk/index.html
3. SwiftUI framework for the front-end UI of and Swift - the coding approach is based on MVVM (Model–view–viewmodel) for cleaner code
and better reusability. The SwiftUI views are organized in the folder Views, and view models are in folder ViewModels and also the models respectively. All views, view models and models, design and flows were coded from scratch for the purpose of this hackathon project.

In the Views foler, you'll find views in subfolders for their own dedicated purposes, e.g. views for displaying/handling map or map list are in the sub-folder    "mapViews". Views for handling the DocuSign signing, templates etc are in the subfolder docuSign.

Map view is based on AGSMapView wrapped by UIViewRepresentable for presenting in SwiftUI and its Coordinator for handling touches. For DocuSign sigining by using template that requires the launch of UIViewController by the DSMTemplatesManager, is wrapped using UIViewControllerRepresentable for presenting it in SwiftUI etc.

4. All SwiftUI views and the Swift part written by myself, some were already written previously by me during the previous hackathon (https://github.com/ketyung/KyPayApp2) so I modified to suit and use in this project e.g. the ApiClient that communicates with the PHP backend. 

Some SwiftUI modifiers were written from scratch and some were already written by me (e.g. PopOver, ProgressView etc etc) when I wrote my SwiftUI tutorials on my blog https://blog.techchee.com, so I just modified them to suit and use in this project.

5. Other 3rd-party frameworks : 

SwiftKeychainWrapper for saving data like UsersDefault on the KeyChain. https://github.com/jrendel/SwiftKeychainWrapper (I fixed the iOS 12 deprecation)

bottomSheet - in the modifiers https://github.com/weitieda/bottom-sheet modified and used in this project

The backend is meant for storing the user's profile, role, their edited versions of maps with points, lines and polygons etc. The backend was built
with PHP and MySQL backend which communicates with the mobile app using REST. The backend is now hosted on my public server https://techchee.com/JGIAppApiTestPointV1/. But you can find the backend code in the folder "PHPbackend". The PHP framework for the REST Api and database 
handling was written from scratch by myself during the previous DevPost hackathon. So, I just used it as the base framework and added the required DB structure, model and controllers needed for this project.

If you want to test it, you can download this project and run on a Xcode simulator or iOS device by compiling it with Xcode 12.5.1 or above. 
I built it with Xcode 12.5.1, never had chance to test it with lower versions of Xcode. 


License MIT license https://github.com/ketyung/JGIApp/blob/main/license.txt
