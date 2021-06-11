abstract class BaseRepository {
  //call request server
  //have result response -> to update database
  //return database readed

  Future<List<dynamic>> requestData();
}
