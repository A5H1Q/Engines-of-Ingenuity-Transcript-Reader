import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart';
import 'package:engine_reader/database_client.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:one_context/one_context.dart';

int tarzan = 0;
String dateFormatter() {
  var now = DateTime.now();
  var formatter = new DateFormat();
  String formatted = formatter.format(now);
  return formatted;
}

void main() => runApp(MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().key,
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.grey,
          brightness: Brightness.light),
      initialRoute: '/Oggie',
      routes: {
        '/Oggie': (context) => Oggie(),
        '/Credits': (context) => Credits(),
      },
    ));

class TodoItem extends StatelessWidget {
  int _id;
  String _itemName;
  String _dateCreated;
  String _www;
  String _kind;
  int _jmp;

  TodoItem(this._itemName, this._dateCreated, this._www, this._kind, this._jmp);

  TodoItem.map(dynamic obj) {
    this._id = obj["id"];
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._www = obj["www"];
    this._kind = obj["kind"];
    this._jmp = obj["jmp"];
  }

  int get id => _id;
  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  String get www => _www;
  String get kind => _kind;
  int get jmp => _jmp;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map["id"] = _id;
    }
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    map["www"] = _www;
    map["kind"] = _kind;
    map["jmp"] = _jmp;
    return map;
  }

  TodoItem.fromMap(Map<String, dynamic> map) {
    this._id = map["id"];
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._www = map["www"];
    this._kind = map["kind"];
    this._jmp = map["jmp"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _itemName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "$_dateCreated",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.5,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Oggie extends StatefulWidget {
  @override
  _OggieState createState() => new _OggieState();
}

class _OggieState extends State<Oggie> {
  TextEditingController _textFieldController = new TextEditingController();
  var db = DatabaseHelper();
  final List<TodoItem> _itemsList = <TodoItem>[];
  InAppWebViewController webView;
  ContextMenu contextMenu;
  BuildContext progressContxt;
  String url = "";
  int epi;
  bool book = true;
  bool widgetVisible = true;
  double progress = 0;
  double pass = 1;

  @override
  void initState() {
    super.initState();
  }

  void showWidget() {
    setState(() {
      widgetVisible = true;
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    });

    Navigator.pop(context);
  }

  void hideWidget() {
    setState(() {
      widgetVisible = false;
      SystemChrome.setEnabledSystemUIOverlays([]);
    });

    Navigator.pop(context);
  }

  void bobRoss() {
    Navigator.pop(context);
    if (_itemsList.length > 1) {
      showBarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          margin: EdgeInsets.only(top: 20, left: 5, right: 5),
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                    itemCount: _itemsList.length,
                    itemBuilder: (_, int index) {
                      if (_itemsList[index].itemName == "gdyxtanzcoseq") {
                        return Card();
                      } else {
                        return Card(
                          child: ListTile(
                            title: _itemsList[index],
                            onTap: () async {
                              Navigator.pop(context);
                              if (_itemsList[index].kind == "song") {
                                epi = _itemsList[index].jmp;
                                daVinci(_itemsList[index].jmp);
                              } else {
                                tarzan = _itemsList[index].jmp;
                                await webView.loadUrl(
                                    url: _itemsList[index].www);
                              }
                            },
                            onLongPress: () =>
                                _updateItem(_itemsList[index], index),
                            leading: Builder(
                              builder: (BuildContext context) {
                                return IconButton(
                                    icon: Icon((_itemsList[index].kind == "web")
                                        ? Icons.language
                                        : (_itemsList[index].kind == "tale")
                                            ? Icons.bookmarks
                                            : Icons.music_note),
                                    onPressed: () {});
                              },
                            ),
                            trailing: Builder(
                              //key: Key(_itemsList[index].itemName),
                              builder: (BuildContext context) {
                                return IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    _handleDelete(_itemsList[index].id, index);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      );
    } else {
      showBarModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("No Bookmark saved!",
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontSize: 15, color: Colors.black54)),
            ],
          ),
        ),
      );
    }
  }

  void daVinci(int value) {
    book = false;
    webView.loadData(data: """
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<style>
html,body{height:100%;overflow:hidden;background:#000 !important;}
body{
 display: flex;
  justify-content: center;
  align-items: center;
}
audio{display:none;outline:none}
p{color:#fff}
#loader {
  border: 5px solid #fff;
  border-radius: 50%;
  border-top: 5px solid transparent;
  width: 75px;
  height: 75px;
  -webkit-animation: spin .5s linear infinite; /* Safari */
  animation: spin .5s linear infinite;
}

/* Safari */
@-webkit-keyframes spin {
  0% { -webkit-transform: rotate(0deg); }
  100% { -webkit-transform: rotate(360deg); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
</head>
<body>
<!-- <p>$value </p> -->
<div id="loader"></div>
<audio id="audio" controls="controls" autoplay onloadeddata="myOnLoadedData()" controlsList="nodownload">
  <source id="audioSource" src=""></source>
  Your browser does not support the audio format.
</audio>
<script>

  var audio = document.getElementById('audio');
  var source = document.getElementById('audioSource');
  source.src = 'http://www.kuhf.org/programaudio/engines/eng'+$value+'_64k.mp3';
  audio.load();

 window.addEventListener("flutterInAppWebViewPlatformReady", function(event){
  audio.onended = function() {
    window.flutter_inappwebview.callHandler('viki').then(function(result) {
    });
  };
});

function myOnLoadedData() { document.getElementById("loader").style.display="none";audio.style.display="block";  audio.play(); 
 }
</script>
</body>
</html>

                  """);
  }

  loadingDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: true,
      builder: (BuildContext context) {
        progressContxt = context;
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Text("Loading Reader view..")),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _readTodoList() async {
    List items = await db.getAllItems();
    items.forEach((item) {
      setState(() {
        _itemsList.add(TodoItem.map(item));
      });
    });
  }

  void _handleSubmit() async {
    if (epi == 5000) {
      TodoItem item = new TodoItem(
          url, dateFormatter(), url, "web", await webView.getScrollY());
      int savedItemId = await db.saveItem(item);
      TodoItem savedItem = await db.getTodoItem(savedItemId);
      setState(() {
        _itemsList.insert(0, savedItem);
      });
      var snackbar = SnackBar(
        content: Text('Website link Bookmarked'),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      );

      Scaffold.of(context).showSnackBar(snackbar);
    } else if (book) {
      TodoItem item = new TodoItem("Episode " + epi.toString(), dateFormatter(),
          url, "tale", await webView.getScrollY());
      int savedItemId = await db.saveItem(item);
      TodoItem savedItem = await db.getTodoItem(savedItemId);
      setState(() {
        _itemsList.insert(0, savedItem);
      });
      var snackbar = SnackBar(
        content: Text('New Bookmark Added'),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      );

      Scaffold.of(context).showSnackBar(snackbar);
    } else {
      TodoItem item = new TodoItem(
          "Episode " + epi.toString(), dateFormatter(), url, "song", epi);
      int savedItemId = await db.saveItem(item);
      TodoItem savedItem = await db.getTodoItem(savedItemId);
      setState(() {
        _itemsList.insert(0, savedItem);
      });
      var snackbar = SnackBar(
        content: Text('Audio Track Bookmarked'),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      );

      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  _handleDelete(int id, int index) async {
    var snackbar = SnackBar(
      content: Text('Bookmark Removed'),
      margin: EdgeInsets.all(10),
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    );
    Scaffold.of(context).showSnackBar(snackbar);
    await db.deleteItem(id);
    setState(() {
      _itemsList.removeAt(index);
    });
    bobRoss();
  }

  _updateItem(TodoItem item, int index) {
    _textFieldController.text = item.itemName;
    return showDialog(
        context: context,
        builder: (defcon) {
          return AlertDialog(
            title: Text("Update bookmark"),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: TextField(
                  controller: _textFieldController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: "Name", icon: Icon(Icons.bookmarks_outlined)),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Cancel"),
                  textColor: Colors.black,
                  onPressed: () => Navigator.of(defcon).pop()),
              new FlatButton(
                  child: new Text("Save"),
                  textColor: Colors.black,
                  onPressed: () async {
                    TodoItem updatedItem = TodoItem.fromMap({
                      "itemName": _textFieldController.text,
                      "dateCreated": item.dateCreated,
                      "id": item.id,
                      "www": item.www,
                      "kind": item.kind,
                      "jmp": item.jmp,
                    });
                    _handleUpdate(index, updatedItem);
                    await db.updateItem(updatedItem);
                    setState(() {
                      _readTodoList();
                    });
                    Navigator.of(defcon).pop();
                  }),
            ],
          );
        });
  }

  void _handleUpdate(int index, TodoItem updatedItem) {
    setState(() {
      _itemsList.removeWhere((element) {
        _itemsList[index].itemName == updatedItem.itemName;
      });
    });
  }

  Drawer myDrawer({@required BuildContext context}) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DrawerHeader(
                      child: Text('  Online Reader',
                          style: TextStyle(height: 3, fontSize: 25)),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    ListTile(
                      leading: Icon(Icons.home_sharp),
                      title: Text("Home"),
                      onTap: () async {
                        if (epi == 5000) {
                          Navigator.popAndPushNamed(context, '/Oggie');
                        } else {
                          if (!book) {
                            setState(() {
                              book = true;
                            });

                            await webView.loadUrl(
                                url: "https://www.uh.edu/engines/epi" +
                                    epi.toString() +
                                    ".htm");
                            TodoItem updatedItem = TodoItem.fromMap({
                              "itemName": "gdyxtanzcoseq",
                              "dateCreated": "started",
                              "id": 0,
                              "www": "0",
                              "kind": "tale",
                              "jmp": epi,
                            });
                            await db.updateItem(updatedItem);
                          }
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.switch_right),
                      title: Text("Jump To"),
                      onTap: () {
                        Navigator.pop(context);
                        return showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: Text('Choose Episode'),
                                content: SpinBox(
                                  min: 1,
                                  max: 10000,
                                  value: 1,
                                  step: 1,
                                  acceleration: 10,
                                  onChanged: (value) {
                                    pass = value;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Episode No.',
                                      helperText: ' ',
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      border: UnderlineInputBorder()),
                                  validator: (text) => (text.isEmpty ||
                                          int.tryParse(text) > 3245)
                                      ? 'Episodes 1 to 3245 Only'
                                      : null,
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                      child: new Text("CANCEL"),
                                      textColor: Colors.black,
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                      }),
                                  new FlatButton(
                                      child: new Text("NEXT"),
                                      textColor: Colors.black,
                                      onPressed: () async {
                                        await webView.loadUrl(
                                            url:
                                                "https://www.uh.edu/engines/epi" +
                                                    pass
                                                        .toStringAsFixed(0)
                                                        .toString() +
                                                    ".htm");
                                        Navigator.of(dialogContext).pop();
                                        TodoItem updatedItem =
                                            TodoItem.fromMap({
                                          "itemName": "gdyxtanzcoseq",
                                          "dateCreated": "started",
                                          "id": 0,
                                          "www": "0",
                                          "kind": "tale",
                                          "jmp": pass.toInt(),
                                        });
                                        await db.updateItem(updatedItem);
                                      }),
                                ],
                              );
                            });
                      },
                    ),
                    ListTile(
                      leading: widgetVisible
                          ? Icon(Icons.fullscreen)
                          : Icon(Icons.fullscreen_exit),
                      title: widgetVisible
                          ? Text("Fullscreen")
                          : Text("Exit fullscreen"),
                      onTap: () {
                        if (widgetVisible) {
                          hideWidget();
                        } else {
                          showWidget();
                        }
                      },
                    ),
                    ListTile(
                        leading: Icon(Icons.bookmarks_sharp),
                        title: Text("Bookmarks"),
                        onTap: () {
                          bobRoss();
                        }),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text("Credits"),
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/Credits');
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (epi != 5000) {
      if (!widgetVisible) {
        setState(() {
          widgetVisible = true;
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        });
        return null;
      } else {
        return (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                content: (epi == 5000 || !book)
                    ? new Text("Do you want to exit ?")
                    : new Text("Save current Progress and exit ?"),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text("CANCEL"),
                      textColor: Colors.black,
                      onPressed: () => Navigator.pop(context)),
                  new FlatButton(
                      child: new Text("OK"),
                      textColor: Colors.black,
                      onPressed: () async {
                        if (epi == 5000 || !book) {
                          SystemNavigator.pop();
                        } else {
                          TodoItem updatedItem = TodoItem.fromMap({
                            "itemName": "gdyxtanzcoseq",
                            "dateCreated": "started",
                            "id": 0,
                            "www": (await webView.getScrollY()).toString(),
                            "kind": "tale",
                            "jmp": epi,
                          });
                          await db.updateItem(updatedItem);
                          SystemNavigator.pop();
                        }
                      }),
                ],
              ),
            )) ??
            false;
      }
    } else {
      webView.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: widgetVisible
              ? AppBar(
                  iconTheme: IconThemeData(color: Colors.black),
                  title: const Text('The Engines of Our Ingenuity',
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: Colors.white,
                )
              : PreferredSize(
                  preferredSize: Size(0.0, 0.0),
                  child: Container(),
                ),
          drawer: myDrawer(context: context),
          body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                widgetVisible
                    ? Container(
                        padding: EdgeInsets.only(top: 20.0),
                      )
                    : Container(),

                widgetVisible
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Icon(
                              (epi == 5000)
                                  ? Icons.language
                                  : (book)
                                      ? Icons.double_arrow
                                      : Icons.volume_up,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text((epi != 5000)
                              ? "Episode " + epi.toString()
                              : url),
                        ],
                      )
                    : Row(),
                widgetVisible
                    ? Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: progress < 1.0
                            ? LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.lightBlue[100],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue))
                            : Container())
                    : Container(),

