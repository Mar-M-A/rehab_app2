class SessionInfo {
  final int id;
  final DateTime start;
  final DateTime end;

  SessionInfo({required this.id, required this.start, required this.end});

  Duration get duration => end.difference(start);
}