import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/models/news_model.dart';
import 'package:mzn_news/screens/news_details_app.dart';
import 'package:mzn_news/services/utils.dart';
import 'package:provider/provider.dart';
import '../consts/vars.dart';

class TrendingArticles extends StatelessWidget {
  const TrendingArticles({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final newsModelProvider = Provider.of<NewsModel>(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NewsDetailsApp.routeName,
            arguments: newsModelProvider.publishedAt);
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 230, 230, 230),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FancyShimmerImage(
                  imageUrl: newsModelProvider.urlToImage,
                  height: size.height * 0.12,
                  width: size.height * 0.12,
                  boxFit: BoxFit.fill,
                  errorWidget: Image.asset('assets/images/empty_image.png'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      newsModelProvider.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: smallTitle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          IconlyLight.profile,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            newsModelProvider.sourceName,
                            style: smallPara,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        const Icon(
                          IconlyLight.calendar,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          newsModelProvider.publishedDate,
                          style: smallPara,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
