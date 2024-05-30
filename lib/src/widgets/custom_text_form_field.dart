import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellerkitcalllog/helpers/screen.dart';

enum TextFieldType { alphabet, email, text, password, phoneNumber, number }

enum EnableBorderType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10
}

enum FocusBorderType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10
}

enum ErrorBorderType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10
}

enum FocusErrorBorderType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10
}

enum ContentPadingType {
  type1,
  type2,
  type3,
  type4,
  type5,
  type6,
  type7,
  type8,
  type9,
  type10
}

class CustomTextform extends StatelessWidget {
  final TextEditingController? controller;
  // final TextFieldType textFieldType;
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final EnableBorderType enableborder;
  final FocusBorderType focusborder;
  final ErrorBorderType errorborder;
  //
  final String? Function(String?)? validator;
  final TextStyle? style;
  final Widget? prefixIcon;
  final bool? filled;
  final Color? fillColor;
  final InputBorder? border;
  final bool autofocus;
  final Color? cursorColor;
  final void Function(String)? onChanged;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool readOnly;
  final bool? alignLabelWithHint;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final String? counterText;
  final AutovalidateMode? autovalidateMode;
  final bool autocorrect;
  final int? minLines;
  final FocusErrorBorderType focusErrorborderType;
  final ContentPadingType contentpading;
  const CustomTextform({
    Key? key,
    this.style,
    this.minLines,
    this.enableborder = EnableBorderType.type1,
    this.focusborder = FocusBorderType.type1,
    this.errorborder = ErrorBorderType.type1,
    this.focusErrorborderType = FocusErrorBorderType.type1,
    this.counterText,
    this.autocorrect = true,
    this.onEditingComplete,
    this.contentpading = ContentPadingType.type1,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.labelStyle,
    this.autovalidateMode,
    this.hintStyle,
    this.alignLabelWithHint,
    this.cursorColor,
    this.onChanged,
    this.autofocus = false,
    this.border,
    this.filled,
    this.fillColor,
    this.prefixIcon,
    this.validator,
    this.controller,
    this.keyboardType,
    // this.textFieldType = TextFieldType.text,
    this.hintText,
    this.maxLength,
    this.labelText,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.inputFormatters,
    this.enabled = true,
    // required this.textFieldType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //  final alphabetValidator = MultiValidator([
    //     RequiredValidator(
    //         errorText: AppLocalizations.of(context)!.please_enter_a_value),
    //     PatternValidator(r'^[A-Za-z_ .,]+$',
    //         errorText: AppLocalizations.of(context)!.only_characters_are_allowed),
    //   ]);

    //   final emailValidator = MultiValidator([
    //     RequiredValidator(
    //       errorText:
    //           AppLocalizations.of(context)!.please_enter_your_email_address,
    //     ),
    //     EmailValidator(
    //         errorText: AppLocalizations.of(context)!.invalid_email_address_format)
    //   ]);

    //   final passwordValidator = MultiValidator([
    //     RequiredValidator(
    //         errorText: AppLocalizations.of(context)!.please_enter_your_password),
    //     MinLengthValidator(6,
    //         errorText: AppLocalizations.of(context)!.invalid_password_format)
    //   ]);

    //   final phoneNumberValidator = MultiValidator([
    //     RequiredValidator(
    //         errorText:
    //             AppLocalizations.of(context)!.please_enter_your_phone_number),
    //     MinLengthValidator(10,
    //         errorText: AppLocalizations.of(context)!.invalid_phone_number_format),
    //     PatternValidator(r'^[0-9]+$',
    //         errorText: AppLocalizations.of(context)!.invalid_phone_number_format),
    //   ]);

    //   final textValidator = MultiValidator([
    //     RequiredValidator(
    //         errorText: AppLocalizations.of(context)!.please_enter_a_value),
    //     MinLengthValidator(1,
    //         errorText: AppLocalizations.of(context)!.data_is_too_short),
    //   ]);

    //   final numberValidator = MultiValidator([
    //     RequiredValidator(
    //         errorText: AppLocalizations.of(context)!.please_enter_a_value),
    //     MinLengthValidator(1,
    //         errorText: AppLocalizations.of(context)!.data_is_too_short),
    //     PatternValidator(r'^[0-9]+$',
    //         errorText: AppLocalizations.of(context)!.invalid_number_format),
    //   ]);

    TextInputType _keyboardType(TextFieldType textFieldType) {
      switch (textFieldType) {
        case TextFieldType.alphabet:
          return TextInputType.text;
        case TextFieldType.email:
          return TextInputType.emailAddress;
        case TextFieldType.number:
          return TextInputType.number;
        case TextFieldType.password:
          return TextInputType.text;
        case TextFieldType.phoneNumber:
          return TextInputType.phone;
        case TextFieldType.text:
          return TextInputType.text;
        default:
          return TextInputType.text;
      }
    }

    // MultiValidator _validator(TextFieldType textFieldType) {
    //   switch (textFieldType) {
    //     case TextFieldType.alphabet:
    //       return alphabetValidator;
    //     case TextFieldType.email:
    //       return emailValidator;
    //     case TextFieldType.number:
    //       return numberValidator;
    //     case TextFieldType.password:
    //       return passwordValidator;
    //     case TextFieldType.phoneNumber:
    //       return phoneNumberValidator;
    //     case TextFieldType.text:
    //       return textValidator;
    //     default:
    //       return textValidator;
    //   }
    // }

    InputBorder _enabledBorder(EnableBorderType borderType) {
      switch (borderType) {
        case EnableBorderType.type1:
          return InputBorder.none;

        case EnableBorderType.type2:
          return const UnderlineInputBorder();

        case EnableBorderType.type3:
          return OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: theme.primaryColor),
            borderRadius: BorderRadius.circular(10),
          );
        case EnableBorderType.type4:
          return const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            //  when the CustomTextform in unfocused
          );
        case EnableBorderType.type5:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          );
        case EnableBorderType.type6:
          return const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            //  when the CustomTextform in unfocused
          );
        case EnableBorderType.type7:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.primaryColor),
          );
        case EnableBorderType.type8:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          );
        case EnableBorderType.type9:
          return OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          );
        default:
          return OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor),
          );
        // default:
        //   return InputBorder.none;
      }
    }

    InputBorder _focusedBorder(FocusBorderType borderType) {
      switch (borderType) {
        case FocusBorderType.type1: //
          return InputBorder.none;
        case FocusBorderType.type2: //
          return const UnderlineInputBorder();
        case FocusBorderType.type3: //
          return OutlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(8),
            // ),
          );
        case FocusBorderType.type4: //
          return OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 2.0),
            borderRadius: BorderRadius.circular(6),
          );
        case FocusBorderType.type5: //
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          );
        case FocusBorderType.type6: //
          return const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            //  when the CustomTextform in unfocused
          );
        case FocusBorderType.type7: //
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.primaryColor),
          );
        case FocusBorderType.type8: //
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          );
        case FocusBorderType.type9: //
          return OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(6),
          );
        default:
          return UnderlineInputBorder(
            borderSide: BorderSide(
              color: theme.primaryColor,
            ),
          );
      }
    }

    InputBorder _errorBorder(ErrorBorderType borderType) {
      switch (borderType) {
        case ErrorBorderType.type1:
          return InputBorder.none;
        case ErrorBorderType.type2:
          return const UnderlineInputBorder();
        case ErrorBorderType.type3:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          );
        case ErrorBorderType.type4:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red),
          );

        default: //
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          );
      }
    }

    InputBorder _focusErrorBorder(FocusErrorBorderType borderType) {
      switch (borderType) {
        case FocusErrorBorderType.type1:
          return InputBorder.none;
        case FocusErrorBorderType.type2:
          return const UnderlineInputBorder();
        case FocusErrorBorderType.type3:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          );
        case FocusErrorBorderType.type4:
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red),
          );

        default: //
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.grey),
          );
      }
    }

    EdgeInsets _contentPadding(ContentPadingType borderType) {
      switch (borderType) {
        case ContentPadingType.type1:
          return EdgeInsets.zero;
        case ContentPadingType.type2:
          return const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
        case ContentPadingType.type3:
          return const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 5,
          );
        case ContentPadingType.type4:
          return const EdgeInsets.symmetric(vertical: 12, horizontal: 5);
        case ContentPadingType.type5:
          return const EdgeInsets.symmetric(vertical: 15, horizontal: 5);
        case ContentPadingType.type6:
          return const EdgeInsets.symmetric(vertical: 11, horizontal: 10);
        case ContentPadingType.type7:
          return const EdgeInsets.symmetric(vertical: 5, horizontal: 5);
        case ContentPadingType.type8:
          return const EdgeInsets.symmetric(horizontal: 5);

        case ContentPadingType.type9:
          return EdgeInsets.only(
            top: Screens.bodyheight(context) * 0.04,
            left: Screens.bodyheight(context) * 0.01,
          );
        case ContentPadingType.type10:
          return const EdgeInsets.all(12);
        default:
          return const EdgeInsets.symmetric(vertical: 10, horizontal: 25);
      }
    }

    return TextFormField(
      // textAlignVertical: TextAlignVertical.bottom,
      cursorHeight: 23,
      autofocus: autofocus,
      validator: validator,
      minLines: minLines,
      controller: controller,
      cursorColor: cursorColor,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      autocorrect: autocorrect,
      onTap: onTap,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      textAlign: textAlign ?? TextAlign.left,
      obscureText: obscureText ?? false,
      style: style,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      // _keyboardType(textFieldType),
      decoration: InputDecoration(
        counterText: counterText,
        alignLabelWithHint: alignLabelWithHint,
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: fillColor,
        filled: filled,
        border: border,
        contentPadding: _contentPadding(contentpading),
        enabledBorder: _enabledBorder(enableborder),
        focusedBorder: _focusedBorder(focusborder),
        errorBorder: _errorBorder(errorborder),
        focusedErrorBorder: _focusErrorBorder(focusErrorborderType),
        // disabledBorder:
      ),
    );
  }
}
