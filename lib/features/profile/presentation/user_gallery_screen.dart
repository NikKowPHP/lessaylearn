import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';

class UserGalleryScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserGalleryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserGalleryScreenState createState() => _UserGalleryScreenState();
}

class _UserGalleryScreenState extends ConsumerState<UserGalleryScreen> {
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

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userByIdProvider(widget.userId));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Gallery'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      child: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return Center(child: Text('User not found'));
            }

            // For this example, we'll use a list of dummy image URLs
            // In a real app, you'd fetch these from the user's data
            final List<String> imageUrls = [
              user.avatarUrl,
              'assets/avatar-1.png',
              'assets/avatar-2.png',
              'assets/avatar-3.png',
            ];

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imageUrls.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            // Swipe right
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else if (details.primaryVelocity! < 0) {
                            // Swipe left
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                              maxHeight: MediaQuery.of(context).size.height * 0.6,
                            ),
                            child: Image.asset(
                              imageUrls[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? CupertinoColors.activeBlue
                            : CupertinoColors.systemGrey3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
          loading: () => Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error loading user data')),
        ),
      ),
    );
  }
}