import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_creator/blocs/photo/search_event.dart';
import 'package:insta_creator/blocs/photo/search_state.dart';
import 'package:insta_creator/repository/photo_repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PhotoRepository repository = PhotoRepository();

  @override
  SearchState get initialState => SearchUninitialized();

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
    Stream<SearchEvent> events,
    TransitionFunction<SearchEvent, SearchState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 150)),
      transitionFn,
    );
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    dynamic currentState = state;
    if (event is ClearSearch) {
      yield SearchUninitialized();
    }
    if (event is SearchPhoto) {
      try {
        if (currentState is SearchUninitialized) {
          yield Searching();
          Map res = await repository.fetchSearchReasults(query: event.query);
          yield SearchResult(
            photos: res['photos'],
            totalResults: res['totalResults'],
            hasReachedMax: res['hasReachedMax'],
            nextPage: res['nextPage'],
          );
          return;
        }
        if (currentState is SearchResult) {
          if (event.continuePrevious) {
            if (currentState.hasReachedMax) {
              yield currentState.copyWith(
                photos: currentState.photos,
                nextPage: null,
                hasReachedMax: true,
                totalResults: 0,
              );
            } else {
              Map res = await repository.fetchSearchReasults(
                  url: currentState.nextPage.replaceAll(RegExp(r'%2F'), ""));
              yield SearchResult(
                photos: currentState.photos + res['photos'],
                totalResults: res['totalResults'],
                hasReachedMax: res['hasReachedMax'],
                nextPage: res['nextPage'],
              );
            }
          } else {
            yield Searching();
            Map res = await repository.fetchSearchReasults(query: event.query);
            yield SearchResult(
              photos: res['photos'],
              totalResults: res['totalResults'],
              hasReachedMax: res['hasReachedMax'],
              nextPage: res['nextPage'],
            );
          }
        }
      } catch (e) {
        yield SearchError(e.toString());
      }
    }
  }
}
