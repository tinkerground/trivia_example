import 'package:json_annotation/json_annotation.dart';

enum QuestionDifficulty { easy, medium, hard }

enum QuestionType { boolean, multiple }

enum QuestionCategory {addition, subtraction, multiplication}

class QuestionModel {
  QuestionModel({this.question, this.correctAnswer, this.incorrectAnswers});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        question: json['question'],
        correctAnswer: json['correct_answer'],
        incorrectAnswers: (json['incorrect_answers'] as List)
            .map((answer) => answer.toString())
            .toList());
  }

  Map<String, dynamic> toJson() => _QuestionModelToJson(this);

  _QuestionModelToJson(QuestionModel instance) => <String, dynamic> {
    'question': instance.question,
    'correct_answer': instance.correctAnswer,
    'incorrect_answers': instance.incorrectAnswers
  };

  String question;
  String correctAnswer;
  List<String> incorrectAnswers;
}

class Question {
  Question({this.question, this.answers, this.correctAnswerIndex});

  factory Question.fromQuestionModel(QuestionModel model) {
    final List<String> answers = []
      ..add(model.correctAnswer)
      ..addAll(model.incorrectAnswers)
      ..shuffle();

    final index = answers.indexOf(model.correctAnswer);

    return Question(
        question: model.question, answers: answers, correctAnswerIndex: index);
  }



  String question;
  List<String> answers;
  int correctAnswerIndex;
  int chosenAnswerIndex;

  bool isCorrect(String answer) {
    return answers.indexOf(answer) == correctAnswerIndex;
  }

  bool isChosen(String answer) {
    return answers.indexOf(answer) == chosenAnswerIndex;
  }
}
