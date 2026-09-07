import 'package:biz_scan_app/core/toast_message.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> callNow(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    showToast(message: 'Could not launch phone dailer');
  }
}

Future<void> sendEmail(String email) async {
  final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    showToast(message: 'Could not launch email app');
  }
}

Future<void> sendSms(String phoneNumber) async {
  final Uri smsLaunchUri = Uri(scheme: 'sms', path: phoneNumber);

  if (await canLaunchUrl(smsLaunchUri)) {
    await launchUrl(smsLaunchUri);
  } else {
    showToast(message: 'Could not launch email app');
  }
}

Future<void> whatsApp(String phoneNumber) async {
  final Uri whatsappUri = Uri.https('wa.me', '/$phoneNumber');
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    showToast(message: 'Could not launch WhatsApp link');
  }
}

Future<void> saveToPhoneBook() async {
  final status = await FlutterContacts.permissions.request(
    PermissionType.readWrite,
  );
  if (status == PermissionStatus.granted) {
    final newContact = Contact(
      name: Name(first: 'Company', last: 'Support'),
      phones: [Phone(label: Label(PhoneLabel.work), number: '+1234567890')],
      emails: [
        Email(address: 'support@example.com', label: Label(EmailLabel.work)),
      ],
    );

    try {
      await FlutterContacts.create(newContact);

      showToast(message: "contact saved successfully");
    } catch (e) {
      showToast(message: "$e");
    }
  } else {
    showToast(message: "Could not save phonebook");
  }
}

bool isAlphabet(String char) {
  return RegExp(r'^[a-zA-Z]$').hasMatch(char);
}

String getContactInitials(String user) {
  String initials = '';
  List<String> list = user.trim().split(' ');

  for (String word in list) {
    if (word.isNotEmpty && isAlphabet(word[0])) {
      initials += word[0].toUpperCase();
    }
  }

  return initials;
}
