class CandidateResponse {
  String candidateId;
  String candidateName;
  String candidateImage;

  CandidateResponse(
      {this.candidateId, this.candidateName, this.candidateImage});
  CandidateResponse.fromMap(List data)
      : candidateId = data.first[0],
        candidateName = data.first[1],
        candidateImage = data.first[2];
}
