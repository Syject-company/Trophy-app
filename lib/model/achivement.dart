import 'package:trophyapp/model/trophy.dart';
import 'package:trophyapp/model/user.dart';

class Achievement {
  Achievement({
    this.id,
    this.trophy,
    this.trophySerialNumber,
    this.medias,
    this.description,
    this.user,
    this.isVerified,
    this.userId,
    this.trophyId,
    this.decline,
    this.declineComent,
    this.declineCause,
  });

  final String id;
  final String userId;
  final String trophyId;
  final String trophySerialNumber;
  final bool decline;
  final String declineCause;
  final String declineComent;
  final Trophy trophy; // Referense to trophie
  final List<String> medias;
  final String description;
  final User user; // Referense to user
  final bool isVerified;

  factory Achievement.fromFirebase(Map<String, dynamic> data) {
    var mediasJson = data['medias'] as List;
    List<String> mediaList;
    if (mediasJson != null) {
      mediaList = mediasJson.cast<String>();
    }

    return Achievement(
        id: data['id'] as String,
        userId: data['userId'] as String,
        decline: data['decline'] as bool,
        declineCause: data['declineCause'] as String,
        declineComent: data['declineComent'] as String,
        trophyId: data['trophyId'] as String,
        trophySerialNumber: data['serial'] as String,
        isVerified: data['isVerified'] as bool,
        description: data['description'] as String,
        medias: mediaList);
  }

  Map<String, dynamic> toFirebase() => {
        'id': this.id,
        'userId': this.userId,
        'serial': this.trophySerialNumber,
        'trophy': this.trophy,
        'trophyId': this.trophyId,
        'medias': this.medias,
        'decline': this.decline,
        'declineCause': this.declineCause,
        'declineComent': this.declineComent,
        'description': this.description,
        'user': this.user,
        'isVerified': this.isVerified,
      };
}
