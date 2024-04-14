part of card_controls;

class CardsList extends StatefulWidget {
  late final CardsFactory _factory;

  CardsList({super.key, required CardsFactory factory}) {
    _factory = factory;
  }

  @override
  State<StatefulWidget> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<CardBase> allCards = [];

    allCards.addAll(
      widget._factory.getAllCards((index) {
        allCards[selectedIndex].updateSelection(false);
        selectedIndex = index;
        allCards[selectedIndex].updateSelection(true);
      })
    );

    return ListView(
      children: allCards,
    );
  }
}