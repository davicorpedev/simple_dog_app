import 'file:///C:/Users/davic/Desktop/workSpaceFlutter/refactor_dog_app/lib/application/download_image/download_image_cubit.dart';
import 'file:///C:/Users/davic/Desktop/workSpaceFlutter/refactor_dog_app/lib/domain/repositories/url_downloader_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUrlDownloader extends Mock implements UrlDownloader {}

void main() {
  MockUrlDownloader mockUrlDownloader;
  DownloadImageCubit cubit;

  setUp(() {
    mockUrlDownloader = MockUrlDownloader();
    cubit = DownloadImageCubit(downloader: mockUrlDownloader);
  });

  test("initial state should be Initial", () {
    expect(cubit.state, Initial());
  });

  group("download", () {
    test("should get image from url", () async {
      when(mockUrlDownloader.download(any))
          .thenAnswer((realInvocation) async => Right(true));

      await mockUrlDownloader.download("url");

      await untilCalled(mockUrlDownloader.download(any));

      verify(mockUrlDownloader.download("url"));
    });

    test(
        "should emit [Loading, Loaded] when the image is downloaded successfully",
        () {
      when(mockUrlDownloader.download(any))
          .thenAnswer((realInvocation) async => Right(true));

      final expected = [
        Loading(),
        Loaded(),
      ];

      expectLater(cubit, emitsInOrder(expected));

      cubit.downloadImage("url");
    });

    test("should emit [Loading, Error] when the image is NOT downloaded", () {
      when(mockUrlDownloader.download(any))
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
