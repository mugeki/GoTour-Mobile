class Meta {
  final dynamic code;
  final dynamic message;

  const Meta({
    required this.code,
    required this.message,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      code: json['code'],
      message: json['message'],
    );
  }
}
