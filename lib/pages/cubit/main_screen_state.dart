import 'package:equatable/equatable.dart';

class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenDateState extends MainScreenState {
  final String date;

  const MainScreenDateState(this.date);

  @override
  List<Object?> get props => [];
}