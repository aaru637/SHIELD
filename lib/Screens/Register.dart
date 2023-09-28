import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield/Database/Database.dart';
import 'package:shield/Database/Database_Model.dart';
import 'package:shield/Home_Screens/Home_Page.dart';
import 'package:shield/Reusable/Reusable.dart';

class Register_Page extends StatefulWidget {
  const Register_Page({Key? key}) : super(key: key);

  @override
  State<Register_Page> createState() => _Register_PageState();
}

class _Register_PageState extends State<Register_Page> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  String Message =
      "I'm in Danger. Please Help Me.";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/register.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.29,
              ),
              child: ListView(
                children: <Widget>[
                  // Full Name Field
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 40,
                      right: 40,
                      bottom: 30,
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      style: const TextStyle(
                        fontFamily: 'Cambria',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: name,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                            color: Colors.green),
                        suffixIconColor: Colors.greenAccent,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        hintText: "Dhineshkumar",
                        labelText: "Full Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your Full Name...";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Mobile Number Field
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 40,
                      right: 40,
                      bottom: 30,
                    ),
                    alignment: Alignment.center,
                    child: TextFormField(
                      style: const TextStyle(
                        fontFamily: 'Cambria',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: mobile,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                          onPressed: () {},
                        ),
                        suffixIconColor: Colors.greenAccent,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        hintText: "1234567890",
                        labelText: "Mobile",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your Mobile Number...";
                        }
                        return null;
                      },
                    ),
                  ),

                  // Register Button
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                            fontFamily: 'Cambria',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final user = UserModel(
                              FullName: name.text.trim(),
                              Mobile: "91${mobile.text.trim()}",
                              Message: Message.trim());
                          bool result = await Database.insertUser(user);
                          if (result) {
                            SharedPreferences sharedpreferences =
                                await SharedPreferences.getInstance();
                            sharedpreferences.setString("name", name.text.trim());
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => Home_Page(
                                          Name: name.text.trim(),
                                        )));
                            Reusable.Success("Registered Successfully", context);
                          } else {
                            Reusable.Failure("Error Occured on Register Yourself.", context);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
