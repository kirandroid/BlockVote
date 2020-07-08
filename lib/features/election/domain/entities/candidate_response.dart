class CandidateResponse {
  String candidateId;
  String candidateName;
  String candidateImage;
  List<dynamic> voter;

  CandidateResponse(
      {this.candidateId, this.candidateName, this.candidateImage, this.voter});
  CandidateResponse.fromMap(List data)
      : candidateId = data.first[0],
        candidateName = data.first[1],
        candidateImage = data.first[2],
        voter = data.first[3];
}
