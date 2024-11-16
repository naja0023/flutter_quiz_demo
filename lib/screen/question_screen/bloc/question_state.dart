part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends QuestionState {
  @override
  List<Object> get props => [];
}

class QuestionLoading extends QuestionState {
  @override
  List<Object> get props => [];
}

class QuestionLoaded extends QuestionState {
  @override
  List<Object> get props => [];
}

class QuestionError extends QuestionState {
  @override
  List<Object> get props => [];
}
