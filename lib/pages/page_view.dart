import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:edu_vista_app/utils/images.utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const PageViewComponentApp());

class PageViewComponentApp extends StatelessWidget {
  const PageViewComponentApp({super.key});

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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
              Container(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              print('Button pressed!');
            },
            child: Text(
              'skip',
              style: TextStyle(
                color: ColorUtility.gry,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        PageView(
          controller: _pageViewController,
          onPageChanged: _handlePageViewChanged,
          children: <Widget>[
      
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesUtility.badges,
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Certification and Badges',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorUtility.mediumBlack)),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                      'Earn a certificate after completion of every course',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: ColorUtility.mediumBlack)),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesUtility.progress,
                    width: 300,
                    height:150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Progress Tracking',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorUtility.mediumBlack)),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text('Check your Progress of every course',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: ColorUtility.mediumBlack)),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesUtility.amico,
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Offline Access',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorUtility.mediumBlack)),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text('Make your course available offline',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: ColorUtility.mediumBlack)),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesUtility.pana,
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text('Course Catalog',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorUtility.mediumBlack)),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text('View in which courses you are enrolled',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: ColorUtility.mediumBlack)),
                          
                ],
              ),
            ),
          ],
        ),
        PageIndicator(
          tabController: _tabController,
          currentPageIndex: _currentPageIndex,
          onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          isOnDesktopAndWeb: _isOnDesktopAndWeb,
        ),
        SizedBox(
          height: 300,
        )
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
}

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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [   TabPageSelector(
                  controller: tabController,
                  color: colorScheme.surface,
                  selectedColor: colorScheme.primary,
                  indicatorSize: 20,
                ),],),
                SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              RawMaterialButton(
                onPressed: () {
                  if (currentPageIndex == 0) {
                    return;
                  }
                  onUpdateCurrentPageIndex(currentPageIndex - 1);
                },
                fillColor: currentPageIndex == 0
                    ? ColorUtility.gry
                    : ColorUtility.secondary,
                child: Icon(
                  Icons.arrow_back,
                  size: 20.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
             SizedBox(width: 150,),
              RawMaterialButton(
                onPressed: () {
                  if (currentPageIndex == 3) {
                    return;
                  }
                  onUpdateCurrentPageIndex(currentPageIndex + 1);
                },
                fillColor: currentPageIndex == 3
                    ? ColorUtility.gry
                    : ColorUtility.secondary,
                child: Icon(
                  Icons.arrow_forward,
                  size: 20.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
