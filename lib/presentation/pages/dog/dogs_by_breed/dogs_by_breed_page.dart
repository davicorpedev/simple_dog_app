import 'package:dog_app/application/dog/dogs_by_breed/dogs_by_breed_bloc.dart';
import 'package:dog_app/domain/entities/breed.dart';
import 'package:dog_app/injection_container.dart';
import 'package:dog_app/presentation/pages/dog/dogs_by_breed/widgets/dog_grid.dart';
import 'package:dog_app/presentation/widgets/breed_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DogByBreedPage extends StatelessWidget {
  final Breed breed;

  const DogByBreedPage({Key key, this.breed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,

          ),
          SliverToBoxAdapter(
            child: BreedInfo(breed: breed),
          ),
          SliverToBoxAdapter(
            child: BlocProvider(
              create: (_) => sl<DogsByBreedBloc>()
                ..add(GetAllDogsByBreed(breedId: breed.id)),
              child: BlocBuilder<DogsByBreedBloc, DogsByBreedState>(
                builder: (context, state) {
                  if (state is Loaded) {
                    return DogGrid(dogs: state.dogs);
                  } else if (state is Error) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
