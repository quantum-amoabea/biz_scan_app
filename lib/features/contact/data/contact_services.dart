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

Future<void> saveToPhoneBook({
  String? name,
  String? phoneNumber,
  String? email,
}) async {
  final status = await FlutterContacts.permissions.request(
    PermissionType.readWrite,
  );
  if (status == PermissionStatus.granted) {
    final parts = (name ?? 'Contact').trim().split(RegExp(r'\s+'));

    final contactName = parts.isNotEmpty
        ? Name(
            first: parts.first,
            last: parts.length > 1 ? parts.sublist(1).join(' ') : '',
          )
        : const Name(first: 'Contact');

    final phones = phoneNumber != null && phoneNumber.isNotEmpty
        ? [Phone(label: Label(PhoneLabel.mobile), number: phoneNumber)]
        : <Phone>[];

    final emails = email != null && email.isNotEmpty
        ? [Email(address: email, label: Label(EmailLabel.work))]
        : <Email>[];

    final newContact = Contact(
      name: contactName,
      phones: phones,
      emails: emails,
    );

    try {
      await FlutterContacts.create(newContact);

      showToast(message: "Contact saved successfully");
    } catch (e) {
      showToast(message: "$e");
    }
  } else {
    showToast(message: "Could not save to phonebook");
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
