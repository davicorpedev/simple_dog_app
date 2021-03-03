import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/dog.dart';
import 'package:dog_app/domain/repositories/dog_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'random_dog_event.dart';

part 'random_dog_state.dart';

class RandomDogBloc extends Bloc<RandomDogEvent, RandomDogState> {
  final DogRepository repository;

  RandomDogBloc({@required this.repository}) : super(Initial());

  @override
  Stream<RandomDogState> mapEventToState(
    RandomDogEvent event,
  ) async* {
    if (event is GetRandomDog) {
      yield Loading();
      final result = await repository.getRandomDog();

      yield* result.fold(
        (failure) async* {
          yield Error(message: mapFailureToMessage(failure));
        },
        (dog) async* {
          yield Loaded(dog: dog);
        },
      );
    }
  }
}
