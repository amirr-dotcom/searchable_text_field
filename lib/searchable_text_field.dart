import 'dart:async';

import 'package:flutter/material.dart';

class SearchableTextField<T> extends StatelessWidget {
  final FormFieldValidator? validator;
  final ValueChanged? onChanged;
  final ValueChanged<T> onSelectedItem;
  final List<SearchableItem<T>>? items;
  final InputDecoration? decoration;
  final bool? showLoader;
  final TextEditingController controller;
  const SearchableTextField({Key? key, this.validator, this.onChanged, this.items, required this.onSelectedItem, this.decoration, this.showLoader, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debouncer=Debouncer(milliseconds: 1000);
    final theme=Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          validator: validator?? (val){
            if(val==null || val.isEmpty){
              return "Required Field !";
            }
            else {
              return null;
            }
          },
          onChanged: (String val){
            debouncer.run(() {
              onChanged!(val);
            });
          },
          decoration: decoration,
        ),
        AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            constraints: BoxConstraints(
              maxHeight: showLoader==true? 40:(items??[]).isNotEmpty? 100:0,
              minHeight: 0
            ),
            margin: EdgeInsets.only(
                top: showLoader==true? 8:(items??[]).isNotEmpty? 8:0
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.primaryColor
              ),
            ),
            child:  showLoader==true? const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                ),
              )),
            ):ListView.builder(
              shrinkWrap: true,
              itemCount: (items??[]).length,
              itemBuilder: (context,index){
                SearchableItem<T> item=items![index];
                return InkWell(
                  onTap: (){
                    onSelectedItem(item.value);
                    controller.text=item.title;
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.title),
                  ),
                );
              },
            ))
      ],
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer!=null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}



class SearchableItem<T> extends StatelessWidget {
  final T value;
  final String title;
  const SearchableItem({Key? key, required this.value, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

