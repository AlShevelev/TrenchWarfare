part of streams;

class BroadcastStream<T> extends SimpleStream<T> {
  @override
  StreamController<T> getStreamController() => StreamController<T>.broadcast();
}