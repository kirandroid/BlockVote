import 'dart:io';

import 'package:evoting/core/utils/colors.dart';
import 'package:evoting/core/utils/permission_checker.dart';
import 'package:evoting/core/utils/sizes.dart';
import 'package:evoting/core/utils/text_style.dart';
import 'package:evoting/core/widgets/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

typedef _SuccessCallback = void Function(File);
typedef _OnPressedCallback = void Function(BuildContext);

final BehaviorSubject<File> _postController = BehaviorSubject<File>();
Function(File) get _postCaptured => _postController.sink.add;
Stream<File> get _postFileStream => _postController.stream;

class PostImagePicker extends StatefulWidget {
  final _SuccessCallback listener;
  final Widget widget;
  final String url;
  final Color color;

  PostImagePicker({
    Key key,
    @required this.listener,
    this.widget,
    this.url,
    this.color,
  }) : super(key: key);

  @override
  _PostImagePickerState createState() => _PostImagePickerState();
}

class _PostImagePickerState extends State<PostImagePicker> {
  //

  @override
  void initState() {
    super.initState();
    _postFileStream.listen((File file) {
      widget.listener(file);
    });

    final String url = widget.url;
    if (url != null) {
      DefaultCacheManager().downloadFile(url).then((var info) {
        _postCaptured(info.file);
      });
    }
  }

  @override
  void dispose() {
    _postCaptured(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(109),
        onTap: () {
          Platform.isAndroid
              ? _AndroidBottomSheet(context)
              : _IosBottomSheet(context);
        },
        child: RectangularImageHolder(
          url: widget.url,
          color: widget.color,
        ));
  }
}

class RectangularImageHolder extends StatelessWidget {
  //

  final String url;
  final Color color;

  const RectangularImageHolder({Key key, this.url, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<File>(
      stream: _postFileStream,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return Container(
          height: UISize.width(200),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: UISize.width(200),
                decoration: BoxDecoration(
                  color: this.color ?? UIColors.primaryWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: UIColors.darkGray),
                  image: snapshot.hasData && snapshot.data != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(snapshot.data),
                        )
                      : null,
                ),

                // child: Container(
                //   height: 100,
                //   width: ScreenUtil.screenWidth,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       gradient: LinearGradient(
                //           begin: Alignment.topCenter,
                //           end: Alignment.bottomCenter,
                //           colors: [
                //             Color.fromRGBO(0, 0, 0, 0.8),
                //             Colors.transparent,
                //           ])),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       "License Image Front",
                //       style: StyleText.montMedium.copyWith(
                //           fontSize: UISize.fontSize(14), color: UIColors.white),
                //     ),
                //   ),
                // ),
              ),

              if (this.url != null &&
                  snapshot.connectionState == ConnectionState.waiting)
                CustomLoader(colors: Colors.black, size: 30.0, strokeWidth: 2),

              if (this.url == null ||
                  snapshot.connectionState == ConnectionState.active)
                Icon(
                  Icons.camera_enhance,
                  color: snapshot.hasData && snapshot.data != null
                      ? UIColors.primaryWhite
                      : UIColors.darkGray,
                  size: 50,
                ),

              //
            ],
          ),
        );
      },
    );
  }
}

class _IosBottomSheet extends StatelessWidget {
  //

  final BuildContext context;

  _IosBottomSheet(this.context) {
    showModalBottomSheet(
      context: this.context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    //

    return CupertinoActionSheet(
      actions: <Widget>[
        //

        // Choose photo
        _IOSBottomSheetItem(
          title: "Take Photo",
          onPresed: _takePhotoPressed,
        ),

        // Choose photo
        _IOSBottomSheetItem(
          title: "Choose Photo",
          onPresed: _choosePhotoPressed,
        ),

        //
      ],
      cancelButton: _IOSBottomSheetItem(
        title: "Cancel",
        onPresed: _onClosePressed,
      ),

      //
    );
  }
}

class _AndroidBottomSheet extends StatelessWidget {
  final BuildContext context;

  _AndroidBottomSheet(this.context) {
    showModalBottomSheet(
      context: this.context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //

        _AndroidBottomSheetItem(
          title: "Take Photo",
          onPresed: _takePhotoPressed,
        ),

        _AndroidBottomSheetItem(
          title: "Choose Photo",
          onPresed: _choosePhotoPressed,
        ),

        _AndroidBottomSheetItem(
          title: "Close",
          onPresed: _onClosePressed,
        ),

        //
      ],
    );
  }

  //
}

class _AndroidBottomSheetItem extends StatelessWidget {
  final _OnPressedCallback onPresed;
  final bool border;
  final String title;

  const _AndroidBottomSheetItem({
    Key key,
    this.onPresed,
    this.border = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.onPresed(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: this.border
              ? Border(bottom: BorderSide(color: UIColors.lightGray))
              : null,
        ),
        child: Text(
          this.title,
          style: StyleText.ralewayMedium.copyWith(
              fontSize: UISize.fontSize(14), color: UIColors.darkGray),
        ),
      ),
    );
  }
}

class _IOSBottomSheetItem extends StatelessWidget {
  final _OnPressedCallback onPresed;
  final String title;

  const _IOSBottomSheetItem({
    Key key,
    this.onPresed,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text(
        this.title,
        style: StyleText.ralewayMedium
            .copyWith(fontSize: UISize.fontSize(14), color: UIColors.darkGray),
      ),
      onPressed: () {
        this.onPresed(context);
      },
    );
  }
}

void _takePhotoPressed(BuildContext context) async {
  bool hasCameraPermission =
      await PermissionChecker.hasCameraPermission(context);

  if (hasCameraPermission) {
    final File image = await _pickImage(ImageSource.camera);

    if (image != null) {
      Navigator.of(context).pop();
      _postCaptured(image);
    }

    //
  }
}

void _choosePhotoPressed(BuildContext context) async {
  bool hasGalleryPermission =
      await PermissionChecker.hasGalleryPermission(context);

  if (hasGalleryPermission) {
    final File image = await _pickImage(ImageSource.gallery);

    if (image != null) {
      Navigator.of(context).pop();
      _postCaptured(image);
    }
  }
}

void _onClosePressed(BuildContext context) {
  Navigator.of(context).pop();
}

Future<File> _pickImage(ImageSource imageSource) async {
  try {
    return await ImagePicker.pickImage(source: imageSource).then(
      (File file) async {
        return await ImageCropper.cropImage(
          sourcePath: file.path,
          cropStyle: CropStyle.rectangle,
          compressFormat: ImageCompressFormat.jpg,
          maxHeight: 800,
          maxWidth: 800,
          compressQuality: 60,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: UIColors.primaryDarkTeal,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        );
      },
    );
  } catch (e) {
    print("Image picker exception : $e");
    return null;
  }
}
