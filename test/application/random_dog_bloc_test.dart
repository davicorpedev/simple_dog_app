import 'package:dartz/dartz.dart';
import 'package:dog_app/application/dog/random_dog/random_dog_bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/dog.dart';
import 'package:dog_app/domain/repositories/dog_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDogRepository extends Mock implements DogRepository {}

void main() {
  MockDogRepository mockDogRepository;
  RandomDogBloc bloc;

  setUp(() {
    mockDogRepository = MockDogRepository();
    bloc = RandomDogBloc(repository: mockDogRepository);
  });

  test("initial state should be Initial", () {
    expect(bloc.state, Initial());
  });

  group("GetRandomDog", () {
    final tDog = Dog(
      id: "test",
      url: "test",
      breeds: [
        DogBreed(
          id: 1,
          name: "test",
          temperament: "test",
          lifeSpan: "test",
          origin: "test",
        ),
      ],
    );

    test("should get the data from the repository", () async {
      when(mockDogRepository.getRandomDog())
          .thenAnswer((realInvocation) async => Right(tDog));

      bloc.add(GetRandomDog());

      await untilCalled(mockDogRepository.getRandomDog());

      verify(mockDogRepository.getRandomDog());
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () {
      when(mockDogRepository.getRandomDog())
          .thenAnswer((realInvocation) async => Right(tDog));

      final expected = [
        Initial(),
        Loading(),
        Loaded(dog: tDog),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetRandomDog());
    });

    test("should emit [Loading, Error] with an error when the data fails", () {
      when(mockDogRepository.getRandomDog())
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      final expected = [
        Initial(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetRandomDog());
    });
  });
}
