class MainScreenState {
  late MainScreenDateState mainScreenDateState;

  MainScreenState() {
    mainScreenDateState = MainScreenDateState("");
  }

  MainScreenState.empty();
}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenDateState extends MainScreenState {
  final String date;

  MainScreenDateState(this.date) : super.empty();
}