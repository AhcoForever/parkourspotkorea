import 'package:parkourspotkorea/services/drift/drift_map_service.dart';

import '../database/app_database.dart';

class ScratchMapRepository{
  DriftMapService driftMapService;
  ScratchMapRepository({required this.driftMapService});

  Future<List<PolygonRow>> getPolygonsBySggPrefix(int sggPrefix) async{
    return await driftMapService.getPolygonsBySggPrefix(sggPrefix);
  }
}