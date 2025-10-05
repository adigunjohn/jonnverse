import 'dart:developer';

class ExceptionHandler {
  static String checkStatusCode(int statusCode) {
    String message = 'no message yet';
    if (statusCode >= 100 && statusCode < 200) {
      message =
      'Informational Response: The request was received and understood.';
    } else if (statusCode >= 200 && statusCode < 300) {
      switch (statusCode) {
        case 200:
          message = 'Success: The request was successful.';
          break;
        case 201:
          message =
          'Created: The request was successful and a resource was created.';
          break;
        case 202:
          message = 'Accepted: The request has been accepted for processing.';
          break;
        case 204:
          message =
          'No Content: The request was successful but there is no content.';
          break;
        default:
          message =
          'Success: The request was successful with status code $statusCode.';
      }
    } else if (statusCode >= 300 && statusCode < 400) {
      switch (statusCode) {
        case 301:
          message =
          'Moved Permanently: The resource has been permanently moved.';
          break;
        case 302:
          message = 'Found: The resource is temporarily located elsewhere.';
          break;
        case 304:
          message =
          'Not Modified: The cached version of the resource is still valid.';
          break;
        default:
          message =
          'Redirection: The request requires further action with status code $statusCode.';
      }
    } else if (statusCode >= 400 && statusCode < 500) {
      switch (statusCode) {
        case 400:
          message = 'Bad Request: The request is invalid or malformed.';
          break;
        case 401:
          message = 'Unauthorized: Authentication is required or has failed.';
          break;
        case 403:
          message =
          'Forbidden: You do not have permission to access this resource.';
          break;
        case 404:
          message = 'Not Found: The requested resource does not exist.';
          break;
        case 409:
          message =
          'Conflict: The request conflicts with the current state of the resource.';
          break;
        case 415:
          message = 'Unsupported Media Type.';
          break;
        case 422:
          message =
          'Unprocessable Entity: The server cannot process the request.';
          break;
        default:
          message =
          'Client Error: An error occurred with status code $statusCode.';
      }
    } else if (statusCode >= 500 && statusCode < 600) {
      switch (statusCode) {
        case 500:
          message =
          'Internal Server Error: The server encountered an unexpected condition.';
          break;
        case 501:
          message =
          'Not Implemented: The server does not support the requested functionality.';
          break;
        case 502:
          message = 'Bad Gateway.';
          break;
        case 503:
          message =
          'Service Unavailable: The server is not ready to handle the request.';
          break;
        case 504:
          message = 'Gateway Timeout.';
          break;
        default:
          message =
          'Server Error: An error occurred with status code $statusCode.';
      }
    } else {
      message = 'Unknown Status Code: $statusCode.';
    }

    log(message);
    return message;
  }


  ///Firebase Related Exceptions
  //FirebaseAuthException
 static String getSignInErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'wrong-password':
      case 'user-not-found':
      // Due to email enumeration protection, these are now grouped together
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later or reset your password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      default:
        return 'Sign in failed. Please check your credentials and try again.';
    }
  }

  //FirebaseAuthException
  static String getSignUpErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'An account with this email already exists. Please try signing in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return 'Account creation failed. Please try again.';
    }
  }

  //FirebaseException
  static String getGeneralAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email using a different sign-in method. Please try signing in with your original method.';
      case 'invalid-credential':
        return 'Authentication failed. Please try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found. Please check your credentials or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please try again.';
      case 'invalid-verification-id':
        return 'Invalid verification ID. Please restart the process.';
      case 'code-expired':
        return 'Verification code has expired. Please request a new one.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'app-not-authorized':
        return 'App not authorized. Please contact support.';
      case 'invalid-api-key':
        return 'Configuration error. Please contact support.';
      case 'requires-recent-login':
        return 'Please sign in again to continue.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
