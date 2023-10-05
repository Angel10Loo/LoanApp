import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'global_variable_state.dart';

class GlobalVariableCubit extends Cubit<GlobalVariableState> {
  GlobalVariableCubit() : super(GlobalVariableInitial());
}
