import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/model/plants.dart';
import '../../data/repository/plants_repository.dart';

part 'plants_state.dart';

class PlantsCubit extends Cubit<PlantsState> {
  final PlantsRepository plantsRepository;

  PlantsCubit(this.plantsRepository) : super(PlantsInitial());

  void fetchPlants() async {
    try {
      emit(PlantsLoading()); // Emit loading state
      final plants = await plantsRepository.getAllPlants();
      emit(PlantsLoaded(plants)); // Emit loaded state with data
    } catch (e) {
      emit(PlantsError("Failed to fetch plants: ${e.toString()}"));
    }
  }
}
