// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/api/users/[id]/status.dart' as api_users_$id_status;
import '../routes/api/users/[id]/history.dart' as api_users_$id_history;
import '../routes/api/users/[id]/delete_account/index.dart' as api_users_$id_delete_account_index;
import '../routes/api/users/[id]/attempts/[attemptId].dart' as api_users_$id_attempts_$attempt_id;
import '../routes/api/speech/generate.dart' as api_speech_generate;
import '../routes/api/speech/evaluate.dart' as api_speech_evaluate;
import '../routes/api/reminders/index.dart' as api_reminders_index;
import '../routes/api/reminders/[userId]/index.dart' as api_reminders_$user_id_index;
import '../routes/api/reminders/[userId]/[reminderId].dart' as api_reminders_$user_id_$reminder_id;
import '../routes/api/quick_word_game/user/[userId]/index.dart' as api_quick_word_game_user_$user_id_index;
import '../routes/api/quick_word_game/user/[userId]/[resultId].dart' as api_quick_word_game_user_$user_id_$result_id;
import '../routes/api/quick_word_game/save_result/index.dart' as api_quick_word_game_save_result_index;
import '../routes/api/quick_word_game/generate_word/index.dart' as api_quick_word_game_generate_word_index;
import '../routes/api/quick_word_game/evaluate_pronunciation/index.dart' as api_quick_word_game_evaluate_pronunciation_index;
import '../routes/api/questionnaires/save.dart' as api_questionnaires_save;
import '../routes/api/questionnaires/analyze.dart' as api_questionnaires_analyze;
import '../routes/api/feedback/send_feedback/index.dart' as api_feedback_send_feedback_index;
import '../routes/api/exercises/sounds.dart' as api_exercises_sounds;
import '../routes/api/exercises/record_attempt.dart' as api_exercises_record_attempt;
import '../routes/api/exercises/evaluate.dart' as api_exercises_evaluate;
import '../routes/api/daily_words/save_attempt/index.dart' as api_daily_words_save_attempt_index;
import '../routes/api/daily_words/history/[userId]/index.dart' as api_daily_words_history_$user_id_index;
import '../routes/api/daily_words/generate_word/index.dart' as api_daily_words_generate_word_index;
import '../routes/api/daily_words/evaluate_pronunciation/index.dart' as api_daily_words_evaluate_pronunciation_index;
import '../routes/api/auth/register.dart' as api_auth_register;
import '../routes/api/auth/login.dart' as api_auth_login;
import '../routes/api/assistant/ask.dart' as api_assistant_ask;

