class ContactDetails {
  final String id;
  final String fullName;
  final String jobTitle;
  final String company;
  final String industry;
  final List<ContactPhone> phones;
  final List<ContactEmail> emails;
  final List<ContactAddress> addresses;
  final List<ContactSocial> socials;

  const ContactDetails({
    this.id = '',
    this.fullName = '',
    this.jobTitle = '',
    this.company = '',
    this.industry = '',
    this.phones = const [],
    this.emails = const [],
    this.addresses = const [],
    this.socials = const [],
  });

  String get website {
    for (final social in socials) {
      if (social.platform.toLowerCase() == 'website') {
        return social.url;
      }
    }

    return '';
  }
}

class ContactPhone {
  final String value;
  final String type;

  const ContactPhone({this.value = '', this.type = ''});
}

class ContactEmail {
  final String value;
  final String type;

  const ContactEmail({this.value = '', this.type = ''});
}

class ContactAddress {
  final String value;
  final String city;
  final String country;

  const ContactAddress({this.value = '', this.city = '', this.country = ''});
}

class ContactSocial {
  final String platform;
  final String handle;
  final String url;

  const ContactSocial({this.platform = '', this.handle = '', this.url = ''});
}
