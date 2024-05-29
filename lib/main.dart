import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'BMI Calculator'),
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
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inchController = TextEditingController();
  var ageController = TextEditingController();

  var result = "";
  var bgColor = Color(0xFFEBEBEB);
  String selectedUnit = 'kg';
  String gender = 'Male';
  List<String> bmiHistory = [];
  bool isDarkTheme = false;
  bool isHistoryExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkTheme = !isDarkTheme;
              });
            },
          ),
        ],
      ),
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 22),
                Text(
                  "B M I Calculator",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 85, 85, 85),
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  height: 100,
                  decoration: BoxDecoration(
                    //color: Color.fromARGB(255, 196, 247, 247),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Male';
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.male,
                              size: 64,
                              color: gender == 'Male' ? Colors.blue : Color.fromARGB(255, 131, 131, 131),
                            ),
                            Text(
                              'Male',
                              style: TextStyle(
                                fontSize: 18,
                                color: gender == 'Male' ? Colors.blue : Color.fromARGB(255, 131, 131, 131),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 80),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            gender = 'Female';
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.female,
                              size: 64,
                              color: gender == 'Female' ? Colors.pink : Color.fromARGB(255, 131, 131, 131),
                            ),
                            Text(
                              'Female',
                              style: TextStyle(
                                fontSize: 18,
                                color: gender == 'Female' ? Colors.pink : Color.fromARGB(255, 131, 131, 131),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: wtController,
                        decoration: InputDecoration(
                          label: Text('Weight'),
                          prefixIcon: Icon(Icons.line_weight),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUnit = newValue!;
                        });
                      },
                      items: <String>['kg', 'lbs'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 22),
                TextField(
                  controller: ftController,
                  decoration: InputDecoration(
                    label: Text('Height (In Feet)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 22),
                TextField(
                  controller: inchController,
                  decoration: InputDecoration(
                    label: Text('Height (In Inches)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 22),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    label: Text('Age'),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {
                    var wt = wtController.text.toString();
                    var ft = ftController.text.toString();
                    var inch = inchController.text.toString();
                    var age = ageController.text.toString();

                    if (wt != "" && ft != "" && inch != "" && age != "") {
                      var iWt = int.parse(wt);
                      if (selectedUnit == 'lbs') {
                        iWt = (iWt / 2.205).round(); // Convert lbs to kg
                      }
                      var iFt = int.parse(ft);
                      var iInch = int.parse(inch);
                      var iAge = int.parse(age);

                      var total_inch = (iFt * 12) + iInch;
                      var total_Cm = total_inch * 2.54;
                      var total_meter = total_Cm / 100;

                      var bmi = iWt / (total_meter * total_meter);

                      var msg = "";
                      if (bmi > 25) {
                        msg = "You are OverWeight!!";
                        bgColor = Color.fromARGB(255, 236, 173, 77);
                      } else if (bmi < 18) {
                        msg = "You are UnderWeight!!";
                        bgColor = Color.fromARGB(255, 238, 131, 142);
                      } else {
                        msg = "You are Healthy!!";
                        bgColor = Color.fromARGB(255, 154, 245, 157);
                      }

                      setState(() {
                        result = "$msg \nYour BMI is : ${bmi.toStringAsFixed(2)}";
                        bmiHistory.add("BMI: ${bmi.toStringAsFixed(2)} - $msg");
                      });
                    } else {
                      setState(() {
                        result = "Please fill all the blanks .....";
                      });
                    }
                  },
                  child: Text(
                    'Calculate',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wtController.clear();
                      ftController.clear();
                      inchController.clear();
                      ageController.clear();
                      result = "";
                      bgColor = Colors.indigo.shade100;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  result,
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(height: 22),
                Text(
                  "------------------------------------\n              History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: const Color.fromARGB(255, 97, 97, 97),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: isHistoryExpanded ? bmiHistory.length : (bmiHistory.length > 2 ? 2 : bmiHistory.length),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(bmiHistory[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    bmiHistory.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      if (bmiHistory.length > 2)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isHistoryExpanded = !isHistoryExpanded;
                            });
                          },
                          child: Text(isHistoryExpanded ? 'Show Less' : 'Show More'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
