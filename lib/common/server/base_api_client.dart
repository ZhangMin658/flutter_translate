import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

abstract class BaseApiClient {
  //respose respose for use then
  Future<http.Response> getResponse(Uri uri) async {
    final response = await http.get(uri);
    return response;
  }

  Future<http.Response> postResponse(
      {Uri uri,
      Map<String, String> headers: const {
        HttpHeaders.contentTypeHeader: "application/json"
      },
      Map dataBody,
      Encoding encoding: utf8}) async {
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);
    final response = await ioClient.post(uri,
        body: json.encode(dataBody), headers: headers, encoding: encoding);
    ioClient.close();
    return response;
  }

  //convert json
  Future<dynamic> getJson(Uri uri) async {
    var response = await http.get(uri);
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
      case HttpStatus.accepted:
        {
          //For response success
          var transformedResponse = response.body;
          return json.decode(transformedResponse);
        }
        break;
      case HttpStatus.badRequest:
      case HttpStatus.forbidden:
      case HttpStatus.notFound:
        {
          //for respoce errors
          return null;
        }
        break;
      default:
        return null;
        break;
    }
  }

  Future<dynamic> postJson(Uri uri,
      {Map<String, String> headers: const {
        HttpHeaders.contentTypeHeader: "application/json"
      },
      Map dataBody,
      Encoding encoding: utf8}) async {
    final response = await http.Client().post(uri,
        body: json.encode(dataBody), headers: headers, encoding: encoding);

    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
      case HttpStatus.accepted:
        {
          //For response success
          var transformedResponse = response.body;
          return json.decode(transformedResponse);
        }
        break;
      case HttpStatus.badRequest:
      case HttpStatus.forbidden:
      case HttpStatus.notFound:
        {
          //for respoce errors
          return null;
        }
        break;
      default:
        return null;
        break;
    }
  }
}
