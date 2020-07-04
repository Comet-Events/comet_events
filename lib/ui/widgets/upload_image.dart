import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';

class ImageUploader extends StatefulWidget {
  final String title;
  final Function(Asset) onTap;

  const ImageUploader({
    Key key,
    this.title,
    @required this.onTap,
  }) : super(key: key);
  
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}
class _ImageUploaderState extends State<ImageUploader> {
  List<Asset> images = List<Asset>();
  String _error;
  Offset _tapPosition;
  int chosenCover;

  @override
  void initState(){
    super.initState();
    chosenCover = 0;
  }

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
              for( int i = 0; i < images.length; i++ )                    
                Hero(
                  tag: "uploadedImage",
                  child: ImageTile(
                    isCoverImage: i == chosenCover,
                    image: images[i],
                    // onTap: widget.onTap(images[i]),
                    onTap: (){},
                    onTapDown: _storePosition,
                    onLongPress: (){ _showPopUp(i); }, 
                  ),
                ),
              AddTile(onTap: _loadAssets)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList;
    String error;

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
      images.addAll(resultList);
      if (error == null) _error = 'No Error Dectected';
    });
  }

  void _showPopUp(int i){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      context: context, 
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size   // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry<int>>[PopUpEntry()],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: locator<CometThemeManager>().theme.secondaryMono
    ).then<void>((int delta){
      if( delta == null )
        return;
      else if( delta == 0){
        setState(() {
          images.remove(images[i]);
        });
      }
      else{
        setState(() {
          chosenCover = i;
        });
      }
      
    });
  }

  void _storePosition(TapDownDetails details){ _tapPosition = details.globalPosition;}
}

class PopUpEntry extends PopupMenuEntry<int> {
  @override
  _PopUpEntryState createState() => _PopUpEntryState();

  @override
  double get height => 10;

  @override
  bool represents(int n) => n == 0 || n == 1;
}
class _PopUpEntryState extends State<PopUpEntry> {
  void _delete(){ Navigator.pop<int>(context, 0); }

  void _star(){ Navigator.pop<int>(context, 1); } 
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: IconButton(icon: Icon(Icons.delete), onPressed: _delete)),
        Expanded(child: IconButton(icon: Icon(Icons.star), onPressed: _star))
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  final double borderRadius;
  final double borderWidth;
  final double height;
  final bool isCoverImage;
  final Asset image;
  final Function() onTap;
  final Function(TapDownDetails) onTapDown;
  final Function() onLongPress;

  const ImageTile({
    Key key,
    this.isCoverImage = false,
    this.borderRadius = 10,
    this.borderWidth = 2,
    this.height = 70,
    @required this.onTap,
    @required this.onLongPress,
    @required this.onTapDown,
    @required this.image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    return InkWell(
      onTap: onTap, //full screen that hoe
      onTapDown: onTapDown, //save tap position
      onLongPress: onLongPress,//popup menu for delete and make cover
      child: Container(
        height: height,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            width: borderWidth,
            color: isCoverImage ? _appTheme.mainColor : _appTheme.secondaryMono
          )
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius-borderWidth),
          child: AssetThumb(
            asset: image,
            height: height.floor(),
            width: ((height/image.originalHeight)*image.originalWidth).floor()
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

class FullImageScreen extends StatelessWidget {
  final Asset image;

  const FullImageScreen({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold (
        body: Center(
          child: Hero(
            tag: "uploadedImage",
            child: AssetThumb(
              asset: image,
              width: MediaQuery.of(context).size.width.floor(),
              height: ((MediaQuery.of(context).size.width.floor()*image.originalHeight)/image.originalWidth).floor()
            )
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}