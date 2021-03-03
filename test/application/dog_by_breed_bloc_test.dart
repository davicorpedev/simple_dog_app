import 'package:dartz/dartz.dart';
import 'package:dog_app/application/dog/dogs_by_breed/dogs_by_breed_bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/dog.dart';
import 'package:dog_app/domain/repositories/dog_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDogRepository extends Mock implements DogRepository {}

void main() {
  MockDogRepository mockDogRepository;
  DogsByBreedBloc bloc;

  setUp(() {
    mockDogRepository = MockDogRepository();
    bloc = DogsByBreedBloc(repository: mockDogRepository);
  });

  test("initial state should be Empty", () {
    expect(bloc.state, Empty());
  });

  group("GetDogsByBreed", () {
    final tBreedId = 1;

    final tDogList = [
      Dog(
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
      ),
    ];

    test("should get the data from the repository", () async {
      when(mockDogRepository.getDogsByBreed(any))
          .thenAnswer((realInvocation) async => Right(tDogList));

      bloc.add(GetDogsByBreed(breedId: tBreedId));

      await untilCalled(mockDogRepository.getDogsByBreed(any));

      verify(mockDogRepository.getDogsByBreed(tBreedId));
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () {
      when(mockDogRepository.getDogsByBreed(any))
          .thenAnswer((realInvocation) async => Right(tDogList));

      final expected = [
        Loading(),
        Loaded(dogs: tDogList),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetDogsByBreed(breedId: tBreedId));
    });

    test("should emit [Loading, Error] with an error when the data fails", () {
      when(mockDogRepository.getDogsByBreed(any))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetDogsByBreed(breedId: tBreedId));
    });
  });
}
