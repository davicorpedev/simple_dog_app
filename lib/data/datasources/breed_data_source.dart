import 'dart:convert';
import 'package:dog_app/data/core/error/exceptions.dart';
import 'package:dog_app/data/models/breed_model.dart';
import 'package:dog_app/server_config.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class BreedDataSource {
  final http.Client client;

  BreedDataSource({@required this.client});

  Future<List<BreedModel>> getBreeds() async {
    final response = await client.get(
      "$URL/breeds",
      headers: {"x-api-key": API_KEY},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      return body.map<BreedModel>((v) => BreedModel.fromJson(v)).toList();
    } else {
      throw ServerException();
    }
  }
}
