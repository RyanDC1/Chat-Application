import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recase/recase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash Chat',
      theme: ThemeData.dark(),
      initialRoute: MyHomePage.id,
      routes: {                                                                 // Routes assigned to allow navigation between pages
        MyHomePage.id: (context) => MyHomePage(),
        SignIn.id: (context) => SignIn(),
        Reg.id: (context) => Reg(),
        Chat.id: (context) => Chat(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


/// Main Welcome Homepage
/// Allows user to either Login or Register
class MyHomePage extends StatelessWidget {
  static const String id = "HomePage";
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "title",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dash Messenger"),
          leading: Image.asset("assets/logo.png"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Center(
                child: Text(
               "Welcome!",
                style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Font1',
                 ),
               ),
              ),
              SizedBox(height: 20),
              Button(
                text: "Sign In",
                method: () {
                  Navigator.of(context).pushNamed(SignIn.id);
                },
              ),
              SizedBox(height: 15,),
              Button(
                text: "Register",
                method: () {
                  Navigator.of(context).pushNamed(Reg.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Common button styles to be used
class Button extends StatelessWidget{
  final VoidCallback method;
  final String text;
  const Button({Key key, this.method, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 50,
      child:RaisedButton(
          child: Text(text),
          onPressed: method,
          elevation: 8.0,
          color: Colors.black38,
          highlightColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          )
      ),
    );
  }
}


///Sign in class, allows authentication with firebase and user sign in
///Statefulwidget allows a widget to change state when the user interacts with it
class SignIn extends StatefulWidget {
  static const String id = "SignIn";
  @override
  SignInState createState() => SignInState();
}



class SignInState extends State<SignIn> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;                             //Syntax to communicate with firebase
  Future<void> userSignIn() async {
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(user: user),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "title",
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dash Messenger"),
            backgroundColor: Colors.deepPurple,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 250,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      autofocus: false,
                      onChanged: (value) => email = value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                width: 250,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    icon: Icon(Icons.security),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) => password = value,
                ),
              ),
              SizedBox(height: 20.0,),
              Button(
                text: "Login",
                method: () async{
                    await userSignIn();
                },
              ),
            ],
          ),
      ),
    );
  }
}


/// Chat class, handles message transfer, and display of messages
class Chat extends StatefulWidget {
  static const String id = "Chat";
  final FirebaseUser user;

  const Chat({Key key, this.user}) : super(key: key);
  @override
  ChatState createState() => ChatState();
}



class ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  TextEditingController _textEditingController = TextEditingController();

  Future<void> callback() async{
    DateTime date = DateTime.now();
    String time = "${date.hour}:${date.minute}";
    String d_time = date.toString();
    if(_textEditingController.text.length > 0){
      await _firestore.collection('message').add(                               // Add messages to firestore
          {
            'text': _textEditingController.text,
            'from': widget.user.email.replaceAll(RegExp(r"\@[^]*"), ""
            ).sentenceCase,
            'date': d_time,
            'time': time
          }
      );
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/logo.png"),
        title: Text("Dash chat"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(                                      // Streambuilder will obtain all the messages from firestore collection
                stream: _firestore.collection('message').orderBy('date').snapshots(),    // Syntax for obtaining data from firestore collection
                builder: (context, snapshot){
                  if(!snapshot.hasData)
                    return Text('Loading...');
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  List<Widget> messages = documents.map((doc) => ChatMessage(
                    from: doc.data['from'],
                    text: doc.data['text'],
                    me: widget.user.email.replaceAll(RegExp(r"\@[^]*"), ""
                    ).sentenceCase == doc.data['from'],
                    date: doc.data['date'],
                    time: doc.data['time'],
                  )).toList();
                  return ListView(
                    children: <Widget>[...messages],
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black54
              ),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: "Say Hi!"
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: 4,
                    ),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        color: Colors.blueGrey,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.cyan),
                      splashColor: Colors.red,
                    ),
                  ),
                  SendButton(
                    callback: callback,
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}



class SendButton extends StatelessWidget{
  final VoidCallback callback;

  const SendButton({Key key, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: Colors.blueGrey
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: IconButton(
        icon: Icon(Icons.send, color: Colors.cyan),
        splashColor: Colors.blue,
        onPressed: callback,
      ),
    );
  }
}


/// ChatMessage class consists of the UI design of the chat messages
class ChatMessage extends StatelessWidget{
  final String from;
  final String text;
  final String date;
  final String time;
  final bool me;

  const ChatMessage({Key key, this.from, this.text, this.me, this.date, this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(from),
          Material(
            color: me ? Colors.deepPurpleAccent : Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300.0,
                maxWidth: 200.0,
                minWidth: 100.0,
                minHeight: 40.0
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Text(text),
            ),
          ),
          Text(time,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}


/// Registration class allows a user to register using an Email-id and password
/// Similar to SignIn class, only difference is with firebase syntax
class Reg extends StatefulWidget {
  static const String id = "Register";
  @override
  RegState createState() => RegState();
}



class RegState extends State<Reg> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> register() async {                                               //Syntax to communicate with firebase
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(user: user),
    ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "title",
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dash Registration"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250,
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "E-mail",
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    autofocus: false,
                    onChanged: (value) => email = value,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Container(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(Icons.security),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                obscureText: true,
                onChanged: (value) => password = value,
              ),
            ),
            SizedBox(height: 20.0,),
            Button(
              text: "Create",
              method: () async{
                await register();
              },
            ),
          ],
        ),
      ),
    );
  }
}
