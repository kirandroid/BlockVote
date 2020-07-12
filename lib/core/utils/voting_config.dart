import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/features/election/domain/entities/election_response.dart';

class VotingConfig {
  ElectionStatus checkVotingStatus({ElectionResponse electionResponse}) {
    DateTime now = DateTime.now();
    DateTime today =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(electionResponse.startDate.toString()));
    DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(electionResponse.endDate.toString()));

    DateTime parsedStartDate = DateTime(startDate.year, startDate.month,
        startDate.day, startDate.hour, startDate.minute);
    DateTime parsedEndDate = DateTime(
        endDate.year, endDate.month, endDate.day, endDate.hour, endDate.minute);

    if (electionResponse.isActive && today.isBefore(parsedStartDate)) {
      return ElectionStatus(
          status: "ACTIVE",
          statusColor: UIColors.primaryDarkTeal,
          reason: "Voter can Join.",
          shouldWarn: false);
    } else if (!electionResponse.isActive || today.isAfter(parsedEndDate)) {
      return ElectionStatus(
          status: "INACTIVE",
          statusColor: UIColors.primaryRed,
          reason:
              "This election is expired or close. You cannot join but view the result.",
          shouldWarn: true);
    } else if (electionResponse.isActive &&
        today.isBefore(parsedEndDate) &&
        today.isAfter(parsedStartDate)) {
      return ElectionStatus(
          status: "VOTING",
          statusColor: UIColors.primaryGreen,
          reason:
              "This election is running. You can view the ongoing result but cannot join.",
          shouldWarn: true);
    } else {
      return ElectionStatus(
          status: "INACTIVE",
          statusColor: UIColors.primaryRed,
          reason:
              "This election is expired or close. You cannot join but view the result.",
          shouldWarn: true);
    }
  }
}
