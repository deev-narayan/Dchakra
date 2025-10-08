import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class BalanceMenu extends StatefulWidget {
  final String name;
  final Map<String, String> yogasana;

  const BalanceMenu({super.key, required this.yogasana, required this.name});

  @override
  _BalanceMenuState createState() => _BalanceMenuState();
}

class _BalanceMenuState extends State<BalanceMenu> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.yogasana.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = widget.yogasana.keys.toList();
    List<String> values = widget.yogasana.values.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              height: 650,
              width: 650,
              left: -320,
              child: Opacity(opacity: 0.1, child: SizedBox(child: AppLogo())),
            ),
            Center(child: LinrGrage()),
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            top: BorderSide(
                              width: 1,
                              color: const Color.fromARGB(22, 255, 255, 255),
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.home_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.calendar_month_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.settings),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Top bar - use Positioned directly in Stack (not inside Column)
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButton(color: Colors.white),
                  Text(
                    widget.name, // You can replace this with actual chakra name if needed
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // YogasanaList widget directly inside Stack and centered with padding
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              height: 420,
              child: Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.yogasana.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                values[index],
                                width: 300,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image,
                                    size: 100,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              keys[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: _prevPage,
                      ),
                      Text(
                        '${_currentPage + 1} / ${widget.yogasana.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: _nextPage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
