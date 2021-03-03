import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/dog.dart';
import 'package:dog_app/domain/repositories/dog_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'dogs_by_breed_event.dart';

part 'dogs_by_breed_state.dart';

class DogsByBreedBloc extends Bloc<DogsByBreedEvent, DogsByBreedState> {
  final DogRepository repository;

  DogsByBreedBloc({@required this.repository}) : super(Empty());

  @override
  Stream<DogsByBreedState> mapEventToState(
    DogsByBreedEvent event,
  ) async* {
    if (event is GetDogsByBreed) {
      yield Loading();
      final result = await repository.getDogsByBreed(event.breedId);

      yield* result.fold(
        (failure) async* {
          yield Error(message: mapFailureToMessage(failure));
        },
        (dogs) async* {
          yield Loaded(dogs: dogs);
        },
      );
    }
  }
}
