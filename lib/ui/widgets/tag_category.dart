import 'package:comet_events/core/objects/Tag.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/ui/widgets/layout_widgets.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class CategoryPickerController {
  List<Tag> selected;
  List<Tag> categories;
  CategoryPickerController() {
    this.selected = [];
    this.categories = [];
  }
}

class CategoryPicker extends StatefulWidget {
  CategoryPicker({
    Key key, 
    @required this.controller,
    @required this.onChanged, 
    this.iconFontFamily = 'MaterialIcons', 
    this.maxChoices, 
    this.title, 
    this.iconFontPackage, 
    this.initCategories
  }) : super(key: key);

  CategoryPickerController controller;
  final String title;
  final String iconFontFamily;
  final String iconFontPackage;
  final Function(List<Tag> categories) onChanged;
  final int maxChoices;
  final List<String> initCategories;


  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}
class _CategoryPickerState extends State<CategoryPicker> {

  @override
  void initState() { 
    super.initState();
    if(widget.controller == null) widget.controller = CategoryPickerController();
    if(widget.controller.categories.length >= 1) {
      widget.controller.selected = widget.controller.categories.map((category) => widget.initCategories.contains(category.name) ? category : [] ).toList();
      widget.controller.selected.add(widget.controller.categories[0]);
    }
  }

  @override
  Widget build(BuildContext context) {

    int _count = widget.controller.selected.length;

    return SubBlockContainer(
      title: (widget.title ?? "Categories" + (widget.maxChoices != null ? " (max: ${widget.maxChoices})" : "")) + (widget.controller.selected.isNotEmpty ? "  •  ${widget.controller.selected.map((e) => e.name).toList().join(", ")}" : ""),
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for(int i = 0; i < widget.controller.categories.length; i++) 
                CategoryTile(
                  onTap: (category, selected) {        
                    if(selected) { setState(() { widget.controller.selected.removeWhere((cat) => cat.name == category.name); }); return; }
                    else if(widget.maxChoices != null && _count >= widget.maxChoices) setState(() { widget.controller.selected.removeLast(); }); 
                    setState(() { widget.controller.selected.add(category); });
                    widget.onChanged(widget.controller.selected);
                  },
                  iconFontFamily: widget.iconFontFamily,
                  iconFontPackage: widget.iconFontPackage,
                  selected: widget.controller.selected.map((e) => e.name).toList().contains(widget.controller.categories[i].name),
                  category: widget.controller.categories[i],
                )
            ],
          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, this.selected, this.category, this.iconFontFamily, this.onTap, this.iconFontPackage}) : super(key: key);

  final String iconFontFamily;
  final String iconFontPackage;
  final Function(Tag, bool) onTap;
  final bool selected;
  final Tag category;

  @override
  Widget build(BuildContext context) {

    CometThemeData _appTheme = locator<CometThemeManager>().theme;

    return InkWell(
      onTap: () => onTap(category, selected),
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: selected ? _appTheme.mainColor : _appTheme.secondaryMono,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(IconData(category.category.iconCode, fontFamily: iconFontFamily, fontPackage: iconFontPackage)),
            Text(category.name)
          ],
        ),
      ),
    );
  }
}


class TagPickerController { List<String> tags; TagPickerController() {this.tags = [];} }
class TagPicker extends StatefulWidget {
  TagPicker({Key key,
    this.controller,
    this.title, 
    @required this.onChange, 
    this.suggestions, 
    this.maxTags, 
    this.disabledTags, 
    this.initTags
  }) : super(key: key);

  TagPickerController controller;
  final String title;
  final Function(List<String>) onChange;
  final List<String> suggestions;
  final List<String> disabledTags;
  final int maxTags;
  final List<String> initTags;

  @override
  _TagPickerState createState() => _TagPickerState();
}
class _TagPickerState extends State<TagPicker> {
  double fontSize = 18;

  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  void initState(){
    super.initState();
    if(widget.controller == null) widget.controller = TagPickerController();
    widget.controller.tags = widget.initTags ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SubBlockContainer(
      title: widget.title ?? "Tags" + (widget.maxTags != null ? " (max: ${widget.maxTags})" : ""),
      space: 7,
      child: Tags(
        key: Key("1"),
        symmetry: false,
        columns: 0,
        textField: TagsTextField(
          autofocus: false,
          duplicates: false,
          lowerCase: true,
          textStyle: TextStyle(fontSize: 15),
          constraintSuggestion: false,
          suggestionTextColor: _appTheme.mainColor,
          textCapitalization: TextCapitalization.none,
          //this should eventually suggest the 5 most popular tags
          suggestions: widget.suggestions != null ? widget.suggestions : [],
          //when they search a tag, add it to the displaying tags,
          //if it doesn't already exist, also add it to the db
          onSubmitted: (String str){
            if(widget.disabledTags.contains(str)) return;
            else {
              if(widget.maxTags != null && widget.controller.tags.length >= widget.maxTags) {
                setState(() {
                  widget.controller.tags.removeLast();
                });
              }
              setState(() { widget.controller.tags.add(str); }); widget.onChange(widget.controller.tags);
            }
            str = "";
          }
        ),
        runSpacing: 7,
        itemCount: widget.controller.tags.length,
        itemBuilder: (index) {
          final item = widget.controller.tags[index];
          return GestureDetector(
            child: ItemTags(
              key: Key(index.toString()),
              index: index,
              title: item,
              pressEnabled: false,
              //change this so that the active color is white if
              //a pre-existing tag is selected and purple if the user creates a new tag
              activeColor: _appTheme.opposite.withOpacity(0.25),
              border: Border.all(
                width: 1,
                color: _appTheme.opposite,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              combine: ItemTagsCombine.onlyText,
              removeButton: ItemTagsRemoveButton(
                  color: _appTheme.secondaryMono,
                  backgroundColor: _appTheme.opposite.withOpacity(0.8),
                  onRemoved: () {
                    setState((){
                      widget.controller.tags.removeAt(index);
                    });
                    widget.onChange(widget.controller.tags);
                    return true;
                  }
                ),
              textStyle: TextStyle( fontSize: 14 ),
            ),
          );
        },
      ),
    );
  }
}
