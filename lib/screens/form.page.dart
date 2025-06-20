import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  double weight = 0;
  int reps = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulari")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      width: 70,
                      height: 40,
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: weight.toString(),
                        decoration: InputDecoration(
                          hintText: 'Enter text',
                          border: InputBorder.none, // removes underline
                          enabledBorder:
                              InputBorder.none, // removes when not focused
                          focusedBorder:
                              InputBorder.none, // removes when focused
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if(val.isNotEmpty){
                              weight = double.parse(val);
                            }
                            
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Repes',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      width: 70,
                      height: 40,
                      alignment: Alignment.center,
                      child: TextFormField(
                        initialValue: weight.toString(),
                        decoration: InputDecoration(
                          hintText: 'Enter text',
                          border: InputBorder.none, // removes underline
                          enabledBorder:
                              InputBorder.none, // removes when not focused
                          focusedBorder:
                              InputBorder.none, // removes when focused
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (val) {
                          setState(() {
                            if(val.isNotEmpty){
                              reps = int.parse(val);
                            }
                            
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Text("El peso es queso: $weight"),
            Text("y las reps: $reps"),
            SizedBox(height: 10,),
            // Spacer(),
            GestureDetector(
              onTap: () {
                print("Weight $weight");
              },
              child: Container(
              padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Enviar", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