import '../routes/_middleware.dart' as middleware;
import '../routes/api/users/[id]/_middleware.dart' as api_users_$id_middleware;
import '../routes/api/questionnaires/_middleware.dart' as api_questionnaires_middleware;
import '../routes/api/daily_words/_middleware.dart' as api_daily_words_middleware;
import '../routes/api/auth/_middleware.dart' as api_auth_middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/api/assistant', (context) => buildApiAssistantHandler()(context))
    ..mount('/api/auth', (context) => buildApiAuthHandler()(context))
    ..mount('/api/daily_words/evaluate_pronunciation', (context) => buildApiDailyWordsEvaluatePronunciationHandler()(context))
    ..mount('/api/daily_words/generate_word', (context) => buildApiDailyWordsGenerateWordHandler()(context))
    ..mount('/api/daily_words/history/<userId>', (context,userId,) => buildApiDailyWordsHistory$userIdHandler(userId,)(context))
    ..mount('/api/daily_words/save_attempt', (context) => buildApiDailyWordsSaveAttemptHandler()(context))
    ..mount('/api/exercises', (context) => buildApiExercisesHandler()(context))
    ..mount('/api/feedback/send_feedback', (context) => buildApiFeedbackSendFeedbackHandler()(context))
    ..mount('/api/questionnaires', (context) => buildApiQuestionnairesHandler()(context))
    ..mount('/api/quick_word_game/evaluate_pronunciation', (context) => buildApiQuickWordGameEvaluatePronunciationHandler()(context))
    ..mount('/api/quick_word_game/generate_word', (context) => buildApiQuickWordGameGenerateWordHandler()(context))
    ..mount('/api/quick_word_game/save_result', (context) => buildApiQuickWordGameSaveResultHandler()(context))
    ..mount('/api/quick_word_game/user/<userId>', (context,userId,) => buildApiQuickWordGameUser$userIdHandler(userId,)(context))
    ..mount('/api/reminders/<userId>', (context,userId,) => buildApiReminders$userIdHandler(userId,)(context))
    ..mount('/api/reminders', (context) => buildApiRemindersHandler()(context))
    ..mount('/api/speech', (context) => buildApiSpeechHandler()(context))
    ..mount('/api/users/<id>/attempts', (context,id,) => buildApiUsers$idAttemptsHandler(id,)(context))
    ..mount('/api/users/<id>/delete_account', (context,id,) => buildApiUsers$idDeleteAccountHandler(id,)(context))
    ..mount('/api/users/<id>', (context,id,) => buildApiUsers$idHandler(id,)(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildApiAssistantHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/ask', (context) => api_assistant_ask.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiAuthHandler() {
  final pipeline = const Pipeline().addMiddleware(api_auth_middleware.middleware);
  final router = Router()
    ..all('/register', (context) => api_auth_register.onRequest(context,))..all('/login', (context) => api_auth_login.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiDailyWordsEvaluatePronunciationHandler() {
  final pipeline = const Pipeline().addMiddleware(api_daily_words_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_daily_words_evaluate_pronunciation_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiDailyWordsGenerateWordHandler() {
  final pipeline = const Pipeline().addMiddleware(api_daily_words_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_daily_words_generate_word_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiDailyWordsHistory$userIdHandler(String userId,) {
  final pipeline = const Pipeline().addMiddleware(api_daily_words_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_daily_words_history_$user_id_index.onRequest(context,userId,));
  return pipeline.addHandler(router);
}

Handler buildApiDailyWordsSaveAttemptHandler() {
  final pipeline = const Pipeline().addMiddleware(api_daily_words_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_daily_words_save_attempt_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiExercisesHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/sounds', (context) => api_exercises_sounds.onRequest(context,))..all('/record_attempt', (context) => api_exercises_record_attempt.onRequest(context,))..all('/evaluate', (context) => api_exercises_evaluate.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiFeedbackSendFeedbackHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_feedback_send_feedback_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiQuestionnairesHandler() {
  final pipeline = const Pipeline().addMiddleware(api_questionnaires_middleware.middleware);
  final router = Router()
    ..all('/save', (context) => api_questionnaires_save.onRequest(context,))..all('/analyze', (context) => api_questionnaires_analyze.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiQuickWordGameEvaluatePronunciationHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_quick_word_game_evaluate_pronunciation_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiQuickWordGameGenerateWordHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_quick_word_game_generate_word_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiQuickWordGameSaveResultHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_quick_word_game_save_result_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiQuickWordGameUser$userIdHandler(String userId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_quick_word_game_user_$user_id_index.onRequest(context,userId,))..all('/<resultId>', (context,resultId,) => api_quick_word_game_user_$user_id_$result_id.onRequest(context,userId,resultId,));
  return pipeline.addHandler(router);
}

Handler buildApiReminders$userIdHandler(String userId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_reminders_$user_id_index.onRequest(context,userId,))..all('/<reminderId>', (context,reminderId,) => api_reminders_$user_id_$reminder_id.onRequest(context,userId,reminderId,));
  return pipeline.addHandler(router);
}

Handler buildApiRemindersHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_reminders_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiSpeechHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/generate', (context) => api_speech_generate.onRequest(context,))..all('/evaluate', (context) => api_speech_evaluate.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildApiUsers$idAttemptsHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_users_$id_middleware.middleware);
  final router = Router()
    ..all('/<attemptId>', (context,attemptId,) => api_users_$id_attempts_$attempt_id.onRequest(context,id,attemptId,));
  return pipeline.addHandler(router);
}

Handler buildApiUsers$idDeleteAccountHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_users_$id_middleware.middleware);
  final router = Router()
    ..all('/', (context) => api_users_$id_delete_account_index.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildApiUsers$idHandler(String id,) {
  final pipeline = const Pipeline().addMiddleware(api_users_$id_middleware.middleware);
  final router = Router()
    ..all('/status', (context) => api_users_$id_status.onRequest(context,id,))..all('/history', (context) => api_users_$id_history.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

