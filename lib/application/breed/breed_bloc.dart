import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/breed.dart';
import 'package:dog_app/domain/repositories/breed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'breed_event.dart';
part 'breed_state.dart';

class BreedBloc extends Bloc<BreedEvent, BreedState> {
  final BreedRepository repository;

  BreedBloc({this.repository}) : super(Empty());

  @override
  Stream<BreedState> mapEventToState(
    BreedEvent event,
  ) async* {
    if (event is GetBreeds) {
      yield Loading();
      final result = await repository.getBreeds();

      yield* result.fold(
        (failure) async* {
          yield Error(message: mapFailureToMessage(failure));
        },
        (breeds) async* {
          yield Loaded(breeds: breeds);
        },
      );
    }
  }
}
