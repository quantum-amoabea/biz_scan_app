class ScannedCardDetails {
  String? id;
  String? status;
  String? errorCode;
  String? businessRegion;
  String? createdAt;
  String? completedAt;
  Contact? contact;

  ScannedCardDetails(
      {this.id,
      this.status,
      this.errorCode,
      this.businessRegion,
      this.createdAt,
      this.completedAt,
      this.contact});

  ScannedCardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    errorCode = json['error_code'];
    businessRegion = json['business_region'];
    createdAt = json['created_at'];
    completedAt = json['completed_at'];
    contact =
        json['contact'] != null ?  Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['error_code'] = errorCode;
    data['business_region'] = businessRegion;
    data['created_at'] = createdAt;
    data['completed_at'] = completedAt;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}

class Contact {
  String? id;
  String? fullName;
  String? jobTitle;
  String? department;
  String? company;
  String? industryCode;
  bool? needsReview;
  List<Phones>? phones;
  List<Emails>? emails;
  List<Addresses>? addresses;
  List<Socials>? socials;
  List<Actions>? actions;
  String? industry;

  Contact(
      {this.id,
      this.fullName,
      this.jobTitle,
      this.department,
      this.company,
      this.industryCode,
      this.needsReview,
      this.phones,
      this.emails,
      this.addresses,
      this.socials,
      this.actions,
      this.industry});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    jobTitle = json['job_title'];
    department = json['department'];
    company = json['company'];
    industryCode = json['industry_code'];
    needsReview = json['needs_review'];
    if (json['phones'] != null) {
      phones = <Phones>[];
      json['phones'].forEach((v) {
        phones!.add( Phones.fromJson(v));
      });
    }
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add( Emails.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add( Addresses.fromJson(v));
      });
    }
    if (json['socials'] != null) {
      socials = <Socials>[];
      json['socials'].forEach((v) {
        socials!.add( Socials.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add( Actions.fromJson(v));
      });
    }
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['job_title'] = jobTitle;
    data['department'] = department;
    data['company'] = company;
    data['industry_code'] = industryCode;
    data['needs_review'] = needsReview;
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    if (emails != null) {
      data['emails'] = emails!.map((v) => v.toJson()).toList();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (socials != null) {
      data['socials'] = socials!.map((v) => v.toJson()).toList();
    }
    if (actions != null) {
      data['actions'] = actions!.map((v) => v.toJson()).toList();
    }
    data['industry'] = industry;
    return data;
  }
}

class Phones {
  String? e164;
  String? parsedRegion;
  String? regionSource;
  String? raw;
  String? display;
  String? type;
  bool? isPrimary;
  int? callingCode;
  String? dialPrefix;
  bool? needsRegion;
  String? regionNote;

  Phones(
      {this.e164,
      this.parsedRegion,
      this.regionSource,
      this.raw,
      this.display,
      this.type,
      this.isPrimary,
      this.callingCode,
      this.dialPrefix,
      this.needsRegion,
      this.regionNote});

  Phones.fromJson(Map<String, dynamic> json) {
    e164 = json['e164'];
    parsedRegion = json['parsed_region'];
    regionSource = json['region_source'];
    raw = json['raw'];
    display = json['display'];
    type = json['type'];
    isPrimary = json['is_primary'];
    callingCode = json['calling_code'];
    dialPrefix = json['dial_prefix'];
    needsRegion = json['needs_region'];
    regionNote = json['region_note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['e164'] = e164;
    data['parsed_region'] = parsedRegion;
    data['region_source'] = regionSource;
    data['raw'] = raw;
    data['display'] = display;
    data['type'] = type;
    data['is_primary'] = isPrimary;
    data['calling_code'] = callingCode;
    data['dial_prefix'] = dialPrefix;
    data['needs_region'] = needsRegion;
    data['region_note'] = regionNote;
    return data;
  }
}

class Emails {
  String? email;
  String? type;
  bool? isPrimary;

  Emails({this.email, this.type, this.isPrimary});

  Emails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    type = json['type'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['email'] = this.email;
    data['type'] = this.type;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class Addresses {
  String? raw;
  String? street;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  bool? isPrimary;

  Addresses(
      {this.raw,
      this.street,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.isPrimary});

  Addresses.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    country = json['country'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['raw'] = this.raw;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class Socials {
  String? platform;
  String? handle;
  String? url;
  bool? isPrimary;

  Socials({this.platform, this.handle, this.url, this.isPrimary});

  Socials.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    handle = json['handle'];
    url = json['url'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['platform'] = this.platform;
    data['handle'] = this.handle;
    data['url'] = this.url;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class Actions {
  String? kind;
  String? label;
  String? uri;
  String? value;
  String? display;
  bool? isPrimary;

  Actions(
      {this.kind,
      this.label,
      this.uri,
      this.value,
      this.display,
      this.isPrimary});

  Actions.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    label = json['label'];
    uri = json['uri'];
    value = json['value'];
    display = json['display'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['kind'] = this.kind;
    data['label'] = this.label;
    data['uri'] = this.uri;
    data['value'] = this.value;
    data['display'] = this.display;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}