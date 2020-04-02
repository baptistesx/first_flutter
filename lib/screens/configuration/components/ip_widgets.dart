import 'package:flutter/material.dart';

class Ip1ExtWidget extends StatefulWidget {
  Ip1ExtWidget({Key key}) : super(key: key);

  @override
  _Ip1ExtWidgetState createState() => _Ip1ExtWidgetState();
}

class _Ip1ExtWidgetState extends State<Ip1ExtWidget> {
  int ip1 = 192;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip1,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip1 = value;
        });
      },
    );
  }
}

class Ip2ExtWidget extends StatefulWidget {
  Ip2ExtWidget({Key key}) : super(key: key);

  @override
  _Ip2ExtWidgetState createState() => _Ip2ExtWidgetState();
}

class _Ip2ExtWidgetState extends State<Ip2ExtWidget> {
  int ip2 = 168;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip2,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip2 = value;
        });
      },
    );
  }
}

class Ip3ExtWidget extends StatefulWidget {
  Ip3ExtWidget({Key key}) : super(key: key);

  @override
  _Ip3ExtWidgetState createState() => _Ip3ExtWidgetState();
}

class _Ip3ExtWidgetState extends State<Ip3ExtWidget> {
  int ip3 = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip3,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip3 = value;
        });
      },
    );
  }
}

class Ip4ExtWidget extends StatefulWidget {
  Ip4ExtWidget({Key key}) : super(key: key);

  @override
  _Ip4ExtWidgetState createState() => _Ip4ExtWidgetState();
}

class _Ip4ExtWidgetState extends State<Ip4ExtWidget> {
  int ip4 = 68;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip4,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip4 = value;
        });
      },
    );
  }
}

class Ip1IntWidget extends StatefulWidget {
  Ip1IntWidget({Key key}) : super(key: key);

  @override
  _Ip1IntWidgetState createState() => _Ip1IntWidgetState();
}

class _Ip1IntWidgetState extends State<Ip1IntWidget> {
  int ip1 = 192;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip1,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip1 = value;
        });
      },
    );
  }
}

class Ip2IntWidget extends StatefulWidget {
  Ip2IntWidget({Key key}) : super(key: key);

  @override
  _Ip2IntWidgetState createState() => _Ip2IntWidgetState();
}

class _Ip2IntWidgetState extends State<Ip2IntWidget> {
  int ip2 = 168;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip2,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip2 = value;
        });
      },
    );
  }
}

class Ip3IntWidget extends StatefulWidget {
  Ip3IntWidget({Key key}) : super(key: key);

  @override
  _Ip3IntWidgetState createState() => _Ip3IntWidgetState();
}

class _Ip3IntWidgetState extends State<Ip3IntWidget> {
  int ip3 = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip3,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip3 = value;
        });
      },
    );
  }
}

class Ip4IntWidget extends StatefulWidget {
  Ip4IntWidget({Key key}) : super(key: key);

  @override
  _Ip4IntWidgetState createState() => _Ip4IntWidgetState();
}

class _Ip4IntWidgetState extends State<Ip4IntWidget> {
  int ip4 = 68;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip4,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip4 = value;
        });
      },
    );
  }
}