//webview begins
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1.0, color: Colors.grey),
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                    ),
                    child: InAppWebView(
                      // initialUrl: "https://www.uh.edu/engines/epi1.htm",
                      initialHeaders: {},
                      initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                            mediaPlaybackRequiresUserGesture: false,
                            useShouldOverrideUrlLoading: true,
                          ),
                          android: AndroidInAppWebViewOptions(
                              useHybridComposition: true)),
                      shouldOverrideUrlLoading:
                          (controller, shouldOverrideUrlLoadingRequest) async {
                        var url = shouldOverrideUrlLoadingRequest.url;
                        var uri = Uri.parse(url);
                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunch(url)) {
                            // Launch the App
                            await launch(
                              url,
                            );
                            // and cancel the request
                            return ShouldOverrideUrlLoadingAction.CANCEL;
                          }
                        }

                        return ShouldOverrideUrlLoadingAction.ALLOW;
                      },
                      onWebViewCreated:
                          (InAppWebViewController controller) async {
                        webView = controller;
                        List items = await db.getAllItems();
                        items.forEach((item) {
                          setState(() {
                            _itemsList.add(TodoItem.map(item));
                          });
                        });
                        if (_itemsList[0].kind == "song") {
                          epi = _itemsList[0].jmp;
                          book = false;
                          daVinci(_itemsList[0].jmp);
                        } else if (_itemsList[0].kind == "tale") {
                          epi = _itemsList[0].jmp;
                          setState(() {
                            book = true;
                          });
                          await webView.loadUrl(
                              url: "https://www.uh.edu/engines/epi" +
                                  _itemsList[0].jmp.toString() +
                                  ".htm");
                          tarzan = int.tryParse(_itemsList[0].www);
                        }
                      },
                      onLoadStart: (InAppWebViewController controller,
                          String url) async {
                        setState(() {
                          this.url = url;
                        });
                        webView = controller;
                        if (url != "about:blank") {
                          if (url.split("s/epi")[0] ==
                              "https://www.uh.edu/engine") {
                            epi = int.tryParse(url.substring(
                                url.lastIndexOf("/epi") + 4,
                                url.lastIndexOf(".htm")));
                            loadingDialog();
                          } else {
                            epi = 5000;
                          }
                        }
                      },
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {
                        setState(() {
                          this.url = url;
                        });
                        webView = controller;
                        if (url != "about:blank") {
                          if (url.split("s/epi")[0] ==
                              "https://www.uh.edu/engine") {
                            await controller.evaluateJavascript(
                                source:
                                    "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0');document.getElementsByTagName('head')[0].appendChild(meta);document.getElementsByTagName('a')[0].style.display='none';document.getElementsByTagName('a')[1].style.display='none';");
                            await controller.injectCSSFileFromAsset(
                                assetFilePath: "assets/style.css");
                            Navigator.pop(progressContxt);
                          }
                          if (tarzan != 0) {
                            webView.scrollTo(x: 0, y: tarzan, animated: true);
                            tarzan = 0;
                          }
                        } else {
                          controller.addJavaScriptHandler(
                              handlerName: "viki",
                              callback: (args) async {
                                if (epi < 3245) {
                                  epi = epi + 1;
                                  daVinci(epi);
                                  TodoItem updatedItem = TodoItem.fromMap({
                                    "itemName": "gdyxtanzcoseq",
                                    "dateCreated": "started",
                                    "id": 0,
                                    "www": "0",
                                    "kind": "song",
                                    "jmp": epi,
                                  });
                                  await db.updateItem(updatedItem);
                                } else {
                                  daVinci(3245);
                                }
                              });
                        }
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                  ),
                ),
