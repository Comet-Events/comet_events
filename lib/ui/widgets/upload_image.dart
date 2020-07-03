import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';

class ImageUploader extends StatefulWidget {
  final String title;

  const ImageUploader({
    Key key,
    this.title
  }) : super(key: key);
  
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  Widget build(BuildContext context) {
    return SubBlockContainer(
      title: (widget.title ?? "Tap to upload images"),
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for(int i = 0; i < images.length; i++) 
                ImageTile(image: images[i]),
              AddTile( onTap: (){loadAssets();} )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    String error;

    setState(() {
      images = List<Asset>();
    });

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }
}

class ImageTile extends StatelessWidget {
  final bool isCoverImage;
  final Asset image;

  const ImageTile({
    Key key,
    this.isCoverImage = false,
    @required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    return InkWell(
      onTap: () {},
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: _appTheme.secondaryMono,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1.5,
            color: isCoverImage ? _appTheme.mainColor : Colors.transparent
          )
        ),
        child: Container(
          decoration: BoxDecoration(
            
          ),
          child: AssetThumb(
            asset: image,
            height: 70,
            width: ((70/image.originalHeight)*image.originalWidth).floor()
          ),
        )
      ),
    );
  }
}

class AddTile extends StatelessWidget {
  final Function() onTap;

  const AddTile({Key key, this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: _appTheme.secondaryMono,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.add, color: _appTheme.mainColor),
      ),
    );
  }
}
