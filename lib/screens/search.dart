import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/consts/vars.dart';
import 'package:mzn_news/models/news_model.dart';
import 'package:mzn_news/providers/news_provider.dart';
import 'package:mzn_news/services/utils.dart';
import 'package:mzn_news/widgets/articles.dart';
import 'package:mzn_news/widgets/no_result.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // Search init code
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
  }

  List<NewsModel>? searchList = [];
  bool isSearching = false;
  @override
  void dispose() {
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final newsProvider = Provider.of<NewsProvider>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        focusNode.unfocus();
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        IconlyLight.arrow_left_2,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextField(
                          focusNode: focusNode,
                          controller: _searchTextController,
                          style: const TextStyle(color: Colors.black),
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onEditingComplete: () async {
                            searchList = await newsProvider.searchNewsProvider(
                                query: _searchTextController.text);
                            isSearching = true;
                            focusNode.unfocus();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: "Search",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffix: GestureDetector(
                              onTap: () {
                                _searchTextController.clear();
                                focusNode.unfocus();
                                isSearching = false;
                                searchList!.clear();
                                setState(() {});
                              },
                              child: const Icon(
                                IconlyLight.close_square,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSearching && searchList!.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MasonryGridView.count(
                      itemCount: searchKeywords.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _searchTextController.text = searchKeywords[index];
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                searchKeywords[index],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (isSearching && searchList!.isEmpty)
                const Expanded(
                  child: NoResult(
                    text: 'No results found',
                    imagePath: 'assets/images/search.png',
                  ),
                ),
              if (searchList != null && searchList!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchList!.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: searchList![index],
                        child: const Articles(),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
