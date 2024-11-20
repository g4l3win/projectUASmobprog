class QuestionBenarSalah {
  final int? questionId;
  final int quizId;
  final String content;
  final String answer;

  QuestionBenarSalah({
    this.questionId,
    required this.quizId,
    required this.content,
    required this.answer,
  });

  // Convert a QuestionBenarSalah object into a map object (for database)
  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'quiz_id': quizId,
      'content': content,
      'answer': answer,
    };
  }

  // Convert a map object into a QuestionBenarSalah object (from database)
  factory QuestionBenarSalah.fromMap(Map<String, dynamic> map) {
    return QuestionBenarSalah(
      questionId: map['question_id'],
      quizId: map['quiz_id'],
      content: map['content'],
      answer: map['answer'],
    );
  }
}
