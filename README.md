# Dash chat 
A chatapp in flutter using firebase API.
# Aim
To Create a mobile application where users can chat with each other.
# Introduction
Firebase provides real-time database service. The chat application communicates with firebase API and obtains all the messages present in the firebase collection. Upon compsing a message we can add messages to a collection which can be recived by other users.
<br><br>

# Working
As flutter allows you to build native applications, this chat application is compatible with Android, Ios and web applications.<br>
The signIn methods can be changed from firebase console. Firebase also authenticates the user upon login. The registration class is similar to the signin class and only differs in firebase syntax to create a new user using email-id and password.<br><br>

When a user Sends a message, the text, users name and the timestamp is sent to the firebase collection. <br>
The receiver will receive the messages in order of their timestamp. 
The project code is present in lib\main.dart

# Technologies Used<br>
**Flutter** - open-source UI software development kit.<br>
**Firebase** - provides a real-time database and back-end as a service.<br>
**Dart** - Programming language for flutter apps
<br><br>
# Refrences:<br>
https://www.youtube.com/watch?v=1bNME5FWWXk -Author: Tensor Programming<br>
https://flutter.dev/docs<br>
https://firebase.google.com/docs/firestore/using-console<br>
https://medium.com/jlouage/container-de5b0d3ad184 -Author: Julien Louage<br>
https://medium.com/flutter-community/flutter-raisedbutton-cookbook-7c3d4a82b26f Author: Aneesh Jose<br>
https://www.youtube.com/watch?v=DqJ_KjFzL9I&feature=youtu.be<br>

A few screenshots of the application.
# Screenshots

![](https://github.com/RyanDC1/Chat-Application/blob/master/Screenshots/1.jpg)     ![](https://github.com/RyanDC1/Chat-Application/blob/master/Screenshots/2.jpg)
    ![](https://github.com/RyanDC1/Chat-Application/blob/master/Screenshots/3.jpg)   ![](https://github.com/RyanDC1/Chat-Application/blob/master/Screenshots/4.jpg)
       ![](https://github.com/RyanDC1/Chat-Application/blob/master/Screenshots/5.jpg)

