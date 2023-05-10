import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'place_state.dart';

class PlaceCubit extends Cubit<PlaceState> {
  PlaceCubit() : super(PlaceInitial());
}
