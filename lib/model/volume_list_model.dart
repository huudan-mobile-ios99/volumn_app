class VolumeListModel {
  final bool status;
  final String message;
  final List<Volume> data;
  VolumeListModel({
    required this.status,
    required this.message,
    required this.data,
  });
  factory VolumeListModel.fromJson(Map<String, dynamic> json) =>
      VolumeListModel(
        status: json["status"],
        message: json["message"],
        data: List<Volume>.from(json["data"].map((x) => Volume.fromJson(x))),
  );
}

class Volume {
  final String id;
  final String VolumeId;
  final String name;
  final String deviceName;
  final bool isSync;
  final String url;
  final DateTime createdAt;
  final double minValue;
  final double maxValue;
  final double currentValue;
  final String presetId;
  final int v;
  final int type;
  final double dx;
  final double dy;

  Volume({
    required this.id,
    required this.VolumeId,
    required this.name,
    required this.deviceName,
    required this.isSync,
    required this.url,
    required this.createdAt,
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.presetId,
    required this.v,
    required this.type,
    required this.dx,required this.dy
  });
  Volume copy() {
    return Volume(
      currentValue: currentValue,
      id: id,
      VolumeId: VolumeId,
      name: name,
      deviceName: deviceName,
      isSync: isSync,
      url: url,
      createdAt: createdAt,
      minValue: minValue,
      maxValue: maxValue,
      presetId: presetId,
      v: v,
      type: type,
      dx:dx,dy:dy
    );
  }

  // Define a copyWith method to create a new Volume instance with updated values
  Volume copyWith({
    String? id,
    String? VolumeId,
    String? name,
    String? deviceName,
    bool? isSync,
    String? url,
    DateTime? createdAt,
    double? minValue,
    double? maxValue,
    double? currentValue,
    String? presetId,
    int? v,
    int? type,
    double? dx,
    double? dy,
  }) {
    return Volume(
      id: id ?? this.id,
      VolumeId: VolumeId ?? this.VolumeId,
      name: name ?? this.name,
      deviceName: deviceName ?? this.deviceName,
      isSync: isSync ?? this.isSync,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      currentValue: currentValue ?? this.currentValue,
      presetId: presetId ?? this.presetId,
      v: v ?? this.v,
      type: type ?? this.type,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
    );
  }

  factory Volume.fromJson(Map<String, dynamic> json) => Volume(
        id: json["_id"] ?? 0,
        VolumeId: json["id"] ?? "default",
        name: json["name"] ?? 'name',
        deviceName: json["deviceName"] ?? "deviceName",
        isSync: json["isSync"] ?? false,
        url: json["url"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]) ?? DateTime.now(),
        minValue: json["minValue"]?.toDouble() ?? 0.0,
        maxValue: json["maxValue"]?.toDouble() ?? 0.0,
        currentValue: json["currentValue"]?.toDouble() ?? 0.0,
        presetId: json["presetId"] ?? "presetDefault",
        v: json["__v"] ?? "",
        type: json["type"] ?? 1,
        dx: json["dx"]?.toDouble() ?? 0.0,
        dy: json["dy"]?.toDouble() ?? 0.0,
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "id": VolumeId,
        "name": name,
        "deviceName": deviceName,
        "isSync": isSync,
        "url": url,
        "createdAt": createdAt.toIso8601String(),
        "minValue": minValue,
        "maxValue": maxValue,
        "currentValue": currentValue,
        "presetId": presetId,
        "__v": v,
        "type": type,
      };
}
