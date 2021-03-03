import 'package:dartz/dartz.dart';
import 'package:dog_app/application/breed/breed_bloc.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/breed.dart';
import 'package:dog_app/domain/repositories/breed_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBreedRepository extends Mock implements BreedRepository {}

void main() {
  MockBreedRepository mockBreedRepository;
  BreedBloc bloc;

  setUp(() {
    mockBreedRepository = MockBreedRepository();
    bloc = BreedBloc(repository: mockBreedRepository);
  });

  test("initial state should be Empty", () {
    expect(bloc.state, Empty());
  });

  group("GetBreeds", () {
    final tBreedList = [
      Breed(
        image: "test",
        id: 1,
        name: "test",
        temperament: "test",
        lifeSpan: "test",
        origin: "test",
      ),
    ];

    test("should get the data from the repository", () async {
      when(mockBreedRepository.getBreeds())
          .thenAnswer((realInvocation) async => Right(tBreedList));

      bloc.add(GetBreeds());

      await untilCalled(mockBreedRepository.getBreeds());

      verify(mockBreedRepository.getBreeds());
    });

    test("should emit [Loading, Loaded] when data is gotten successfully", () {
      when(mockBreedRepository.getBreeds())
          .thenAnswer((realInvocation) async => Right(tBreedList));

      final expected = [
        Loading(),
        Loaded(breeds: tBreedList),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetBreeds());
    });

    test("should emit [Loading, Error] with an error when the data fails", () {
      when(mockBreedRepository.getBreeds())
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];

      expectLater(bloc, emitsInOrder(expected));

      bloc.add(GetBreeds());
    });
  });
}
