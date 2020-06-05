import 'package:comet_events/core/objects/Tag.dart';
import 'package:comet_events/ui/theme/theme.dart';
import 'package:comet_events/ui/widgets/date_time.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

class CategoryPicker extends StatefulWidget {
  CategoryPicker({Key key, @required this.categories, this.iconFontFamily = 'MaterialIcons', @required this.onChanged, this.maxChoices = 1, this.title}) : super(key: key);

  final String title;
  final String iconFontFamily;
  final List<Tag> categories;
  final Function(Tag category, bool removed) onChanged;
  final int maxChoices;


  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}
class _CategoryPickerState extends State<CategoryPicker> {

  List<String> selectedCategoryNames = [];

  @override
  void initState() { 
    super.initState();
    if(widget.categories.length >= 1) {
      selectedCategoryNames.add(widget.categories[0].name);
    }
  }

  @override
  Widget build(BuildContext context) {

    int _count = selectedCategoryNames.length;

    return SubBlockContainer(
      title: (widget.title ?? "Categories (max: ${widget.maxChoices})") + (selectedCategoryNames.isNotEmpty ? "  •  ${selectedCategoryNames.join(", ")}" : ""),
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for(int i = 0; i < widget.categories.length; i++) 
                CategoryTile(
                  onTap: (category, selected) {        
                    if(selected) {
                      setState(() { selectedCategoryNames.remove(category.name); });
                      widget.onChanged(category, true);
                      return;
                    }
                    else if(_count >= widget.maxChoices) selectedCategoryNames.removeLast();
                    setState(() { selectedCategoryNames.add(category.name); });
                    widget.onChanged(category, false);
                  },
                  iconFontFamily: widget.iconFontFamily,
                  selected: selectedCategoryNames.contains(widget.categories[i].name),
                  category: widget.categories[i],
                )
            ],
          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  const CategoryTile({Key key, this.selected, this.category, this.iconFontFamily, this.onTap}) : super(key: key);

  final String iconFontFamily;
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
            Icon(IconData(category.category.iconCode, fontFamily: iconFontFamily)),
            Text(category.name)
          ],
        ),
      ),
    );
  }
}


class TagPicker extends StatefulWidget {
  const TagPicker({Key key,
    this.title, @required this.onChange, this.suggestions, this.maxTags = 7,
  }) : super(key: key);

  final String title;
  final Function(List<String>) onChange;
  final List<String> suggestions;
  final int maxTags;

  @override
  _TagPickerState createState() => _TagPickerState();
}
class _TagPickerState extends State<TagPicker> {
  double fontSize = 18;
  List displayItems = [];
  //here, displayItems is the list of all tags that are being shown on the screen
  //allItems is intended to be the list of all existing tags or categories in the db
  //there should be no tags showing until the user adds them

  final CometThemeData _appTheme = locator<CometThemeManager>().theme;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubBlockContainer(
      title: widget.title ?? "Tags (max: ${widget.maxTags})",
      space: 7,
      child: Tags(
        key: Key("1"),
        symmetry: false,
        columns: 0,
        textField: TagsTextField(
          duplicates: false,
          lowerCase: true,
          textStyle: TextStyle(fontSize: 15),
          constraintSuggestion: false,
          suggestionTextColor: _appTheme.mainColor,
          //this should eventually suggest the contents of allItems
          suggestions: widget.suggestions != null ? widget.suggestions : [],
          //when they search a tag, add it to the displaying tags,
          //if it doesn't already exist, also add it to the db
          onSubmitted: (String str){
            if(displayItems.length >= widget.maxTags) {
              displayItems.removeLast();
            }
            setState(() { displayItems.add(str); }); widget.onChange(displayItems);
            str = "";
          }
        ),
        runSpacing: 7,
        itemCount: displayItems.length,
        itemBuilder: (index) {
          final item = displayItems[index];
          return GestureDetector(
            child: ItemTags(
              key: Key(index.toString()),
              index: index,
              title: item,
              pressEnabled: false,
              //TO DO: change this so that the active color is white if
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
                      displayItems.removeAt(index);
                    });
                    widget.onChange(displayItems);
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
