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
        items!.add(Items.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    size = json['size'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['size'] = size;
    data['pages'] = pages;
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
  String? createdAt;
  String? updatedAt;
  List<Phones>? phones;
  List<Emails>? emails;
  List<Addresses>? addresses;
  List<Socials>? socials;
  List<Actions>? actions;
  SharedBy? sharedBy;
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
      this.createdAt,
      this.updatedAt,
      this.phones,
      this.emails,
      this.addresses,
      this.socials,
      this.actions,
      this.sharedBy,
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    sharedBy = json['shared_by'] != null
        ?  SharedBy.fromJson(json['shared_by'])
        : null;
    sourceContactId = json['source_contact_id'];
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['card_id'] = cardId;
    data['full_name'] = fullName;
    data['name_prefix'] = namePrefix;
    data['given_name'] = givenName;
    data['family_name'] = familyName;
    data['name_suffix'] = nameSuffix;
    data['job_title'] = jobTitle;
    data['department'] = department;
    data['company'] = company;
    data['notes'] = notes;
    data['industry_code'] = industryCode;
    data['needs_review'] = needsReview;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    if (sharedBy != null) {
      data['shared_by'] = sharedBy!.toJson();
    }
    data['source_contact_id'] = sourceContactId;
    data['industry'] = industry;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['e164'] = e164;
    data['parsed_region'] = parsedRegion;
    data['region_source'] = regionSource;
    data['id'] = id;
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
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['raw'] = raw;
    data['city'] = city;
    data['country'] = country;
    data['is_primary'] = isPrimary;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['platform'] = platform;
    data['handle'] = handle;
    data['url'] = url;
    data['is_primary'] = isPrimary;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['kind'] = kind;
    data['label'] = label;
    data['uri'] = uri;
    data['value'] = value;
    data['display'] = display;
    data['is_primary'] = isPrimary;
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
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['display_name'] = displayName;
    return data;
  }
}