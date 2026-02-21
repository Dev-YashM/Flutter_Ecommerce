import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  final List<String> images;

  const BannerSlider({
    super.key,
    required this.images,
  });

  @override
  State<BannerSlider> createState() => _CoolerImageSliderState();
}

class _CoolerImageSliderState extends State<BannerSlider> {
  late PageController _controller;
  Timer? _timer;

  int _currentPage = 0;
  final int _initialPage = 1000; // for infinite illusion

  @override
  void initState() {
    super.initState();

    _controller = PageController(initialPage: _initialPage);

    _currentPage = _initialPage;

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;

      _currentPage++;
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final image =
              widget.images[index % widget.images.length];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: image.startsWith("http")
                        ? NetworkImage(image)
                        : AssetImage(image) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        /// Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
                (index) {
              int activeIndex =
                  _currentPage % widget.images.length;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: activeIndex == index ? 18 : 8,
                decoration: BoxDecoration(
                  color: activeIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
