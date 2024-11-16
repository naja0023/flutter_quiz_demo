part of 'question_bloc.dart';

abstract class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class OnSubmitAnswer extends QuestionEvent {
  @override
  List<Object> get props => [];
}

class OnReqQuestion extends QuestionEvent {
  @override
  List<Object> get props => [];
}