part of streams;

class SingleStream<T> extends SimpleStream<T> {
  @override
  StreamController<T> getStreamController() => StreamController<T>();
}