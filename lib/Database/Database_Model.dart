class UserModel {
  final String FullName;
  final String Mobile;
  final String? Message;

  const UserModel({required this.FullName, required this.Mobile, this.Message});

  Map<String, dynamic> toJson() => {
        "NAME": FullName,
        "MOBILE": Mobile,
        "MESSAGE": Message,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        FullName: json['NAME'],
        Mobile: json['MOBILE'],
        Message: json['MESSAGE']);
  }
}

class ContactsModel {
  final String? FullName;
  final String? Contact_Name;
  final String? Contacts;

  const ContactsModel({required this.FullName, required this.Contact_Name, required this.Contacts});

  Map<String, dynamic> toJson() => {
        "USER": FullName,
    "CONTACTNAME": Contact_Name,
        "CONTACT": Contacts,
      };

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(FullName: json['NAME'], Contact_Name: json['CONTACTNAME'], Contacts: json['CONTACT']);
  }
}
