class AppException implements Exception {
  String title;
  String msg;

  AppException({required this.title, required this.msg});

  @override
  String toString() {
    return "$title: $msg";
  }
}

class NoInternetException extends AppException {
  NoInternetException({
    required String exceptionMsg,
  }) : super(title: "No Internet", msg: exceptionMsg);
}


class FetchDataException extends AppException {
  FetchDataException({
    required String exceptionMsg,
  }) : super(title: "Fetch Data Exception", msg: exceptionMsg);
}

class BadRequestException extends AppException {
  BadRequestException({
    required String exceptionMsg,
  }) : super(title: "Bad Request Exception", msg: exceptionMsg);
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException({
    required String exceptionMsg,
  }) : super(title: "UnAuthorised Exception", msg: exceptionMsg);
}

class InvalidInputException extends AppException {
  InvalidInputException({
    required String exceptionTitle,
    required String exceptionMsg,
  }) : super(title: "Invalid Input Exception", msg: exceptionMsg);
}

class SomethingWentWrongException extends AppException{
  SomethingWentWrongException({
    required String exceptionTitle,
    required String exceptionMsg,
  }) : super(title: "Something Went Wrong Exception", msg: exceptionMsg);
}

class ServerException extends AppException{
  ServerException({
    required String exceptionMsg,
  }) : super(title: "Server Exception", msg: exceptionMsg);
}