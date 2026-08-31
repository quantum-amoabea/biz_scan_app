class ErrorMessage {
  static const String requestCancelled =
      "Oops! It seems that the request to the server was cancelled. Please check your internet connection and try again";

  static const String connectionTimeout =
      "Sorry, we couldn't connect to the server. It seems that the connection timed out. Please check your internet connection and try again";
  static const String connectionError =
      "Sorry, we couldn't connect to the server. It seems that there was a connection error. Please check your internet connection and try again";
  
  static const String receieveTimeout =
      "We're sorry, but we didn't receive a response from the server in time. Please check your internet connection and try again";

  static const String sendTimeout =
      "We apologize, but we are unable to send your request to the server in time. Please check your internet connection and try again";

  static const String noInternet =
      'Please check your internet connection and try again';
  static const String unexpectedError = 'Unexpected error occurred';
}
