part of 'place_cubit.dart';

@immutable
abstract class PlaceState {}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final TwoLists twolist;

  PlaceLoaded({required this.twolist});
}

class PlaceLoadFailure extends PlaceState {
  final String error;

  PlaceLoadFailure({required this.error});
}

class PlaceAdding extends PlaceState {}

class PlaceAdded extends PlaceState {}

class PlaceAddFailure extends PlaceState {
  final String error;

  PlaceAddFailure({required this.error});
}

class PlaceDeleting extends PlaceState {}

class PlaceDeleted extends PlaceState {}

class PlaceDeletingFailure extends PlaceState {
  final String error;

  PlaceDeletingFailure({required this.error});
}
