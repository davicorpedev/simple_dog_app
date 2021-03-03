import 'package:dartz/dartz.dart';
import 'package:dog_app/application/download_image/download_image_cubit.dart';
import 'package:dog_app/application/download_image/download_image_state.dart';
import 'package:dog_app/domain/repositories/url_downloader_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUrlDownloaderRepository extends Mock
    implements UrlDownloaderRepository {}

void main() {
  MockUrlDownloaderRepository mockUrlDownloaderRepository;
  DownloadImageCubit cubit;

  setUp(() {
    mockUrlDownloaderRepository = MockUrlDownloaderRepository();
    cubit = DownloadImageCubit(repository: mockUrlDownloaderRepository);
  });

  test("initial state should be Initial", () {
    expect(cubit.state, Initial());
  });

  group("download", () {
    test("should get image from url", () async {
      when(mockUrlDownloaderRepository.download(any))
          .thenAnswer((realInvocation) async => Right(true));

      await mockUrlDownloaderRepository.download("url");

      await untilCalled(mockUrlDownloaderRepository.download(any));

      verify(mockUrlDownloaderRepository.download("url"));
    });

    test(
        "should emit [Loading, Loaded] when the image is downloaded successfully",
        () {
      when(mockUrlDownloaderRepository.download(any))
          .thenAnswer((realInvocation) async => Right(true));

      final expected = [
        Loading(),
        Loaded(),
      ];

      expectLater(cubit, emitsInOrder(expected));

      cubit.downloadImage("url");
    });

    test("should emit [Loading, Error] when the image is NOT downloaded", () {
      when(mockUrlDownloaderRepository.download(any))
          .thenAnswer((realInvocation) async => Left(InvalidUrlDownloader()));

      final expected = [
        Loading(),
        Error(),
      ];

      expectLater(cubit, emitsInOrder(expected));

      cubit.downloadImage("url");
    });
  });
}
