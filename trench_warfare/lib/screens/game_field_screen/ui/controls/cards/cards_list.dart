part of card_controls;

class CardsList extends StatefulWidget {
  late final CardsFactory _factory;

  late final OnCardClick _onCardSelected;

  CardsList({super.key, required CardsFactory factory, required OnCardClick onCardSelected}) {
    _factory = factory;
    _onCardSelected = onCardSelected;
  }

  @override
  State<StatefulWidget> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget._factory.startSelectedIndex;
    widget._onCardSelected(_selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<CardBase> allCards = [];

    allCards.addAll(
        widget._factory.getAllCards((index) {
          if (_selectedIndex != -1) {
            allCards[_selectedIndex].updateSelection(false);
          }

          _selectedIndex = index;
          allCards[_selectedIndex].updateSelection(true);
          widget._onCardSelected(index);
        })
    );

    return ListView(
      children: allCards,
    );
  }
}
