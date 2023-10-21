
class cmdmodel {
  cmdmodel({
      this.page, 
      this.records, 
      this.rows,});

  cmdmodel.fromJson(dynamic json) {
    page = json['page'];
    records = json['records'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows?.add(Rows.fromJson(v));
      });
    }
  }
  num? page;
  num? records;
  List<Rows>? rows;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['records'] = records;
    if (rows != null) {
      map['rows'] = rows?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Rows {
  Rows({
    this.id,
    this.cell,});

  Rows.fromJson(dynamic json) {
    id = json['id'];
    cell = json['cell'] != null ? json['cell'].cast<String>() : [];
  }
  String? id;
  List<String>? cell;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cell'] = cell;
    return map;
  }

}