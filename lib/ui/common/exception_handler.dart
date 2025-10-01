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
}
