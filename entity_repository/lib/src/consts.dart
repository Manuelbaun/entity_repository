part of entity_repository;

/// dao locator instance singelton
final _RepositoryLocator repositoryLocator = _RepositoryLocator();

class CustomAdapterTypes {
  static const int objectReference = 0;
  static const int indexAdapter = 1;
  static const int setAdapter = 2;
}
