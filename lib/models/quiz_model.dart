class Quiz {
  int? quizId;
  String? title;
  String? subject;
  String? type;
  int? timer;

  Quiz({this.quizId, this.title, this.subject, this.type, this.timer});

  // Convert Quiz object to a map
  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'title': title,
      'subject': subject,
      'type': type,
      'timer': timer,
    };
  }

  // Convert a map to a Quiz object
  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizId: map['quiz_id'],
      title: map['title'],
      subject: map['subject'],
      type: map['type'],
      timer: map['timer'],
    );
  }
}

