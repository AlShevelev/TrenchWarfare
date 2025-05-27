/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of card_controls;

class _CardsList extends StatelessWidget {
  final _CardsFactory _factory;

  final _TabCode _tabCode;

  const _CardsList({
    super.key,
    required _CardsFactory factory,
    required _TabCode tabCode,
  })  : _factory = factory,
        _tabCode = tabCode;

  @override
  Widget build(BuildContext context) {
    final List<_CardBase> allCards = _factory.getAllCards().toList(growable: false);

    return ListView.builder(
      key: PageStorageKey<String>(_tabCode.name),
      itemCount: allCards.length,
      itemBuilder: (context, index) => allCards[index],
    );
  }
}
