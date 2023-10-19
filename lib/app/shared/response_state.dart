// ignore_for_file: constant_identifier_names

enum Status { NON, LOADING, SUCCESS, ERROR }

class ResponseState {
  final Status? status;
  final String? message;
  final dynamic data;

  ResponseState({this.status, this.message, this.data});
}
