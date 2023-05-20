import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Field Focus',
      home: MyCustomForm(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
        ),
        bottomAppBarColor: Colors.grey[300],
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> with TickerProviderStateMixin {
  late FocusNode myFocusNode;
  late TextEditingController textEditingController;
  int counter = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    textEditingController = TextEditingController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    textEditingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void clearTextField() {
    textEditingController.clear();
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text('¡Estás en mi página!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void refreshPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Leonardo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80.0,
                child: ScaleTransition(
                  scale: _animation,
                  child: Image.asset('assets/ellafreya.jpg'),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Contador: $counter',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: textEditingController,
                autofocus: true,
              ),
              TextField(
                focusNode: myFocusNode,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(myFocusNode);
          _startAnimation();
        },
        tooltip: 'Hola, bienvenido a mi página',
        child: ScaleTransition(
          scale: _animation,
          child: Icon(Icons.edit),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56.0,
        color: Colors.grey[300],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Actualizar la página
                refreshPage();
              },
              icon: ScaleTransition(
                scale: _animation,
                child: Icon(Icons.refresh),
              ),
              color: Colors.purple,
            ),
            IconButton(
              onPressed: () {
                // Limpiar el campo de texto
                clearTextField();
              },
              icon: ScaleTransition(
                scale: _animation,
                child: Icon(Icons.delete),
              ),
              color: Colors.purple,
            ),
            IconButton(
              onPressed: () {
                // Mostrar alerta
                showAlert();
              },
              icon: ScaleTransition(
                scale: _animation,
                child: Icon(Icons.info),
              ),
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
