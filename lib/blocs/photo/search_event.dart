abstract class SearchEvent {}

class SearchPhoto extends SearchEvent {
  final String query;
  bool continuePrevious = false;
  SearchPhoto({this.query, this.continuePrevious});
}

class LoadRecentSearches extends SearchEvent {}

class ClearSearch extends SearchEvent {}
