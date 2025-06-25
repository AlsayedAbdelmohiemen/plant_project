part of 'plants_cubit.dart';

@immutable
abstract class PlantsState {}

class PlantsInitial extends PlantsState {}

class PlantsLoading extends PlantsState {}

class PlantsLoaded extends PlantsState {
  final List<PlantsDetail> plants;
  PlantsLoaded(this.plants);
}

class PlantsError extends PlantsState {
  final String message;
  PlantsError(this.message);
}
