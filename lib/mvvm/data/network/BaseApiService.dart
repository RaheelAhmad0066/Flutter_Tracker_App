abstract class BaseApiService {

  Future<dynamic> getGetApiResponse(String url);
  Future<dynamic> getpostApiResponse(String url,dynamic data);
}