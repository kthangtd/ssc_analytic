part of analytic;

class TTMsgInfo {
  final int id;
  final Map data;
  final int level;

  TTMsgInfo({this.id, this.data, this.level});

  factory TTMsgInfo.from(Map m, int level) {
    if (m == null) {
      return null;
    }
    return TTMsgInfo(
      id: m['id'] ?? 0,
      data: jsonDecode(m['data']) ?? {},
      level: level,
    );
  }
}
