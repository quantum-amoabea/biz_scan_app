import '../features/contact/domain/models/contacts.dart';
import '../features/contact/domain/models/contacts_details.dart';

extension ItemsMapper on Items {
  ContactDetails toContactDetails() {
    return ContactDetails(
      id: id ?? '',
      fullName: fullName ?? '',
      jobTitle: jobTitle ?? '',
      company: company ?? '',
      industry: industry ?? '',
      phones: phones
              ?.map(
                (phone) => ContactPhone(
                  value: phone.display ??
                      phone.e164 ??
                      phone.raw ??
                      '',
                  type: phone.type ?? '',
                ),
              )
              .toList() ??
          [],
      emails: emails
              ?.map(
                (email) => ContactEmail(
                  value: email.email ?? '',
                  type: email.type ?? '',
                ),
              )
              .toList() ??
          [],
      addresses: addresses
              ?.map(
                (address) => ContactAddress(
                  value: address.raw ?? '',
                  city: address.city ?? '',
                  country: address.country ?? '',
                ),
              )
              .toList() ??
          [],
      socials: socials
              ?.map(
                (social) => ContactSocial(
                  platform: social.platform ?? '',
                  handle: social.handle ?? '',
                  url: social.url ?? '',
                ),
              )
              .toList() ??
          [],
    );
  }
}