//webview ends
                widgetVisible
                    ? ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            textColor: Colors.black,
                            onPressed: () async {
                              if (webView != null) {
                                if (epi != 5000) {
                                  if (book) {
                                    daVinci(epi);
                                    TodoItem updatedItem = TodoItem.fromMap({
                                      "itemName": "gdyxtanzcoseq",
                                      "dateCreated": "started",
                                      "id": 0,
                                      "www": "0",
                                      "kind": "song",
                                      "jmp": epi,
                                    });
                                    await db.updateItem(updatedItem);
                                  } else {
                                    setState(() {
                                      book = true;
                                    });

                                    await webView.loadUrl(
                                        url: "https://www.uh.edu/engines/epi" +
                                            epi.toString() +
                                            ".htm");
                                    TodoItem updatedItem = TodoItem.fromMap({
                                      "itemName": "gdyxtanzcoseq",
                                      "dateCreated": "started",
                                      "id": 0,
                                      "www": "0",
                                      "kind": "tale",
                                      "jmp": epi,
                                    });
                                    await db.updateItem(updatedItem);
                                  }
                                } else {
                                  setState(() {
                                    book = true;
                                  });

                                  await webView.loadUrl(
                                      url:
                                          "https://www.uh.edu/engines/epi1.htm");
                                }
                              }
                            },
                            child: Icon((epi == 5000)
                                ? Icons.home
                                : (book)
                                    ? Icons.volume_up
                                    : Icons.format_align_left),
                          ),
                          FlatButton(
                            child: Icon((book)
                                ? Icons.bookmark_border
                                : Icons.playlist_add),
                            textColor: Colors.black,
                            onPressed: () {
                              if (webView != null) {
                                _handleSubmit();
                              }
                            },
                          ),
                          FlatButton(
                            child: Icon(Icons.arrow_back_ios),
                            textColor: Colors.black,
                            onPressed: () async {
                              if (webView != null) {
                                if (epi != 5000) {
                                  if (epi > 1) {
                                    epi = epi - 1;
                                    if (book) {
                                      await webView.loadUrl(
                                          url:
                                              "https://www.uh.edu/engines/epi" +
                                                  epi.toString() +
                                                  ".htm");
                                      TodoItem updatedItem = TodoItem.fromMap({
                                        "itemName": "gdyxtanzcoseq",
                                        "dateCreated": "started",
                                        "id": 0,
                                        "www": "0",
                                        "kind": "tale",
                                        "jmp": epi,
                                      });
                                      await db.updateItem(updatedItem);
                                    } else {
                                      TodoItem updatedItem = TodoItem.fromMap({
                                        "itemName": "gdyxtanzcoseq",
                                        "dateCreated": "started",
                                        "id": 0,
                                        "www": "0",
                                        "kind": "song",
                                        "jmp": epi,
                                      });
                                      await db.updateItem(updatedItem);
                                      daVinci(epi);
                                    }
                                  } else {
                                    if (book) {
                                      await webView.loadUrl(
                                          url:
                                              "http://www.csn.ul.ie/~darkstar/assembler/tut3.html");
                                    } else {
                                      daVinci(1);
                                    }
                                  }
                                } else {
                                  webView.goBack();
                                }
                              }
                            },
                          ),
                          FlatButton(
                            child: Icon(Icons.arrow_forward_ios),
                            textColor: Colors.black,
                            onPressed: () async {
                              if (webView != null) {
                                if (epi != 5000) {
                                  if (epi < 3245) {
                                    epi = epi + 1;
                                    if (book) {
                                      await webView.loadUrl(
                                          url:
                                              "https://www.uh.edu/engines/epi" +
                                                  epi.toString() +
                                                  ".htm");
                                      TodoItem updatedItem = TodoItem.fromMap({
                                        "itemName": "gdyxtanzcoseq",
                                        "dateCreated": "started",
                                        "id": 0,
                                        "www": "0",
                                        "kind": "tale",
                                        "jmp": epi,
                                      });
                                      await db.updateItem(updatedItem);
                                    } else {
                                      daVinci(epi);
                                      TodoItem updatedItem = TodoItem.fromMap({
                                        "itemName": "gdyxtanzcoseq",
                                        "dateCreated": "started",
                                        "id": 0,
                                        "www": "0",
                                        "kind": "song",
                                        "jmp": epi,
                                      });
                                      await db.updateItem(updatedItem);
                                    }
                                  } else {
                                    if (book) {
                                      await webView.loadUrl(
                                          url:
                                              "https://www.uh.edu/engines/epi3245.htm");
                                    } else {
                                      daVinci(3245);
                                    }
                                  }
                                } else {
                                  webView.goForward();
                                }
                              }
                            },
                          ),
                        ],
                      )
                    : Container(),
              ]))),
    );
  }
}

