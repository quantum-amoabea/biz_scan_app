import '../models/contacts_details.dart';
import '../models/scanned_card_details.dart';

extension ScannedCardDetailsMapper on ScannedCardDetails {
  ContactDetails toContactDetails() {
    final contact = this.contact;

    return ContactDetails(
      id: contact?.id ?? '',
      fullName: contact?.fullName ?? '',
      jobTitle: contact?.jobTitle ?? '',
      company: contact?.company ?? '',
      industry: contact?.industry ?? '',

      phones: contact?.phones
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

      emails: contact?.emails
              ?.map(
                (email) => ContactEmail(
                  value: email.email ?? '',
                  type: email.type ?? '',
                ),
              )
              .toList() ??
          [],

      socials: contact?.socials
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