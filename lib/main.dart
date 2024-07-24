import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FM DEMO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'FM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          Card(
              child:Padding(padding: EdgeInsets.all(10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("Add Transaction"),
                  SizedBox(height: 10),
                  _TitleTextField(),
                  SizedBox(height: 10),
                  _TitleTitleField(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TransactionActionButton(label: "Income",),
                      _TransactionActionButton(label: "Expense",)
                    ],
                  )
                  ],
              ))
          ),
        ],
      )
    );
  }
}

class _TransactionActionButton extends StatelessWidget {
  final String label;
  const _TransactionActionButton({
    super.key,
    required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(onPressed: ()=>debugPrint("Ha"), child: Text(label));
  }
}

class _TitleTextField extends StatelessWidget {
  const _TitleTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TextField(decoration: InputDecoration(labelText:"Amount",border: OutlineInputBorder()),keyboardType: TextInputType.number,);
  }
}

class _TitleTitleField extends StatelessWidget {
  const _TitleTitleField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TextField(decoration: InputDecoration(labelText:"Title",border: OutlineInputBorder()),keyboardType: TextInputType.text,);
  }
}