import '../model/plants.dart';
import '../web_service/plants_web_service.dart';

class PlantsRepository {
  final PlantWebServices plantsWebServices;

  PlantsRepository(this.plantsWebServices);

  Future<List<PlantsDetail>> getAllPlants() async {
    try {
      return await plantsWebServices.getAllPlants();
    } catch (e) {
      print('Error in PlantsRepository getAllPlants: ${e.toString()}');
      return [];
    }
  }
}
