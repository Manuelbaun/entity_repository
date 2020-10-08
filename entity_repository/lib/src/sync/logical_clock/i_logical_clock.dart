abstract class ILogicalClock<T> implements Comparable<T> {
  int get logicalTime;
  final int counter;

  external factory ILogicalClock.send(ILogicalClock lc);
  external factory ILogicalClock.recv(
      ILogicalClock local, ILogicalClock remote);
  external factory ILogicalClock.parse(String ts);
  external factory ILogicalClock.fromLogicalTimestamp(int ts);

  /// radix time from [minutes] in Case of [HLC] implementation
  /// otherwise from [logicalTime]
  String radixTime(int radix);

  @override
  bool operator ==(other);
  bool operator <(other);
  bool operator <=(other);
  bool operator >(other);
  bool operator >=(other);
  int operator -(other);
}
