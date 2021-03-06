import 'package:dog_app/application/dog/random_dog/random_dog_bloc.dart';
import 'package:dog_app/injection_container.dart';
import 'package:dog_app/presentation/core/widgets/breed_info.dart';
import 'package:dog_app/presentation/core/widgets/download_image_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RandomDogDetailPage extends StatefulWidget {
  @override
  _RandomDogDetailPageState createState() => _RandomDogDetailPageState();
}

class _RandomDogDetailPageState extends State<RandomDogDetailPage> {
  final bloc = sl<RandomDogBloc>();

  @override
  void initState() {
    bloc.add(GetRandomDog());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<RandomDogBloc, RandomDogState>(
            cubit: bloc,
            builder: (context, state) {
              if (state is Loaded) {
                return DownloadImageIconButton(state.dog.url);
              }
              return Container();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              bloc.add(GetRandomDog());
            },
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<RandomDogBloc, RandomDogState>(
          cubit: bloc,
          builder: (context, state) {
            if (state is Loaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Hero(
                        tag: state.dog.id,
                        child: Image.network(state.dog.url),
                      ),
                    ),
                    Column(
                      children: state.dog.breeds
                          .map((e) => BreedInfo(breed: e))
                          .toList(),
                    ),
                  ],
                ),
              );
            } else if (state is Error) {
              return Center(child: Text(state.message));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
