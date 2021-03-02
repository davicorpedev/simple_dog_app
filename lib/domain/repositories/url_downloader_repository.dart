import 'file:///C:/Users/davic/Desktop/workSpaceFlutter/refactor_dog_app/lib/domain/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

class UrlDownloaderRepository {
  Future<Either<Failure, bool>> download(String url) async {
    try {
      await ImageDownloader.downloadImage(url);

      return Right(true);
    } on PlatformException {
      return Left(InvalidUrlDownloader());
    }
  }
}

class InvalidUrlDownloader extends Failure {}