// Second Page Nav: Credit Page

class Credits extends StatefulWidget {
  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('Credits', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Text('Content By Houston University',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, height: 3)),
                    Divider(),
                    Text(
                        '\nAll contents are property of University of Houston and is served from www.uh.edu/engines. They created this amazing series about machines that make our civilization run and the people whose ingenuity created them.',
                        textAlign: TextAlign.center),
                    Text('Audio By KUHF Radio, Houston',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, height: 7)),
                    Divider(),
                    Text(
                      '\nAll Audio tracks are property of Kuhf and is served from www.kuhf.org/programaudio/engines. These were written and hosted by John Lienhard and other awesome contributors, This series is heard nationally on KUHF and other Public Radio broadcast.',
                      textAlign: TextAlign.center,
                    ),
                    Text("Programmer's note:",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, height: 7)),
                    Divider(),
                    Text(
                      "\nThis is a fan-made app and would never run any ads or be monetized in any sort or form. All data are fetched online and no content is locally stored. hence subject to online availability..\n\nThe app is open source and is created using flutter, under the hood its simply a web browser that displays web pages, but with an additional feature to  provide a simplified view for mobile user's readability. shoot me a mail at ashiksaleem20@gmail.com for more info.\n\n\n - With Regards, A fan.\n\n\n",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
