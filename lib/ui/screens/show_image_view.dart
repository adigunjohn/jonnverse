import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/styles.dart';

class ShowImageView extends StatelessWidget {
  const ShowImageView({super.key, this.image});
 static const String id = Routes.showImageView;
 final String? image;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image.toString(),
      // fit: BoxFit.cover,
      progressIndicatorBuilder: (context, imageUrl, progress){
        return SizedBox(
          height: 60,
          width: 60,
          child: Center(
            child: CircularProgressIndicator(
              color: kCAccentColor,
              value: progress.progress,
            ),
          ),
        );
      },
      errorWidget: (context, imageUrl, error) => Icon(Icons.image_not_supported_rounded, color: kCRedColor,),
    );
    //   Image.network(
    //   image.toString(),
    //   fit: BoxFit.cover,
    //   loadingBuilder: (context, child, loadingProgress) {
    //     if (loadingProgress == null) return Center(child: child);
    //     return SizedBox(
    //       height: 100,
    //       width: 100,
    //       child: Center(
    //         child: CircularProgressIndicator(
    //           color: kCAccentColor,
    //           value: loadingProgress.expectedTotalBytes != null
    //               ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
    //               : null,
    //         ),
    //       ),
    //     );
    //   },
    //   errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported_rounded, color: kCRedColor,),
    // );
  }
}
