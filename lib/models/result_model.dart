class Result {
  final int? resultId;
  final int quizId;
  final int userId;
  final double score;

  Result(
      {this.resultId,
      required this.quizId,
      required this.userId,
      required this.score});

  Map<String, dynamic> toMap() {
    return {
      'result_id': resultId,
      'quiz_id': quizId,
      'user_id': userId,
      'score': score,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      resultId: map['result_id'],
      quizId: map['quiz_id'],
      userId: map['user_id'],
      score: map['score'],
    );
  }
}
