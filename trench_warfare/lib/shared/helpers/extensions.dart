extension ComponMethods<T> on T? {
  R? let<R>(R Function(T) action) {
    if (this == null) {
      return null;
    }

    return action(this as T);
  }
}
