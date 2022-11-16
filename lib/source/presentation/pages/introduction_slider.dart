library introduction_slider;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/widgets.dart';

// ignore: must_be_immutable
class IntroductionSlider extends StatefulWidget {
  /// Defines the appearance of the introduction slider items that are arrayed
  /// within the introduction slider.
  final List<IntroductionSliderItem> items;

  /// Determines the physics of a [Scrollable] widget.
  final ScrollPhysics? physics;

  /// The [Back] that is used to navigate to the previous page.
  final Back? back;

  /// The [Next] that is used to navigate to the next page.
  final Widget? next;

  /// The [Done] that is used to navigate to the target page.
  final Widget done;

  /// The [DotIndicator] that is used to indicate dots.
  final DotIndicator? dotIndicator;

  /// The two cardinal directions in two dimensions.
  final Axis scrollDirection;

  /// Show and hide app status/navigation bar on the introduction slider.
  final bool showStatusBar;

  /// The initial page index of the introduction slider.
  int initialPage;

  EdgeInsets? horizontalPadding;
  double topHeightHeader;
  double titleBottomPadding;

  IntroductionSlider(
      {Key? key,
      required this.items,
      this.showStatusBar = false,
      this.initialPage = 0,
      this.physics,
      this.scrollDirection = Axis.horizontal,
      this.back,
      required this.done,
      this.next,
      this.dotIndicator,
      this.horizontalPadding = EdgeInsets.zero,
      this.topHeightHeader = 0,
      this.titleBottomPadding = 0})
      : assert(
            (initialPage <= items.length - 1) && (initialPage >= 0), "initialPage can't be less than 0 or greater than items length."),
        super(key: key);

  @override
  State<IntroductionSlider> createState() => _IntroductionSliderState();
}

class _IntroductionSliderState extends State<IntroductionSlider> {
  /// The [PageController] of the introduction slider.
  late PageController pageController;

  /// [hideStatusBar] is used to hide status bar on the introduction slider.
  hideStatusBar(bool value) {
    if (value == false) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ],
      );
    }
  }

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage);
    hideStatusBar(widget.showStatusBar);
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastIndex = widget.initialPage == widget.items.length - 1;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //dots
        Container(
          padding: EdgeInsets.symmetric(vertical: widget.topHeightHeader),
          width: MediaQuery.of(context).size.width,
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: List.generate(
                  widget.items.length,
                  (index) => AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: index == widget.initialPage
                            ? widget.dotIndicator?.selectedColor
                            : widget.dotIndicator?.unselectedColor ?? widget.dotIndicator?.selectedColor?.withOpacity(0.5),
                      ),
                      height: widget.dotIndicator?.size,
                      width: index == widget.initialPage ? widget.dotIndicator!.size! * 2.5 : widget.dotIndicator!.size,
                      duration: const Duration(milliseconds: 350)))),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.items.length,
                  physics: widget.physics,
                  scrollDirection: widget.scrollDirection,
                  onPageChanged: (index) => setState(() => widget.initialPage = index),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: widget.items[index].backgroundColor,
                        gradient: widget.items[index].gradient,
                        image: widget.items[index].backgroundImageDecoration,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: widget.topHeightHeader),
                            child: widget.items[index].logo ?? const SizedBox(),
                          ),
                          Padding(
                              padding: widget.horizontalPadding! + EdgeInsets.only(bottom: widget.titleBottomPadding),
                              child: widget.items[index].title ?? const SizedBox()),
                          Padding(padding: widget.horizontalPadding!, child: widget.items[index].subtitle ?? const SizedBox()),
                          const Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 35,
                child: Padding(
                  padding: widget.horizontalPadding!,
                  child: lastIndex
                      ? widget.done
                      : widget.next == null
                          ? const SizedBox()
                          : widget.next!,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}