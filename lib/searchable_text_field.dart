library searchable_text_field;

export 'src/menu_option.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:searchable_text_field/src/menu_option.dart';


class SearchableTextField<T> extends StatelessWidget {
  final FormFieldValidator? validator;
  final ValueChanged? onChanged;
  final ValueChanged<T> onSelectedItem;
  final List<SearchableItem<T>>? items;
  final InputDecoration? decoration;
  final bool showLoader;
  final bool hideMenu;
  final Widget? loaderWidget;
  final Duration debounceDuration;
  final TextEditingController controller;
  final MenuOption? menuOption;

  const SearchableTextField({Key? key,
    this.validator,
    this.onChanged,
    this.items,
    required this.onSelectedItem,
    this.decoration,
    this.showLoader=false,
    required this.controller,
    this.hideMenu=false,
    this.debounceDuration= const Duration(milliseconds: 100), this.menuOption, this.loaderWidget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final debouncer=Debouncer(duration: debounceDuration);
    final theme=Theme.of(context);

    bool openBottomSheet=showLoader==true || ((items??[]).isNotEmpty && !hideMenu);
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
            child:  showLoader==true?  (loaderWidget?? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                      ),
                    ),
                  ),
                ],
              ),
            )):

            SingleChildScrollView(
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
            ))
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

