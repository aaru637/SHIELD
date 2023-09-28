import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shield/Database/Database.dart';
import 'package:shield/Database/Database_Model.dart';
import 'package:shield/Reusable/Reusable.dart';

class Contacts extends StatefulWidget {
  final String Name;
  const Contacts({Key? key, required this.Name}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [];
  List<String> Selected = [];
  List<String> Updated = [];
  List<Contact> updated = [];
  List<ContactsModel> Contactsmodel = [];
  late ContactsModel contactsModel;
  bool permission = false;
  bool isLoading = false;
  TextEditingController search = TextEditingController();

  Future<List<Contact>> getAllContacts() async {
    setState(() {
      isLoading = true;
    });
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      final _contacts = await FlutterContacts.getContacts(
          withThumbnail: true,
          withProperties: true,
          withPhoto: true,
          sorted: true,
          deduplicateProperties: true);
      setState(() {
        contacts = _contacts;
        search.clear();
      });
      for (int i = 0; i < contacts.length; i++) {
        Selected.add("true");
      }
      filter(contacts);
      setState(() {
        isLoading = false;
      });
      return contacts;
    }
    setState(() {
      isLoading = false;
    });
    return [];
  }

  Future<void> getUserContacts() async {
    final _contactsmodel = await Database.getContact();
    if (!mounted) {
      return;
    }
    setState(() {
      Contactsmodel = _contactsmodel;
    });
  }

  void filter(List<Contact> con) {
    getUserContacts();
    for (int i = 0; i < Contactsmodel.length; i++) {
      for (int j = 0; j < con.length; j++) {
        if (Contactsmodel[i].Contacts == con[j].phones.first.number) {
          Selected[j] = "false";
        }
      }
    }
    setState(() {});
  }

  void filter1(List<Contact> con) {
    getUserContacts();
    for (int i = 0; i < Contactsmodel.length; i++) {
      for (int j = 0; j < con.length; j++) {
        if (Contactsmodel[i].Contacts == con[j].phones.first.number) {
          Updated[j] = "false";
        }
      }
    }
    setState(() {});
  }

