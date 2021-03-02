import 'package:bloc/bloc.dart';
import 'package:dog_app/application/download_image/download_image_state.dart';
import 'package:dog_app/domain/repositories/url_downloader_repository.dart';
import 'package:meta/meta.dart';


class DownloadImageCubit extends Cubit<DownloadImageState> {
  final UrlDownloaderRepository repository;

  DownloadImageCubit({@required this.repository}) : super(Initial());

  Future<void> downloadImage(String url) async {
    emit(Loading());
    final result = await repository.download(url);

    result.fold(
      (error) {
        emit(Error());
      },
      (isDownloaded) {
        emit(Loaded());
      },
    );
  }
}
