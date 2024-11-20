class Question {
  final int? questionId;
  final int quiz_id;
  final String content;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String answer;

  Question({
    this.questionId,
    required this.quiz_id,
    required this.content,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quiz_id,
      'content': content,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'answer': answer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['question_id'],
      quiz_id: map['quiz_id'],
      content: map['content'],
      optionA: map['option_a'],
      optionB: map['option_b'],
      optionC: map['option_c'],
      optionD: map['option_d'],
      answer: map['answer'],
    );
  }
}
