import 'dart:io';

import 'package:bwys/config/screen_config.dart';
import 'package:bwys/shared/features/photos_expandable/models/photos_expandable_models.dart';
import 'package:bwys/shared/models/pnm_common_model.dart';
import 'package:bwys/utils/services/app_localization.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';

class PhotosExpandable extends StatelessWidget {
  final bool editable;
  final bool showUploadButton;
  final int maxPhotos;
  final bool isInitialExpanded;

  /// list of photos cannot be null send empty list so that same instance can be
  /// updated upon modifications done by this widget
  final List<PhotoItem> photos;

  /// provides delete button callback, once received iterate over list of photos
  /// initially sent to this widget and find which ones to delete, after that
  /// reload the widget to update photos status.
  final VoidCallback? onTapDelete;

  /// provides upload button callback, once received iterate over list of photos
  /// initially sent to this widget and find which ones to upload, after that
  /// reload the widget to update photos status.
  final VoidCallback? onTapUpload;

  const PhotosExpandable({
    required this.photos,
    this.editable = false,
    this.showUploadButton = true,
    this.maxPhotos = 1,
    this.onTapDelete,
    this.onTapUpload,
    this.isInitialExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return PhotosExpandableContent(
      editable: editable,
      maxPhotos: maxPhotos,
      photos: photos,
      showUploadButton: showUploadButton,
      onTapDelete: onTapDelete,
      onTapUpload: onTapUpload,
      isInitialExpanded: isInitialExpanded,
    );
  }
}

class PhotosExpandableContent extends StatefulWidget {
  final bool? editable;
  final int? maxPhotos;
  final bool showUploadButton;
  final List<PhotoItem>? photos;
  final VoidCallback? onTapDelete;
  final VoidCallback? onTapUpload;
  final bool? isInitialExpanded;

  const PhotosExpandableContent({
    this.maxPhotos,
    this.editable,
    this.showUploadButton = true,
    this.photos,
    this.onTapDelete,
    this.onTapUpload,
    this.isInitialExpanded,
  });

  @override
  State<StatefulWidget> createState() => PhotosExpandableContentState();
}

class PhotosExpandableContentState extends State<PhotosExpandableContent> {
  bool selectionMode = false;
  late bool showUploadButton;
  int? maxPhotos;
  List<PhotoItem>? photos;
  VoidCallback? onTapDelete;
  VoidCallback? onTapUpload;
  bool? isInitialExpanded;

  @override
  void initState() {
    super.initState();
    showUploadButton = widget.showUploadButton;
    maxPhotos = widget.maxPhotos;
    photos = widget.photos;
    onTapDelete = widget.onTapDelete;
    onTapUpload = widget.onTapUpload;
    isInitialExpanded = widget.isInitialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AppExpandable(
      headerText: 'photos',
      expandedContentPadding: AppSpacing.l,
      expandedWidget: buildExpandedWidget(),
      isInitialExpanded: isInitialExpanded,
    );
  }

