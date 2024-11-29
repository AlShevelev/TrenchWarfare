import 'package:flutter/foundation.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

abstract class DaoBase {
  @protected
  List<T> read<T>(QueryBuilder<T> queryBuilder) {
    final query = queryBuilder.build();
    final result = query.find();
    query.close();

    return result;
  }

  T? readFirst<T>(QueryBuilder<T> queryBuilder) {
    final query = queryBuilder.build();
    final result = query.findFirst();
    query.close();

    return result;
  }

  void remove<T>(QueryBuilder<T> queryBuilder) {
    final query = queryBuilder.build();
    query.remove();
    query.close();
  }

  void put<T>(Box<T> box, T entity) => box.putAsync(entity, mode: PutMode.insert);
}