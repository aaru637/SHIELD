import 'package:flutter/material.dart';
import 'package:shield/Database/Database_Model.dart';
import 'package:shield/Reusable/Reusable.dart';

import '../Database/Database.dart';

class Profile extends StatefulWidget {
  final String Name;
  const Profile({Key? key, required this.Name}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<UserModel> user = [];
  List<ContactsModel> Contactsmodel = [];
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController message = TextEditingController();

  void getUserDetails() async {
    user = await Database.getUser();
    mobile.text = user[0].Mobile;
    message.text = user[0].Message!;
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<List<ContactsModel>> getUserContacts() async {
    getUserDetails();
    final _contactsmodel = await Database.getContact();
    setState(() {
      Contactsmodel = _contactsmodel;
    });
    return Contactsmodel;
  }

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.Name;
    getUserContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.settings),
        //   )
        // ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Full Name Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.10,
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
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: mobile,
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

                // Message Field
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    left: 40,
                    right: 40,
                    bottom: 10,
                  ),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxWidth: MediaQuery.of(context).size.width,
                    minHeight: 25.0,
                    maxHeight: 100.0,
                  ),
                  alignment: Alignment.center,
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: 'Cambria',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textInputAction: TextInputAction.done,
                    controller: message,
                    maxLines: null,
                    maxLength: 30,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 13),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.message,
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
                      hintText: "I'm in Danger",
                      labelText: "Message",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter your Message...";
                      }
                      return null;
                    },
                  ),
                ),

                // Edit Button
                Container(
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                          fontFamily: 'Cambria',
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        UserModel userModel = UserModel(
                            FullName: name.text,
                            Mobile: mobile.text.trim(),
                            Message: message.text.trim());
                        await Database.updateUser(userModel);
                        Reusable.Success("Edited Successfuly...", context);
                        getUserDetails();
                      }
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: const Text(
                    "Added Contact Details",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ),
                const Divider(
                  thickness: 4,
                  indent: 40,
                  endIndent: 40,
                  color: Colors.black12,
                ),

                StreamBuilder(
                  stream: Database.getContact().asStream(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Contacts have been Added"),
                      );
                    }
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        ContactsModel contactss = snapshot.data[index];
                        return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: Colors.yellow[100],
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(contactss.Contact_Name!),
                            subtitle: Text(contactss.Contacts!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red,),
                              onPressed: () async {
                                bool result = await Database.deleteContact(contactss.Contacts!, contactss.Contact_Name!);
                                if(result){
                                  Reusable.Success("Removed SuccessFully...", context);
                                  getUserContacts();
                                }
                                else{
                                  Reusable.Failure("Error. Try Again..", context);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