  void updateContacts(String value) {
    setState(() {
      updated = contacts
          .where((element) =>
              (element.displayName
                  .toLowerCase()
                  .contains(value.toLowerCase())) ||
              element.phones.first.number
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      for (int i = 0; i < updated.length; i++) {
        Updated.add("true");
      }
      filter(updated);
    });
  }

  checkContactsPermission() async {
    var status = await Permission.contacts.isGranted;
    if (!status) {
      Permission.contacts.request();
      openAppSettings();
    } else {
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
    getUserContacts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.only(
                    //       top: MediaQuery.of(context).size.height * 0.09,
                    //       bottom: MediaQuery.of(context).size.height * 0.01),
                    //   child: TextField(
                    //     controller: search,
                    //     onChanged: (value) {
                    //       updateContacts(value);
                    //       filter(updated);
                    //     },
                    //     decoration: InputDecoration(
                    //       labelText: "Search",
                    //       border: OutlineInputBorder(
                    //           borderSide: BorderSide(
                    //               color: Theme.of(context).primaryColor),
                    //           borderRadius:
                    //               const BorderRadius.all(Radius.circular(20))),
                    //       prefixIcon: Icon(
                    //         Icons.search,
                    //         color: Theme.of(context).primaryColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: getAllContacts,
                        child: ListView.builder(
                                itemBuilder: (context, int index) {
                                  Contact contact = contacts[index];
                                  return Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    color: Colors.green[100],
                                    margin: const EdgeInsets.all(10),
                                    child: ListTile(
                                      title: Text(contact.displayName),
                                      subtitle: Text(contact.phones.isNotEmpty
                                          ? contact.phones.first.number
                                          : "none"),
                                      leading: (contact.photo != null &&
                                              contact.photo!.isNotEmpty)
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(contact.photo!),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              child: Text(
                                                contact.displayName
                                                    .substring(0, 1),
                                              ),
                                            ),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Selected[index] == "true"
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          onPressed: () async {
                                            if (Selected[index] == "true") {
                                              contactsModel = ContactsModel(
                                                  FullName: widget.Name,
                                                  Contact_Name:
                                                      contact.displayName,
                                                  Contacts: contact
                                                      .phones.first.number);
                                              bool status =
                                                  await Database.insertContact(
                                                      contactsModel);
                                              if (status) {
                                                setState(() {
                                                  Selected[index] = "false";
                                                });
                                                Reusable.Success(
                                                    "Contact Added Successfully...",
                                                    context);
                                              } else {
                                                print("");
                                                Reusable.Failure(
                                                    "Error on Adding Contact",
                                                    context);
                                              }
                                            } else {
                                              bool status =
                                                  await Database.deleteContact(
                                                      contact
                                                          .phones.first.number,
                                                      contact.displayName);
                                              if (status) {
                                                setState(() {
                                                  Selected[index] = "true";
                                                });
                                                Reusable.Success(
                                                    "Contact Removed Successfully...",
                                                    context);
                                              } else {
                                                Reusable.Failure(
                                                    "Error on Removing Contact",
                                                    context);
                                              }
                                            }
                                          },
                                          child: Selected[index] == "true"
                                              ? const Text("ADD")
                                              : const Text("ADDED"),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: contacts.length,
                                shrinkWrap: true,
                              ),
                             // ListView.builder(
                             //    itemBuilder: (context, int index) {
                             //      Contact contact = updated[index];
                             //      if (updated.isEmpty) {
                             //        return const Center(
                             //          child: Text("No Contact"),
                             //        );
                             //      }
                             //      return Card(
                             //        shape: const RoundedRectangleBorder(
                             //            borderRadius: BorderRadius.all(
                             //                Radius.circular(20))),
                             //        color: Colors.green[100],
                             //        margin: const EdgeInsets.all(10),
                             //        child: ListTile(
                             //          title: Text(contact.displayName),
                             //          subtitle: Text(contact.phones.isNotEmpty
                             //              ? contact.phones.first.number
                             //              : "none"),
                             //          leading: (contact.photo != null &&
                             //                  contact.photo!.isNotEmpty)
                             //              ? CircleAvatar(
                             //                  backgroundImage:
                             //                      MemoryImage(contact.photo!),
                             //                )
                             //              : CircleAvatar(
                             //                  backgroundColor: Colors.blue,
                             //                  child: Text(
                             //                    contact.displayName
                             //                        .substring(0, 1),
                             //                  ),
                             //                ),
                             //          trailing: Container(
                             //            padding: const EdgeInsets.all(5),
                             //            child: ElevatedButton(
                             //              style: ElevatedButton.styleFrom(
                             //                primary: Updated[index] == "true"
                             //                    ? Colors.blue
                             //                    : Colors.grey,
                             //              ),
                             //              onPressed: () async {
                             //                if (Updated[index] == "true") {
                             //                  contactsModel = ContactsModel(
                             //                      FullName: widget.Name,
                             //                      Contact_Name:
                             //                          contact.displayName,
                             //                      Contacts: contact
                             //                          .phones.first.number);
                             //                  bool status =
                             //                      await Database.insertContact(
                             //                          contactsModel);
                             //                  if (status) {
                             //                    setState(() {
                             //                      Updated[index] = "false";
                             //                    });
                             //                    Reusable.Success(
                             //                        "Contact Added Successfully...",
                             //                        context);
                             //                  } else {
                             //                    print("");
                             //                    Reusable.Failure(
                             //                        "Error on Adding Contact",
                             //                        context);
                             //                  }
                             //                } else {
                             //                  bool status =
                             //                      await Database.deleteContact(
                             //                          contact
                             //                              .phones.first.number,
                             //                          contact.displayName);
                             //                  if (status) {
                             //                    setState(() {
                             //                      Updated[index] = "true";
                             //                    });
                             //                    Reusable.Success(
                             //                        "Contact Removed Successfully...",
                             //                        context);
                             //                  } else {
                             //                    Reusable.Failure(
                             //                        "Error on Removing Contact",
                             //                        context);
                             //                  }
                             //                }
                             //              },
                             //              child: Updated[index] == "true"
                             //                  ? const Text("ADD")
                             //                  : const Text("ADDED"),
                             //            ),
                             //          ),
                             //        ),
                             //      );
                             //    },
                             //    itemCount: updated.length,
                             //    shrinkWrap: true,
                             //  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
