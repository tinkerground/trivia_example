import 'dart:async';

import 'dart:convert' as convert;

import 'package:frideos_core/frideos_core.dart';

import '../models/category.dart';
import '../models/question.dart';

import 'api_interface.dart';
import 'dart:math';
class MockAPI implements QuestionsAPI {
  @override
  Future<bool> getCategories(StreamedList<Category> categories) async {
    categories.value = [];

    categories.addElement(
      Category(id: 1, name: 'Addition'),
    );

    categories.addElement(
      Category(id: 2, name: 'Subtraction'),
    );

    categories.addElement(
      Category(id: 3, name: 'Multiplication'),
    );
    return true;
  }

  var question = "";
  var answer = "";
  var incorrectAnswers = [];

  @override
  Future<bool> getQuestions(
      {StreamedList<Question> questions,
      int number,
      Category category,
      QuestionDifficulty difficulty,
      QuestionType type}) async {

    var qdifficulty;
    var qtype;
    int randomNum = 0;
    int max = 10;
    switch (difficulty) {
      case QuestionDifficulty.easy:
        qdifficulty = 'easy';
        max = 20;
        break;
      case QuestionDifficulty.medium:
        qdifficulty = 'medium';
        max = 50;
        break;
      case QuestionDifficulty.hard:
        qdifficulty = 'hard';
        max = 100;
        break;
      default:
        qdifficulty = 'easy';
        break;
    }


    switch (type) {
      case QuestionType.boolean:
        qtype = 'boolean';
        break;
      case QuestionType.multiple:
        qtype = 'multiple';
        break;
      default:
        qtype = 'boolean';
        break;
    }

    var json =
        "{\"response_code\":0,\"results\":[";

    var total = 10;
    var counter = 0;

    for(int i=0; i < total; i++) {
      _generateQuestion(max, category, qdifficulty);

      json += "{\"category\":\"${category.name}\","
          "\"type\":\"$qtype\",\"difficulty\":\"$qdifficulty\","
          "\"question\":\"${question}\","
          "\"correct_answer\":\"${answer}\","
          "\"incorrect_answers\":"+incorrectAnswers.toString()+"}";

      if (counter < total-1) {
        json += ",";
      }

      counter++;
    }

    json += "]}";

    var jsonResponse = convert.jsonDecode(json);
    var result = (jsonResponse['results'] as List)
        .map(
            (question) => QuestionModel.fromJson(question)).toList();
    questions.value =
        result.map((question) => Question.fromQuestionModel(question)).toList();

    return true;
  }

  _generateQuestion(int max, Category category, String level) {
    var randomNum = Random().nextInt(max);
    if (randomNum < 1) {
      randomNum = 10;
    }
    switch(category.name.toLowerCase()) {
      case "addition":
        var num = randomNum + randomNum;
        if (num % 2 == 0) {
          var spoiler = num + Random().nextInt(10);
          if (randomNum + randomNum == spoiler) {
            spoiler++;
          }
          question = "$randomNum + $randomNum = $spoiler";
          answer = "false";
          incorrectAnswers = [true];
        } else {
          question = "$randomNum + $randomNum = $num";
          answer = "true";
          incorrectAnswers = [false];
        }

        break;

      case "subtraction":
        var right = randomNum - Random().nextInt(randomNum);
        var num = randomNum - right;
        if (num % 2 == 0) {
          var spoiler = num - Random().nextInt(10);
          if (randomNum - right == spoiler) {
            spoiler++;
          }
          question = "$randomNum - $right = $spoiler";
          answer = "false";
          incorrectAnswers = [true];
        } else {
          question = "$randomNum - $right = $num";
          answer = "true";
          incorrectAnswers = [false];
        }

        break;
      case "multiplication":
        var num = randomNum * randomNum;
        if (num % 2 == 0) {
          var spoiler = num * Random().nextInt(10);
          if (randomNum * randomNum == spoiler) {
            spoiler++;
          }
          question = "$randomNum X $randomNum = $spoiler";
          answer = "false";
          incorrectAnswers = [true];
        } else {
          question = "$randomNum X $randomNum = $num";
          answer = "true";
          incorrectAnswers = [false];
        }

        break;


    }
  }
}

class RequestModel {
  RequestModel({this.response_code, this.results});

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
        response_code: json['response_code'],
        results: (json['results'] as List));
  }

  Map<String, dynamic> toJson() => _RequestModelToJson(this);

  _RequestModelToJson(RequestModel instance) => <String, dynamic> {
    'response_code': instance.response_code,
    'results': instance.results
  };

  int response_code;
  List<QuizModel> results;
}

class QuizModel {
  QuizModel({this.category, this.type, this.difficulty,
    this.question, this.correctAnswer, this.incorrectAnswers});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
        category: json['category'],
        type: json['type'],
        difficulty: json['difficulty'],
        question: json['question'],
        correctAnswer: json['correct_answer'],
        incorrectAnswers: (json['incorrect_answers'] as List)
            .map((answer) => answer.toString())
            .toList());
  }

  Map<String, dynamic> toJson() => _QuizModelToJson(this);

  _QuizModelToJson(QuizModel instance) => <String, dynamic> {
    'category': instance.category,
    'type': instance.type,
    'difficulty': instance.difficulty,
    'question': instance.question,
    'correct_answer': instance.correctAnswer,
    'incorrect_answers': instance.incorrectAnswers
  };

  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;
}