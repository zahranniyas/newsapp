import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/consts/vars.dart';
import 'package:mzn_news/models/news_model.dart';
import 'package:mzn_news/providers/news_provider.dart';
import 'package:mzn_news/screens/search.dart';
import 'package:mzn_news/widgets/articles.dart';
import 'package:mzn_news/widgets/loading.dart';
import 'package:mzn_news/widgets/no_result.dart';
import 'package:mzn_news/widgets/trending_articles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Pagination logic
  int currentPageIndex = 0;
  String sortBy = SortByEnum.popularity.name;

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(
      context,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const Search(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              icon: const Icon(
                IconlyBroken.search,
              ),
            )
          ],
          title: const Text('MZN News'),
        ),
        bottomNavigationBar: const TabBar(
          labelColor: Color.fromARGB(255, 54, 90, 138),
          unselectedLabelColor: Color.fromARGB(255, 22, 22, 22),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Color.fromARGB(255, 54, 90, 138),
          tabs: [
            Tab(text: 'Home', icon: Icon(IconlyBold.home)),
            Tab(text: 'Trending', icon: Icon(IconlyBold.chart)),
          ],
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (currentPageIndex == 0) {
                              return;
                            }
                            setState(() {
                              currentPageIndex -= 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(6),
                              backgroundColor: Colors.blue),
                          child: const Text(
                            'Prev',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: 6,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  color: currentPageIndex == index
                                      ? Colors.blue
                                      : const Color.fromARGB(
                                          255, 214, 237, 255),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = index;
                                      });
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${index + 1}'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (currentPageIndex == 5) {
                              return;
                            }
                            setState(() {
                              currentPageIndex += 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(6),
                              backgroundColor: Colors.blue),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton(
                            value: sortBy,
                            items: dropDownItems,
                            onChanged: (String? value) {
                              setState(() {
                                sortBy = value!;
                              });
                            }),
                      ),
                    ),
                  ),
                  FutureBuilder<List<NewsModel>>(
                      future: newsProvider.fetchAllNews(
                        pageIndex: currentPageIndex + 1,
                        sortBy: sortBy,
                      ),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loading();
                        } else if (snapshot.hasError) {
                          return Expanded(
                            child: NoResult(
                              text: 'An Error Occured ${snapshot.error}',
                              imagePath: 'assets/images/no_news.png',
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return const Expanded(
                            child: NoResult(
                              text: 'No News Found',
                              imagePath: 'assets/images/no_news.png',
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: const Articles(),
                              );
                            },
                          ),
                        );
                      })),
                ],
              ),
            ),
            // const Text("Trending")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text('Trending News from across the World'),
                  FutureBuilder<List<NewsModel>>(
                      future: newsProvider.fetchTopHeadlines(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loading();
                        } else if (snapshot.hasError) {
                          return Expanded(
                            child: NoResult(
                              text: 'An Error Occured ${snapshot.error}',
                              imagePath: 'assets/images/no_news.png',
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return const Expanded(
                            child: NoResult(
                              text: 'No News Found',
                              imagePath: 'assets/images/no_news.png',
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: const TrendingArticles(),
                              );
                            },
                          ),
                        );
                      })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];

    return menuItem;
  }
}
