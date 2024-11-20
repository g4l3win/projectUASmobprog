class QuestionEsai {
  final int? questionId;  // Make questionId nullable since it's auto-incremented
  final int quizId;
  final String content;
  final String answer;

  QuestionEsai({
    this.questionId,  // Optional questionId, auto-assigned from DB
    required this.quizId,
    required this.content,
    required this.answer,
  });

  // Convert a QuestionEsai object into a map object (for database)
  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'content': content,
      'answer': answer,
    };
  }

  // Convert a map object into a QuestionEsai object (from database)
  factory QuestionEsai.fromMap(Map<String, dynamic> map) {
    return QuestionEsai(
      questionId: map['question_id'],  // This will be assigned once inserted into DB
      quizId: map['quiz_id'],
      content: map['content'],
      answer: map['answer'],
    );
  }
}

