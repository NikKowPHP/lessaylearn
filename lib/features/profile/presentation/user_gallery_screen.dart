import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lessay_learn/core/providers/user_provider.dart';
import 'package:lessay_learn/features/profile/models/profile_picture_model.dart';

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
    final profilePicturesAsync = ref.watch(userProfilePicturesProvider(widget.userId));

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
        child: profilePicturesAsync.when(
          data: (pictures) {
            if (pictures.isEmpty) {
              return Center(child: Text('No pictures found'));
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pictures.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPictureView(pictures[index]);
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  child: _buildGalleryGrid(pictures),
                ),
              ],
            );
          },
          loading: () => Center(child: CupertinoActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error loading gallery')),
        ),
      ),
    );
  }

  Widget _buildPictureView(ProfilePictureModel picture) {
    final likesAsync = ref.watch(likesForPictureProvider(picture.id));
    final commentsAsync = ref.watch(commentsForPictureProvider(picture.id));

    return Column(
      children: [
        Expanded(
          child: buildGalleryImage(
            imageUrl: picture.base64Image,
            isNetworkImage: false,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.heart),
                    onPressed: () {
                      // Implement like functionality
                    },
                  ),
                  SizedBox(width: 16),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.chat_bubble),
                    onPressed: () {
                      // Implement comment functionality
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              likesAsync.when(
                data: (likes) => Text('${likes.length} likes'),
                loading: () => CupertinoActivityIndicator(),
                error: (_, __) => Text('Failed to load likes'),
              ),
              SizedBox(height: 8),
              commentsAsync.when(
                data: (comments) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: comments.take(2).map((comment) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text('${comment.userId}: ${comment.content}'),
                    );
                  }).toList(),
                ),
                loading: () => CupertinoActivityIndicator(),
                error: (_, __) => Text('Failed to load comments'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGalleryImage({
    required String imageUrl,
    bool isNetworkImage = true,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8)),
    VoidCallback? onTap,
  }) {
    Widget image;
    if (isNetworkImage) {
      image = Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CupertinoActivityIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: CupertinoColors.systemGrey5,
            child: Icon(CupertinoIcons.photo, color: CupertinoColors.systemGrey),
          );
        },
      );
    } else {
      image = Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: image,
      ),
    );
  }

  Widget _buildGalleryGrid(List<ProfilePictureModel> pictures) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: pictures.length,
      itemBuilder: (context, index) {
        final picture = pictures[index];
        return buildGalleryImage(
          imageUrl: picture.base64Image,
          isNetworkImage: false, // Assuming all profile pictures are network images
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          onTap: () {
            // Navigate to full-screen view or update current view
            _pageController.jumpToPage(index);
          },
        );
      },
    );
  }
}