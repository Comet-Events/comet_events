import 'dart:ui';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';

class ImageUploader extends StatefulWidget {
  final String title;
  final Function(Asset) onTap;
  final Function(List<Asset>, Asset) onChange;
  final Function(String) showErrorSnack;
  final int maxPics;

  const ImageUploader({
    Key key,
    this.title,
    this.maxPics = 2,
    this.showErrorSnack,
    @required this.onChange,
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
      title: widget.title ?? "Tap to upload images (max: ${widget.maxPics})",
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for( int i = 0; i < images.length; i++ )                    
                ImageTile(
                  isCoverImage: i == chosenCover,
                  image: images[i],
                  onTap: (){_onTap(images[i], i);},
                  onTapDown: _storePosition,
                  onLongPress: (){ _showPopUp(i, false); }, 
                ),
              AddTile(onTap: _loadAssets)
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(Asset img, int i){
    print('tapped');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FullImageScreen(
        image: img,
        onTapDown: _storePosition,
        onTap: (){ _showPopUp(i, true); } 
      );
    }));
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList;
    String error;
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: widget.maxPics,
        materialOptions: MaterialOptions(
          actionBarColor: getHexString(_appTheme.secondaryMono),
          statusBarColor: getHexString(_appTheme.mainMono),
          allViewTitle: 'All Images',
          lightStatusBar: _appTheme.antiOpposite == Colors.white,
          startInAllView: true,
        )
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if( resultList.length + images.length > widget.maxPics ){
        _error = "You're allowed a max of ${widget.maxPics} images!";
        widget.showErrorSnack(_error);
        return;
      }

      images.addAll(resultList);
      widget.onChange(images, images[chosenCover]);

      if (error == null)
        _error = 'No Error Dectected';
    });
  }

  void _showPopUp(int i, bool inFullScreen){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      context: context, 
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), 
          Offset.zero & overlay.size   
      ),
      items: <PopupMenuEntry<int>>[PopUpEntry()],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: locator<CometThemeManager>().theme.secondaryMono
    ).then<void>((int delta){
      if( delta == null ) //if they tap outside of the pop up
        return;
      else if( delta == 0){ //tap on delete
        setState(() {
          //if viewing in full screen, first exit and then delete
          if( inFullScreen )
            Navigator.pop(context);

          images.remove(images[i]);

          if( i < chosenCover )
            chosenCover--;
          widget.onChange(images, images[chosenCover]);
        });
      }
      else{ //tap on star *-*
        setState(() {
          chosenCover = i;
        });
      }
      
    });
  }

  void _storePosition(TapDownDetails details){ _tapPosition = details.globalPosition;}

  String getHexString(Color color){
    String colorString = color.toString();
    String valueString = colorString.substring(colorString.indexOf("x")+3, colorString.length-1);
    return '#' + valueString;
  }
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
    return GestureDetector(
      onTap: onTap, //full screen
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
    return GestureDetector(
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
  final Function() onTap;
  final Function(TapDownDetails) onTapDown;

  const FullImageScreen({
    Key key,
    @required this.image,
    @required this.onTap,
    @required this.onTapDown
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CometThemeData _appTheme = locator<CometThemeManager>().theme;
    return Scaffold (
      backgroundColor: _appTheme.mainMono.withOpacity(0.2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTapDown: onTapDown,
                  onTap: onTap,
                  child: Icon(Icons.more_horiz)
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: (){ Navigator.pop(context); },
                )
              ],
            ),
          ),
          AssetThumb(
            asset: image,
            width: MediaQuery.of(context).size.width.floor(),
            height: ((MediaQuery.of(context).size.width.floor()*image.originalHeight)/image.originalWidth).floor()
          ),
        ],
      ),
    );
  }
}