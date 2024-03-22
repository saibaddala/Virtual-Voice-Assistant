import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:titer/backend/providers.dart';
import 'package:titer/ui/constants/pallete.dart';
import 'package:titer/ui/custom_widgets/loading.dart';
import 'package:titer/ui/custom_widgets/search_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool doSearch = false;
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    doSearch = true;
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  fillColor: Pallete.searchBarColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Pallete.searchBarColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Pallete.blueColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Pallete.blueColor),
                  ),
                  hintText: 'Search twitter',
                ),
              ),
            ),
          ),
        ),
        body: doSearch
            ? ref.watch(searchUsersByNameProvider(searchController.text)).when(
                  data: (users) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: ((context, index) {
                        return SearchTile(
                          user: users[index],
                        );
                      }),
                    );
                  },
                  error: (error, stackTrace) {
                    return const Center(
                      child: Text("Some Error Occurred"),
                    );
                  },
                  loading: () => const LoadingIndicator(),
                )
            : const SizedBox());
  }
}
