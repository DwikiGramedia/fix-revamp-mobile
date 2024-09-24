// Generated; built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-04-03 06:09:28
// @modify date 2022-04-03 06:09:28
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-04-03 06:09:28

class OrganizationData {
  int id = 0;
  String appName = '';
  String organizationName = '';
  String logoUrl = '';
  String libraryType = '';
  String profileHref = '';

  List<OrganizationsCatalog> organizationsCatalog = <OrganizationsCatalog>[];

  int maximumUserAllowed = 0;

  bool isManager = false;
  bool isParentOrganization = false;
}

class OrganizationsCatalog {
  int id = 0;
  String title = '';
  String href = '';
}

class OrganizationUser {
  OrganizationUser();

  factory OrganizationUser.fromJson(json) {
    return OrganizationUser();
  }
}
