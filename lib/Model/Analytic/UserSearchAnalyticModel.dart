class UserSearchAnalytic {
  String queryText;
  int userId;
  String ipAddress;
  String deviceId;
  String dateTime;
  int queryResult;
  String queryFacets;

  UserSearchAnalytic(
      {required this.userId,
      required this.deviceId,
      required this.dateTime,
      required this.ipAddress,
      required this.queryFacets,
      required this.queryResult,
      required this.queryText});
}
