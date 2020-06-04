## Quotes Creator App
> A simple app for writing quotes on image for creative writers with built in support for free images. The images are retrieved from Pexels.

### Preview

<img src="screenshots/intro.PNG" width="200" />
<img src="screenshots/avatar.PNG" width="200" />
<img src="screenshots/discover.PNG" width="200" />
<img src="screenshots/liked.PNG" width="200" />
<img src="screenshots/details.PNG" width="200" />
<img src="screenshots/editing.PNG" width="200" />
<img src="screenshots/search_uninit.PNG" width="200" />
<img src="screenshots/search_field.PNG" width="200" />
<img src="screenshots/search_result.PNG" width="200" />
<img src="screenshots/profile.PNG" width="200" />

### Contribution Guide

> This app follows Bloc Patter approch. Read More from [Flutter Bloc](https://bloclibrary.dev/#/architecture "Flutter Bloc")

- After setting up the project please obtain your own Pexel API key from [Pexel API Website](https://www.pexels.com/api/ "Pexel API Website")
- Create a file ```_key.dart``` in ```lib/secrets```
- Add
```dart
String pexelAuthKey = "YOUR_API_KEY";
```
in _key.dart file

### TODOs

- [x] ~~Discover~~
- [x] ~~Search~~
- [x] ~~Add to Favourites~~
- [x] ~~Download Image~~
- [x] ~~Edit Image~~
- [x] ~~Save Edited Image~~
- [x] ~~User Profile~~
- [ ] Share Image
- [x] ~~Edit On Device Image~~
- [ ] Show Download Notification