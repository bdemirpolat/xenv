import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:process_run/shell.dart';
import 'dart:io' show File, Platform;

import 'package:xenv/models/environment.dart';
import 'package:xenv/widget/input.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File profile = File("");
  bool profileExist;
  String error = "";
  List<Environment> lines = [];
  String homeDir = "";
  TextEditingController newEnv = TextEditingController();
  String saveButtonText = "Save";
  MaterialColor saveButtonColor = Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    this.getHomeDir();
    if (await this.initProfile()) {
      await readFile();
    }
  }

  initProfile() async {
    var profile = File(this.getHomeDir() + "/.xenv_profile");
    try {
      print(await profile.exists());
      if (await profile.exists()) {
        setState(() {
          this.profile = profile;
        });
      } else {
        // If file does not exist, try create new file
        var newProfile = await profile.create(recursive: true);
        if (await newProfile.exists()) {
          setState(() {
            this.profile = newProfile;
          });
        } else {
          setState(() {
            this.error = "File can not exist in " + this.profile.path;
          });
        }
      }
    } catch (e) {
      setState(() {
        this.error = e.toString();
      });
      return false;
    }
    return true;
  }

  Future<String> runCommand(String command) async {
    var shell = Shell();
    var out = await shell.run(command);
    print(out[0].stdout);
    if (out.length > 0) {
      return out[0].stdout.toString();
    } else {
      return "";
    }
  }

  String getHomeDir() {
    Map<String, String> environments = Platform.environment;
    setState(() {
      this.homeDir = "/Users/" + environments["USER"];
    });
    return this.homeDir;
  }

  readFile() async {
    setState(() {
      this.lines = [];
    });
    try {
      var readFile =
          this.profile.openRead().map(utf8.decode).transform(LineSplitter());
      await readFile.forEach((l) {
        var lineSplit = l.replaceAll("export ", "").split("=");

        this.addLine(key: lineSplit[0], value: lineSplit[1]);
      });
    } catch (e) {
      setState(() {
        this.error = e.toString();
      });
    }
  }

  saveFile() async {
    setState(() {
      this.saveButtonText = "Saving...";
      this.saveButtonColor = Colors.grey;
    });
    try {
      await this.profile.writeAsString(this
          .lines
          .map((e) {
            return "export " +
                e.keyControlller.text +
                "=" +
                e.valueControlller.text;
          })
          .toList()
          .join("\n"));
    } catch (e) {
      setState(() {
        this.error = e.toString();
      });
    }

    Future.delayed(Duration(milliseconds: 750), () {
      setState(() {
        this.saveButtonText = "Save";
        this.saveButtonColor = Colors.deepOrange;
      });
    });
  }

  addLine({String key = "", String value = ""}) {
    var line = Environment(
      TextEditingController(text: key),
      TextEditingController(text: value),
    );

    setState(() {
      this.lines.insert(0, line);
    });
  }

  deleteLine(int i) {
    setState(() {
      this.lines.removeAt(i);
    });
  }

  Widget warning() {
    if (this.error != "") {
      return Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 20,
                offset: Offset(0, 1),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Center(
            child: Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(flex: 2, child: Icon(Icons.warning)),
                Expanded(
                  flex: 8,
                  child: Text(this.error),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container();
  }

  Widget installationInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Row(
            children: [
              Expanded(flex: 1, child: Icon(Icons.warning)),
              Expanded(
                flex: 8,
                child: Text(
                    "Do not forget to reference the variables created here to be valid on your current shell profile. Done just once."),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Expanded(flex: 1, child: Icon(Icons.edit)),
              Expanded(flex: 8, child: Text("Open current shell profile.")),
            ],
          ),
        ),
        Row(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 8,
              child: SelectableText(
                "For zsh: " + this.homeDir + "/.zprofile",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 8,
              child: SelectableText(
                "For bash: " + this.homeDir + "/.bash_profile",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(flex: 1, child: Icon(Icons.add)),
              Expanded(
                flex: 8,
                child: Text("Add line below"),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 8,
              child: SelectableText(
                "source " + this.homeDir + "/.xenv_profile",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget fileInfo() {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child:
                      Text("Processed File", style: TextStyle(fontSize: 25))),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  this.profile.path,
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget list() {
    return Expanded(
        flex: 10,
        child: ListView.builder(
          itemCount: this.lines.length,
          itemBuilder: (BuildContext context, int i) {
            return listRow(context, i);
          },
        ));
  }

  Widget listRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomInput(context,
                validateEmpty: true,
                controller: this.lines[index].keyControlller)
            .create(),
        CustomInput(context,
                validateEmpty: true,
                controller: this.lines[index].valueControlller)
            .create(),
        Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.deepOrange,
              onPressed: () => deleteLine(index),
            )),
      ],
    );
  }

  Widget saveButton() {
    return Container(
      constraints: BoxConstraints(maxHeight: 75, minHeight: 35),
      margin: EdgeInsets.only(bottom: 15, top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: this.saveButtonColor),
      width: MediaQuery.of(context).size.width * 0.15,
      child: FlatButton(
        child: Text(this.saveButtonText, style: TextStyle(color: Colors.white)),
        onPressed: () {
          this.saveFile();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: addLine,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              fileInfo(),
              installationInfo(),
              warning(),
              list(),
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
