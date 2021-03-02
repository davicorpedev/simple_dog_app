import 'package:dartz/dartz.dart';
import 'package:dog_app/data/core/error/exceptions.dart';
import 'package:dog_app/data/core/network/network_info.dart';
import 'package:dog_app/data/datasources/breed_data_source.dart';
import 'package:dog_app/domain/core/error/failures.dart';
import 'package:dog_app/domain/entities/breed.dart';
import 'package:meta/meta.dart';

class BreedRepository {
  final BreedDataSource dataSource;
  final NetworkInfo networkInfo;

  BreedRepository({@required this.dataSource, @required this.networkInfo});

  Future<Either<Failure, List<Breed>>> getBreeds() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await dataSource.getBreeds();

        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
