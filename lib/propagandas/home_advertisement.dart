import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

import '../providers/links_provider.dart';

class HomeAdvertisement extends StatefulWidget {
  @override
  _HomeAdvertisementState createState() => _HomeAdvertisementState();
}

class _HomeAdvertisementState extends State<HomeAdvertisement> {
  var _isInit = true;
  var _isLoading = false;
  int activeIndex = 0;
  int indexSize = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<LinksProvider>(context, listen: false).loadLinks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final linkData = Provider.of<LinksProvider>(context);

    return _isLoading
        ? Column(
            children: [
              Container(
                height: 234,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              buildIndicator(),
            ],
          )
        : Center(
            child: Column(
              children: [
                const SizedBox(height: 4),
                CarouselSlider.builder(
                  options: CarouselOptions(
                      height: 230,
                      viewportFraction: 1,
                      enlargeCenterPage: false,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      onPageChanged: (index, reason) {
                        setState(() {
                          activeIndex = index;
                        });
                      }),
                  itemCount: linkData.links.length,
                  itemBuilder: (context, index, realIndex) {
                    final image = linkData.links[index].linkUrl.toString();

                    indexSize = linkData.links.length;

                    return buildImage(image, index);
                  },
                ),
                const SizedBox(height: 10),
                buildIndicator(),
              ],
            ),
          );
  }

  Widget buildImage(String image, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      color: Colors.white,
      child: Image.network(
        image,
        fit: BoxFit.fill,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: Image.asset(
              'assets/loading_image.png',
              scale: 2,
            ),
          );
        },
      ),
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: indexSize,
      effect: WormEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: Colors.blue.shade900,
        dotColor: Colors.black12,
      ),
    );
  }
}
