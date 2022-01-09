import 'dart:io';

import 'package:bwys/config/screen_config.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/shared/features/image_viewer/models/image_viewer_models.dart';
import 'package:bwys/shared/models/pnm_common_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerScreen extends StatelessWidget {
  final List<ImageItem> images;

  /// initial position to be used to display first image start from 0
  final int initialPosition;

  const PhotoViewerScreen({required this.images, this.initialPosition = 0});

  @override
  Widget build(BuildContext context) {
    return PhotoViewerContent(
      images: images,
      initialPosition: initialPosition,
    );
  }
}

class PhotoViewerContent extends StatefulWidget {
  final List<ImageItem> images;
  final int? initialPosition;

  const PhotoViewerContent({
    required this.images,
    this.initialPosition,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PhotoViewerContentState();
}

class PhotoViewerContentState extends State<PhotoViewerContent> {
  late List<ImageItem> images;
  int? initialPosition;
  int? currentPagePosition;
  PageController? pageController;

  @override
  void initState() {
    images = widget.images;
    initialPosition = widget.initialPosition;
    currentPagePosition = widget.initialPosition;
    pageController = PageController(initialPage: initialPosition!);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageViewerScreen(context);
  }

  Widget _buildImageViewerScreen(BuildContext context) {
    return Scaffold(
      body: AppBodyContainer(
        paddingLRTB: 0,
        topAppBar: AppTopBar(
          appBarTitle: 'photos',
          closeIconForBackButton: true,
        ),
        bodyWidget: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      (images[index].imageDataType == ImageDataType.file_path
                              ? FileImage(File(images[index].imageData))
                              : MemoryImage(images[index].imageData))
                          as ImageProvider<Object>?,
                  initialScale: PhotoViewComputedScale.contained * 0.9,
                );
              },
              itemCount: images.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: LightAppColors.stable,
              ),
              pageController: pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (pagePosition) {
                setState(() {
                  currentPagePosition = pagePosition;
                });
              },
            ),
            if (currentPagePosition! > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.xs),
                  child: InkWell(
                    onTap: () {
                      pageController!.animateToPage(currentPagePosition! - 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xss),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LightAppColors.stable,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: LightAppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (currentPagePosition! < images.length - 1)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: InkWell(
                    onTap: () {
                      pageController!.animateToPage(currentPagePosition! + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear);
                    },
                    child: Opacity(
                      opacity: 0.8,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xss),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: LightAppColors.stable,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: LightAppColors.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