  Widget buildExpandedWidget() {
    if (!widget.editable! && photos!.isEmpty) {
      return Center(
          child: Container(
        width: AppScreenConfig.screenWidth * 0.8,
        child: AppText(
          'no_photos',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ));
    } else {
      return Column(
        children: <Widget>[
          if (widget.editable!) _displayAddPhotosTextRow(),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                if (widget.editable!)
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: 64,
                      width: 64,
                      child: InkWell(
                        onTap: _onAddImage(context),
                        child: Card(
                          elevation: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.add_a_photo),
                              AppText('add')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: photosListBuilder(),
                )
              ],
            ),
          ),
          if (showUploadButton && checkForLocalPhotos())
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.m),
              child: AppElevatedButton(
                message: 'upload',
                onPressed: onTapUpload,
                minWidth: AppScreenConfig.screenWidth * 0.35,
              ),
            )
        ],
      );
    }
  }

  bool checkForLocalPhotos() {
    return photos!.indexWhere((photo) => photo.isLocal) != -1;
  }

  bool checkForSelectedUploadedPhotos() {
    return photos!.indexWhere((photo) => photo.isSelected && !photo.isLocal) !=
        -1;
  }

  LayoutBuilder photosListBuilder() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xss),
          child: SizedBox(
            height: 64,
            width: boxConstraints.maxWidth,
            child: ListView.separated(
                itemCount: photos!.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, position) {
                  return const AppSizedBoxSpacing(
                    widthSpacing: AppSpacing.xss,
                  );
                },
                itemBuilder: (context, position) {
                  return getPhotosListItem(context, position);
                }),
          ),
        );
      },
    );
  }

  Widget getPhotosListItem(BuildContext context, int position) {
    return InkWell(
      onTap: () {
        if (!selectionMode) {
          // _showImageViewerDialog(context, position);
        } else {
          setState(() {
            photos![position].isSelected = !photos![position].isSelected;
          });
          if (photos!.indexWhere((photo) => photo.isSelected) == -1) {
            setState(() {
              selectionMode = false;
            });
          }
        }
      },
      onLongPress: () {
        if (!selectionMode && widget.editable!) {
          setState(() {
            selectionMode = true;
            photos![position].isSelected = true;
          });
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            child: Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              child: Image(
                  fit: BoxFit.fill,
                  image: (photos![position].imageDataType ==
                              ImageDataType.file_path
                          ? FileImage(File(photos![position].imageData))
                          : MemoryImage(photos![position].imageData))
                      as ImageProvider<Object>),
            ),
          ),
          if (photos![position].isSelected || photos![position].isLocal)
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  width: 56,
                  height: 56,
                ),
              ),
            ),
          if (photos![position].isSelected)
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
              ),
            ),
          if (photos![position].isLocal)
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(
                  Icons.file_upload,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _displayAddPhotosTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (selectionMode)
          Padding(
            padding: const EdgeInsets.only(
                right: AppSpacing.s, bottom: AppSpacing.s),
            child: InkWell(
              onTap: _onDelete(context),
              child: Icon(
                Icons.delete_outline,
              ),
            ),
          )
      ],
    );
  }

  // void _showImageViewerDialog(BuildContext context, int position) async {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (BuildContext buildContext) => PhotoViewerScreen(
  //       initialPosition: position,
  //       images: photos!
  //           .map((photo) => ImageItem(
  //               imageData: photo.imageData,
  //               imageDataType: photo.imageDataType,
  //               isLocal: photo.isLocal))
  //           .toList(),
  //     ),
  //   );
  // }

  /// This function open the bottom sheet to add an image
  void Function() _onAddImage(BuildContext context) {
    return () async {
      FocusScope.of(context).unfocus();
      if (photos!.length >= maxPhotos!) {
        CommonUtils.appShowSnackBar(context,
            "${AppLocalizations.of(context)!.translate('photos_add_limit_part_1')} $maxPhotos ${AppLocalizations.of(context)!.translate('photos_add_limit_part_2')}");
        return;
      }
      closeSelectionMode();
      // var result = await AppDialogs.showAppModalBottomSheet(
      //   context,
      //   SelectImageBottomSheet(
      //       message: AppLocalizations.of(context)!.translate('choose')),
      // );

      // if (result is File) {
      //   /// Add event of selected image to the corresponding bloc
      //   setState(() {
      //     photos!.add(PhotoItem(
      //       imageData: result.path,
      //       isLocal: true,
      //       imageDataType: ImageDataType.file_path,
      //     ));
      //   });
      // } else if (result is String) {
      //   /// Add event of error to the corresponding bloc
      //   CommonUtils.appShowSnackBar(
      //       context, AppLocalizations.of(context)!.translate(result) ?? result);
      // }
    };
  }

  /// This function deletes selected images
  void Function() _onDelete(BuildContext context) {
    return () async {
      if (checkForSelectedUploadedPhotos()) {
        removeSelectedLocalPhotos();
        markForDeletion();
        closeSelectionMode();
        if (onTapDelete != null) {
          onTapDelete!();
        }
      } else {
        removeSelectedLocalPhotos();
        closeSelectionMode();
      }
    };
  }

  void closeSelectionMode() {
    setState(() {
      selectionMode = false;
      for (final photo in photos!) {
        photo.isSelected = false;
      }
    });
  }

  void removeSelectedLocalPhotos() {
    setState(() {
      photos!.removeWhere((photo) => photo.isSelected && photo.isLocal);
    });
  }

  void markForDeletion() {
    for (final photo in photos!) {
      photo.markedForDeletion = photo.isSelected;
    }
  }
}
