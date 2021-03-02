import 'package:dartz/dartz.dart';
import 'package:dog_app/data/core/error/exceptions.dart';
import 'package:dog_app/data/core/network/network_info.dart';
import 'package:dog_app/data/datasources/dog_data_source.dart';
import 'package:dog_app/data/models/dog_model.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/dog.dart';
import 'package:meta/meta.dart';

class DogRepository {
  final DogDataSource dataSource;
  final NetworkInfo networkInfo;

  DogRepository({@required this.dataSource, @required this.networkInfo});

  Future<Either<Failure, List<Dog>>> getDogsByBreed(int breedId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getDogsByBreed(breedId);

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, Dog>> getRandomDog() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getRandomDog();

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
