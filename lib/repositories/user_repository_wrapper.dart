import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:parkourspotkorea/interfaces/scratch_map_interface.dart';
import 'package:parkourspotkorea/repositories/user_repository.dart';

class UserRepositoryWrapper implements IUserRepository {
  final UserRepository _userRepository;

  UserRepositoryWrapper({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<String?> getCurrentUserId() async{
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Future<LatLng> getInitialCameraPosition() async {
    return await _userRepository.getInitialCameraPosition();
  }

  @override
  Future<List<String>> getVisitedRegions(String uid) async{
return await _userRepository.getVisitedRegions(uid);
  }

  @override
  Future<void> visitRegion(String uid, String regionId) async{
    await _userRepository.visitRegion(uid, regionId);
  }
}
