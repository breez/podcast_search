import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:podcast_search/podcast_search.dart';

const podcastSearchAgent =
    'podcast_search/0.4.0 https://github.com/amugofjava/anytime_podcast_player';

abstract class BaseSearch {
  /// Contains the type of error returning from the search. If no error occurred it
  /// will be set to [ErrorType.none].
  ErrorType lastErrorType = ErrorType.none;

  /// If an error occurs, this will contain a user-readable error message.
  String lastError;

  Future<SearchResult> search(
      {@required String term,
      Country country,
      Attribute attribute,
      Language language,
      int limit,
      int version = 0,
      bool explicit = false,
      Map<String, dynamic> queryParams});

  Future<SearchResult> charts();

  /// If an error occurs during an HTTP GET request this method is called to
  /// determine the error and set two variables which can then be included
  /// in the results. The client can then use these variables to determine
  /// if there was an issue or not.
  void setLastError(DioError e) {
    switch (e.type) {
      case DioErrorType.DEFAULT:
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        lastErrorType = ErrorType.connection;
        lastError = 'Connection timeout';
        break;
      case DioErrorType.RESPONSE:
        lastErrorType = ErrorType.failed;
        lastError = 'Server returned response error ${e.response?.statusCode}';
        break;
      case DioErrorType.CANCEL:
        lastErrorType = ErrorType.cancelled;
        lastError = 'Request was cancelled';
        break;
    }
  }
}
