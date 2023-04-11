library searchable_text_field;

export 'src/menu_option.dart';
export 'src/status.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchable_text_field/searchable_text_field.dart';


class SearchableTextField<T> extends StatelessWidget {
  final FormFieldValidator? validator;
  final ValueChanged? onChanged;
  final ValueChanged<T> onSelectedItem;
  final List<SearchableItem<T>>? items;
  final InputDecoration? decoration;
  final SearchableTextFieldStatus status;
  final Widget? loaderWidget;
  final Widget? noItemWidget;
  final Duration debounceDuration;
  final TextEditingController controller;
  final MenuOption? menuOption;

  const SearchableTextField({Key? key,
    this.validator,
    this.onChanged,
    this.items,
    required this.onSelectedItem,
    this.decoration,
    this.status=SearchableTextFieldStatus.none,
    required this.controller,
    this.debounceDuration= const Duration(milliseconds: 500), this.menuOption, this.loaderWidget, this.noItemWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debouncer=Debouncer(duration: debounceDuration);
    final theme=Theme.of(context);

    bool openBottomSheet=(status==SearchableTextFieldStatus.itemFound ||
        status==SearchableTextFieldStatus.noItemFound ||
        status==SearchableTextFieldStatus.loading);


    Widget loader=loaderWidget?? const Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          height: 10,
          width: 10,
          child: CircularProgressIndicator(
          ),
        ),
      ),
    );
    
    
    Widget itemsWidget=SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate((items??[]).length, (index) {
          SearchableItem<T> item=items![index];
          return InkWell(
            onTap: (){
              onSelectedItem(item.value);
              controller.text=item.title;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: menuOption?.alignment??Alignment.centerLeft,
                  child: Text(item.title,
                    textAlign: item.textAlign,
                    style: item.style,)),
            ),
          );
        }),
      ),
    );


    Widget noItemFoundWidget=noItemWidget?? const Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(child: Text("No Item Found ")),
    );


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
              if(onChanged!=null){
                onChanged!(val);
              }
            });
          },
          decoration: decoration,
        ),
        AnimatedContainer(
            duration: menuOption?.animationDuration??const Duration(milliseconds: 500),
            constraints: BoxConstraints(
                maxHeight: openBottomSheet? (menuOption?.maxHeight?? 100):0,
                minHeight: 0
            ),
            padding: menuOption?.padding,
            margin: menuOption?.padding?? EdgeInsets.only(
                top: openBottomSheet? 8:0
            ),
            decoration: menuOption?.decoration?? BoxDecoration(
              border: Border.all(
                  color: theme.primaryColor
              ),
            ),
            child:  status==SearchableTextFieldStatus.loading?  loader:
            status==SearchableTextFieldStatus.itemFound? itemsWidget :
            status==SearchableTextFieldStatus.noItemFound? noItemFoundWidget :
            status==SearchableTextFieldStatus.itemSelected? itemsWidget :
            Container())
      ],
    );
  }
}

class Debouncer {
  final Duration duration;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.duration});

  run(VoidCallback action) {
    if (_timer!=null) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }
}



class SearchableItem<T> extends StatelessWidget {
  final T value;
  final String title;
  final TextStyle? style;
  final TextAlign? textAlign;
  const SearchableItem({Key? key, required this.value, required this.title, this.style, this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

