import 'package:dribbble_challenge/infra/http/http_adapter.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

class ClientMock extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientMock client;
  String url;
  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group('Method post', () {
    PostExpectation mockRequest() => when(
        client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));
    void mockResponse(int statusCode,
            {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));
    void mockError() => mockRequest().thenThrow(Exception());
    setUp(() {
      mockResponse(200);
    });
    test('Should throw ServerError if method passed is invalid ', () {
      final future = sut.request(url: url, method: 'invalid');
      expect(future, throwsA(HttpError.serverError));
    });
    test('Should return null if post returns 200 without data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'post');

      expect(response, null);
    });
    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');

      expect(response, {'any_key': 'any_value'});
    });
    test('Should return null if post returns 204', () async {
      mockResponse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });
    test('Should return HttpError if post returns 400', () {
      mockResponse(400);
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.badRequest));
    });
    test('Should return UnauthorizedError if post returns 401', () {
      mockResponse(401);
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.unauthorized));
    });
    test('Should return ForbiddenError if post returns 403', () {
      mockResponse(403);
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.forbidden));
    });
    test('Should return NotFoundError if post returns 404', () {
      mockResponse(404);
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.notFound));
    });
    test('Should return ServerError if post returns 500', () {
      mockResponse(500);
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.serverError));
    });
    test('Should return ServerError if post throws', () {
      mockError();
      final futureResponse = sut.request(url: url, method: 'post');
      expect(futureResponse, throwsA(HttpError.serverError));
    });
  });
  group('Method get', () {
    PostExpectation mockRequest() =>
        when(client.get(any, headers: anyNamed('headers')));

    void mockResponse(int statusCode,
            {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });
    test('Should return data if get returns 200', () async {
      final response = await sut.request(url: url, method: 'get');

      expect(response, {'any_key': 'any_value'});
    });
    test('Should return null if get returns 200 without data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });
    test('Should return null if get returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: 'get');

      expect(response, null);
    });
    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));
    });
    test('Should return UnauthorizedError if get returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));
    });
    test('Should return ForbiddenError if get returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbidden));
    });
    test('Should return NotFoundError if get returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));
    });
    test('Should return ServerError if get returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
