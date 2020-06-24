import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';

class SearchableDropdownButton extends StatefulWidget {
  final Map<String,dynamic> dataToUpdate;
  final String keyToUpdate;
  final List<String> dataList;
  SearchableDropdownButton(this.dataList, this.dataToUpdate, this.keyToUpdate);
  
  @override
  SearchableDropdownButtonState createState() => SearchableDropdownButtonState();
} 

class SearchableDropdownButtonState extends State<SearchableDropdownButton>{
  @override
  Widget build(BuildContext context){
    return SearchWidget<String>(
      dataList: widget.dataList,
      hideSearchBoxWhenItemSelected: false,
      queryBuilder: (String query, List<String> list){
        return list.where(
          (String item)=>item.toLowerCase().contains(query.toLowerCase())
        ).toList();
      },
      popupListItemBuilder: (String item) => _buildPopupListItem(item),
      onItemSelected: (item){
        setState(() {
          widget.dataToUpdate[widget.keyToUpdate] = item;
        });
      },
    );
  }

  Widget _buildPopupListItem(String content){
    return ListTile(dense: true, title: Text(content));
  }
}