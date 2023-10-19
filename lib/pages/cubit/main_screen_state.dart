import 'package:equatable/equatable.dart';
import 'package:test_task_flutter/list_item.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenInitial extends MainScreenState {}

class MainScreenLoading extends MainScreenState {}

class MainScreenLoaded extends MainScreenState {}