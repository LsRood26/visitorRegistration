class CustomRequests {
  final int id;
  final String datetime;
  final String photo;
  final String status;
  final String transportMode;
  final String residentDNI;
  final String visitorDNI;
  final String visitorName;
  final String visitorLastname;
  final String block;
  final String villa;

  CustomRequests(
      {required this.id,
      required this.datetime,
      required this.photo,
      required this.status,
      required this.transportMode,
      required this.residentDNI,
      required this.visitorDNI,
      required this.visitorName,
      required this.visitorLastname,
      required this.block,
      required this.villa});

  factory CustomRequests.fromMap(Map<String, dynamic> map) {
    return CustomRequests(
        id: map['request_entity_id'],
        datetime: map['request_entity_datetime'],
        photo: map['request_entity_photo'],
        status: map['request_entity_status'],
        transportMode: map['request_entity_transportMode'],
        residentDNI: map['resident_dni'],
        visitorDNI: map['visitor_dni'],
        visitorName: (map['visitor_name'] ?? ''),
        visitorLastname: map['visitor_lastname'] ?? '',
        block: map['block'] ?? '',
        villa: map['villa'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime,
      'photo': photo,
      'status': status,
      'transportMode': transportMode,
      'residentDNI': residentDNI,
      'visitorDNI': visitorDNI,
      'visitorName': visitorName,
      'visitorLastname': visitorLastname,
      'block': block,
      'villa': villa
    };
  }
}
