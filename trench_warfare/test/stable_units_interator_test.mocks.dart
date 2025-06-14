// Mocks generated by Mockito 5.4.4 from annotations
// in trench_warfare/test/stable_units_interator_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flame/extensions.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart'
    as _i2;
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart'
    as _i4;
import 'package:trench_warfare/core/enums/nation.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGameFieldCell_0 extends _i1.SmartFake implements _i2.GameFieldCell {
  _FakeGameFieldCell_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GameFieldRead].
///
/// See the documentation for Mockito's code generation for more information.
class MockGameFieldRead extends _i1.Mock implements _i2.GameFieldRead {
  MockGameFieldRead() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get rows => (super.noSuchMethod(
        Invocation.getter(#rows),
        returnValue: 0,
      ) as int);

  @override
  int get cols => (super.noSuchMethod(
        Invocation.getter(#cols),
        returnValue: 0,
      ) as int);

  @override
  Iterable<_i2.GameFieldCell> get cells => (super.noSuchMethod(
        Invocation.getter(#cells),
        returnValue: <_i2.GameFieldCell>[],
      ) as Iterable<_i2.GameFieldCell>);

  @override
  _i2.GameFieldCell getCell(
    int? row,
    int? col,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCell,
          [
            row,
            col,
          ],
        ),
        returnValue: _FakeGameFieldCell_0(
          this,
          Invocation.method(
            #getCell,
            [
              row,
              col,
            ],
          ),
        ),
      ) as _i2.GameFieldCell);

  @override
  _i2.GameFieldCell getCellById(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getCellById,
          [id],
        ),
        returnValue: _FakeGameFieldCell_0(
          this,
          Invocation.method(
            #getCellById,
            [id],
          ),
        ),
      ) as _i2.GameFieldCell);

  @override
  int getCellIndex(
    int? row,
    int? col,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCellIndex,
          [
            row,
            col,
          ],
        ),
        returnValue: 0,
      ) as int);

  @override
  Iterable<_i2.GameFieldCell?> findAllCellsAround(
          _i2.GameFieldCellRead? centralCell) =>
      (super.noSuchMethod(
        Invocation.method(
          #findAllCellsAround,
          [centralCell],
        ),
        returnValue: <_i2.GameFieldCell?>[],
      ) as Iterable<_i2.GameFieldCell?>);

  @override
  Iterable<_i2.GameFieldCell> findCellsAround(
          _i2.GameFieldCellRead? centralCell) =>
      (super.noSuchMethod(
        Invocation.method(
          #findCellsAround,
          [centralCell],
        ),
        returnValue: <_i2.GameFieldCell>[],
      ) as Iterable<_i2.GameFieldCell>);

  @override
  Iterable<_i2.GameFieldCell> findCellsAroundR(
    _i2.GameFieldCellRead? centralCell, {
    required int? radius,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #findCellsAroundR,
          [centralCell],
          {#radius: radius},
        ),
        returnValue: <_i2.GameFieldCell>[],
      ) as Iterable<_i2.GameFieldCell>);

  @override
  _i2.GameFieldCell findCellByPosition(_i3.Vector2? position) =>
      (super.noSuchMethod(
        Invocation.method(
          #findCellByPosition,
          [position],
        ),
        returnValue: _FakeGameFieldCell_0(
          this,
          Invocation.method(
            #findCellByPosition,
            [position],
          ),
        ),
      ) as _i2.GameFieldCell);

  @override
  _i2.GameFieldCell? findCellById(int? cellId) =>
      (super.noSuchMethod(Invocation.method(
        #findCellById,
        [cellId],
      )) as _i2.GameFieldCell?);

  @override
  double calculateDistance(
    _i2.GameFieldCellRead? cell1,
    _i2.GameFieldCellRead? cell2,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #calculateDistance,
          [
            cell1,
            cell2,
          ],
        ),
        returnValue: 0.0,
      ) as double);

  @override
  _i2.GameFieldCellRead? getCellWithUnit(
    _i4.Unit? unit,
    _i5.Nation? nation,
  ) =>
      (super.noSuchMethod(Invocation.method(
        #getCellWithUnit,
        [
          unit,
          nation,
        ],
      )) as _i2.GameFieldCellRead?);

  @override
  _i4.Unit? findUnitById(
    String? unitId,
    _i5.Nation? nation,
  ) =>
      (super.noSuchMethod(Invocation.method(
        #findUnitById,
        [
          unitId,
          nation,
        ],
      )) as _i4.Unit?);
}
