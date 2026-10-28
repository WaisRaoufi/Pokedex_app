import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pokedex_app/controllers/home_page_controllers.dart';
import 'package:pokedex_app/models/page_data.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/providers/pokemon_data_providers.dart';
import 'package:pokedex_app/widgets/pokemon_card.dart';
import 'package:pokedex_app/widgets/pokemon_list_tile.dart';

final HomePageControllersProvider =
    StateNotifierProvider<HomePageControllers, HomePageData>((ref) {
      return HomePageControllers(HomePageData.initial());
    });

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _allPokemonListScrollController = ScrollController();
  late HomePageControllers _homePageControllers;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListner);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListner);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListner() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        _allPokemonListScrollController.position.outOfRange) {
      _homePageControllers.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageControllers = ref.watch(HomePageControllersProvider.notifier);
    _homePageData = ref.watch(HomePageControllersProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);

    return Scaffold(body: _buildUI(context));
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favoritePokemonsList(context),
              _allPokemonsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Favorites', style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.50,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemCount: _favoritePokemons.length,
                      itemBuilder: (context, index) {
                        String pokemonURL = _favoritePokemons[index];
                        return PokemonCard(pokemonURL: pokemonURL);
                      },
                    ),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text('No Favorite Pokemon Yet! :("'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Pokemons', style: TextStyle(fontSize: 25)),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonURL: pokemon.url!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
