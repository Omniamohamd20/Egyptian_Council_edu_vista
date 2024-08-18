import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:edu_vista_app/utils/images.utility.dart';
import 'package:edu_vista_app/widgets/onboarding_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const OnBoardingPage());

class OnBoardingPage extends StatelessWidget {
  static const String id = 'OnBoardingPage';
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: PageViewComponent(),
      ),
    );
  }
}

class PageViewComponent extends StatefulWidget {
  const PageViewComponent({super.key});

  @override
  State<PageViewComponent> createState() => _PageViewComponentState();
}

class _PageViewComponentState extends State<PageViewComponent>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'skip',
                  style: TextStyle(
                    color: ColorUtility.gry,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
            flex: 3,
            child: Container(
              child: PageView(
                controller: _pageViewController,
                onPageChanged: _handlePageViewChanged,
                children: <Widget>[
                  onBoardingPage(
                      ImagesUtility.badges,
                      'Certification and Badges',
                      'Earn a certificate after completion of every course'),
                  onBoardingPage(ImagesUtility.progress, 'Progress Tracking',
                      'Check your Progress of every course'),
                  onBoardingPage(ImagesUtility.amico, 'Offline Access',
                      'Make your course available offline'),
                  onBoardingPage(ImagesUtility.pana, 'Course Catalog',
                      'View in which courses you are enrolled'),
                ],
              ),
            )),
        Expanded(
            child: Container(
          child: PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
            isOnDesktopAndWeb: _isOnDesktopAndWeb,
          ),
        )),
      ],
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  Widget onBoardingPage(String image, String text1, String text2) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 300,
            height: 350,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(text1,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColorUtility.mediumBlack)),
          const SizedBox(
            height: 25,
          ),
          Text(text2,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: ColorUtility.mediumBlack)),
        ],
      ),
    );
  }
}

// arrows
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
    required this.isOnDesktopAndWeb,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;
  final bool isOnDesktopAndWeb;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(3.0),
              child: OnboardingIndicator(
                positionIndex: 0,
                currentIndex: currentPageIndex,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: OnboardingIndicator(
                positionIndex: 1,
                currentIndex: currentPageIndex,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: OnboardingIndicator(
                positionIndex: 2,
                currentIndex: currentPageIndex,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3.0),
              child: OnboardingIndicator(
                positionIndex: 3,
                currentIndex: currentPageIndex,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            currentPageIndex == 0 || currentPageIndex == 3
                ? const Text('')
                : RawMaterialButton(
                    onPressed: () {
                      if (currentPageIndex == 0) {
                        return;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex - 1);
                    },
                    fillColor: currentPageIndex == 1 || currentPageIndex == 2
                        ? ColorUtility.gry
                        : ColorUtility.secondary,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
            currentPageIndex == 3
                ? SizedBox.shrink()
                : RawMaterialButton(
                    onPressed: () {
                      if (currentPageIndex == 3) {
                        return;
                      }
                      onUpdateCurrentPageIndex(currentPageIndex + 1);
                    },
                    fillColor: ColorUtility.secondary,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
