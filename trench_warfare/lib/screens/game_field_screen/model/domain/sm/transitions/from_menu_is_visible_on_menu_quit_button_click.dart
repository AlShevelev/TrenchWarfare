part of game_field_sm;

class FromMenuIsVisibleOnMenuQuitButtonClick {

  State process() {
    // Make autosave here

    return GameIsOver();
  }
}
