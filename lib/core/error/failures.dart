abstract class Failure {
  const Failure();
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);
}

class ConnectionFailure extends Failure {
  final String message;
  const ConnectionFailure(this.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();
}
