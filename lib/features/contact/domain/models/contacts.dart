class Contacts {
  List<Items>? items;
  int? total;
  int? page;
  int? size;
  int? pages;

  Contacts({this.items, this.total, this.page, this.size, this.pages});

  Contacts.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    size = json['size'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['size'] = this.size;
    data['pages'] = this.pages;
    return data;
  }
}

class Items {
  String? id;
  String? cardId;
  String? fullName;
  String? namePrefix;
  String? givenName;
  String? familyName;
  String? nameSuffix;
  String? jobTitle;
  String? department;
  String? company;
  String? notes;
  String? industryCode;
  bool? needsReview;
  List<String>? reviewReasons;
  String? createdAt;
  String? updatedAt;
  List<Phones>? phones;
  List<Emails>? emails;
  List<Addresses>? addresses;
  List<Socials>? socials;
  List<Actions>? actions;
  SharedBy? sharedBy;
  CardImages? cardImages;
  String? sourceContactId;
  String? industry;

  Items(
      {this.id,
      this.cardId,
      this.fullName,
      this.namePrefix,
      this.givenName,
      this.familyName,
      this.nameSuffix,
      this.jobTitle,
      this.department,
      this.company,
      this.notes,
      this.industryCode,
      this.needsReview,
      this.reviewReasons,
      this.createdAt,
      this.updatedAt,
      this.phones,
      this.emails,
      this.addresses,
      this.socials,
      this.actions,
      this.sharedBy,
      this.cardImages,
      this.sourceContactId,
      this.industry});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardId = json['card_id'];
    fullName = json['full_name'];
    namePrefix = json['name_prefix'];
    givenName = json['given_name'];
    familyName = json['family_name'];
    nameSuffix = json['name_suffix'];
    jobTitle = json['job_title'];
    department = json['department'];
    company = json['company'];
    notes = json['notes'];
    industryCode = json['industry_code'];
    needsReview = json['needs_review'];
    reviewReasons = json['review_reasons'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['phones'] != null) {
      phones = <Phones>[];
      json['phones'].forEach((v) {
        phones!.add(new Phones.fromJson(v));
      });
    }
    if (json['emails'] != null) {
      emails = <Emails>[];
      json['emails'].forEach((v) {
        emails!.add(new Emails.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
    if (json['socials'] != null) {
      socials = <Socials>[];
      json['socials'].forEach((v) {
        socials!.add(new Socials.fromJson(v));
      });
    }
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
    sharedBy = json['shared_by'] != null
        ? new SharedBy.fromJson(json['shared_by'])
        : null;
    cardImages = json['card_images'] != null
        ? new CardImages.fromJson(json['card_images'])
        : null;
    sourceContactId = json['source_contact_id'];
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['card_id'] = this.cardId;
    data['full_name'] = this.fullName;
    data['name_prefix'] = this.namePrefix;
    data['given_name'] = this.givenName;
    data['family_name'] = this.familyName;
    data['name_suffix'] = this.nameSuffix;
    data['job_title'] = this.jobTitle;
    data['department'] = this.department;
    data['company'] = this.company;
    data['notes'] = this.notes;
    data['industry_code'] = this.industryCode;
    data['needs_review'] = this.needsReview;
    data['review_reasons'] = this.reviewReasons;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.phones != null) {
      data['phones'] = this.phones!.map((v) => v.toJson()).toList();
    }
    if (this.emails != null) {
      data['emails'] = this.emails!.map((v) => v.toJson()).toList();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    if (this.socials != null) {
      data['socials'] = this.socials!.map((v) => v.toJson()).toList();
    }
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    if (this.sharedBy != null) {
      data['shared_by'] = this.sharedBy!.toJson();
    }
    if (this.cardImages != null) {
      data['card_images'] = this.cardImages!.toJson();
    }
    data['source_contact_id'] = this.sourceContactId;
    data['industry'] = this.industry;
    return data;
  }
}

class Phones {
  String? e164;
  String? parsedRegion;
  String? regionSource;
  String? id;
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
      this.id,
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
    id = json['id'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e164'] = this.e164;
    data['parsed_region'] = this.parsedRegion;
    data['region_source'] = this.regionSource;
    data['id'] = this.id;
    data['raw'] = this.raw;
    data['display'] = this.display;
    data['type'] = this.type;
    data['is_primary'] = this.isPrimary;
    data['calling_code'] = this.callingCode;
    data['dial_prefix'] = this.dialPrefix;
    data['needs_region'] = this.needsRegion;
    data['region_note'] = this.regionNote;
    return data;
  }
}

class Emails {
  String? id;
  String? email;
  String? type;
  bool? isPrimary;

  Emails({this.id, this.email, this.type, this.isPrimary});

  Emails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    type = json['type'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['type'] = this.type;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class Addresses {
  String? id;
  String? raw;
  String? city;
  String? country;
  bool? isPrimary;

  Addresses({this.id, this.raw, this.city, this.country, this.isPrimary});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    raw = json['raw'];
    city = json['city'];
    country = json['country'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['raw'] = this.raw;
    data['city'] = this.city;
    data['country'] = this.country;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class Socials {
  String? id;
  String? platform;
  String? handle;
  String? url;
  bool? isPrimary;

  Socials({this.id, this.platform, this.handle, this.url, this.isPrimary});

  Socials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    platform = json['platform'];
    handle = json['handle'];
    url = json['url'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['label'] = this.label;
    data['uri'] = this.uri;
    data['value'] = this.value;
    data['display'] = this.display;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}

class SharedBy {
  String? userId;
  String? username;
  String? displayName;

  SharedBy({this.userId, this.username, this.displayName});

  SharedBy.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['display_name'] = displayName;
    return data;
  }
}

class CardImages {
  String? front;
  String? back;

  CardImages({this.front, this.back});

  CardImages.fromJson(Map<String, dynamic> json) {
    front = json['front'];
    back = json['back'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['front'] = front;
    data['back'] = back;
    return data;
  }
}