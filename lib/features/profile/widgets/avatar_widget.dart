import 'package:flutter/cupertino.dart';

class AvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isNetworkImage;

  const AvatarWidget({
    Key? key,
    required this.imageUrl,
    this.size = 30,
    this.isNetworkImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: isNetworkImage
              ? NetworkImage(imageUrl)
              : AssetImage(imageUrl) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}