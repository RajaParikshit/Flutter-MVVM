import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// Network Util Class -> A utility class for handling network operations
class NetworkUtil {
  //----------------------------------------------------------- Singleton-Instance ------------------------------------------------------------------
  // Singleton Instance
  static NetworkUtil _instance = new NetworkUtil.internal();

  /// NetworkUtil Private Constructor -> NetworkUtil
  /// @param -> _
  /// @usage -> Returns the instance of NetworkUtil class
  NetworkUtil.internal();

  /// NetworkUtil Factory Constructor -> NetworkUtil
  /// @dependency -> _
  /// @usage -> Returens the instance of NetworkUtil class
  factory NetworkUtil() => _instance;

  //------------------------------------------------------------- Variables ---------------------------------------------------------------------------
  // JsonDecoder object
  final JsonDecoder _decoder = new JsonDecoder();

  //------------------------------------------------------------- Methods -----------------------------------------------------------------------------
  /// Get Method -> Future<dynamic>
  /// @param -> @required url -> String
  /// @usage -> Make HTTP-GET request to specified URL and returns the response in JSON format
  Future<dynamic> get({@required String url}) =>
      http.get(url) // Make HTTP-GET request
          .then((http.Response response) { // On response received
            // Get response status code
            final int statusCode = response.statusCode;

            // Check response status code for error condition
            if (statusCode < 200 || statusCode > 400 || json == null) { // Error occurred
              throw new Exception("Error while fetching data");
            }else{ // No error occurred
              // Get response body
              final String res = response.body;
              // Convert response body to JSON object
              return _decoder.convert(res);
            }

      });

  /// Post Method -> Future<dynamic>
  /// @param -> @required url -> String
  ///        -> headers -> Map
  ///        -> body -> dynamic
  ///        -> encoding -> dynamic
  ///  @usage -> Make HTTP-POST request to specified URL and returns the response in JSON format
  Future<dynamic> post({@required String url,Map headers, body, encoding}) =>
      http.post(url, body: body, headers: headers, encoding: encoding) // Make HTTP-POST request
          .then((http.Response response) { // On response received
            // Get response status code
            final int statusCode = response.statusCode;

            // Check response status code for error condition
            if (statusCode < 200 || statusCode > 400 || json == null) { // Error occurred
              throw new Exception("Error while fetching data");
            }else{ // No error occurred
              // Get response body
              final String res = response.body;
              // Convert response body to JSON object
              return _decoder.convert(res);
            }

      });
}