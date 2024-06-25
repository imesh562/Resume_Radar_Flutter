import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_event.dart';
import 'base_state.dart';

abstract class Base<T extends BaseEvent, K extends BaseState>
    extends Bloc<T, K> {
  Base(K initialState) : super(initialState);
}
