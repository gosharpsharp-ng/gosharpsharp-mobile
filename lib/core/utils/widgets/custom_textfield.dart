import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomRoundedInputField extends StatefulWidget {
  final String label;
  final String title;
  final Color titleColor;
  final int maxLines;
  final TextAlign textAlign;
  final List<TextInputFormatter>? formatter;
  final TextEditingController? controller;
  final Color color;
  final Color labelColor;
  final Color fillColor;
  final Color cursorColor;
  final Color textColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? regex;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final Function(dynamic)? onChanged;
  final bool isRequired;
  final bool isNumber;
  final bool filled;
  final bool isSearch;
  final String? prefixAsset;
  final String? Function(String?)? validator;
  final bool useCustomValidator;
  final bool isPhone;
  final bool readOnly;
  final bool showLabel;
  final bool hasDropdown;
  final bool hasTitle;
  final double fontSize;
  final double labelFontSize;
  final EdgeInsets edgeInsets;

  const CustomRoundedInputField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.hasDropdown = false,
    this.filled = true,
    this.title = "",
    this.isPhone = false,
    this.showLabel = false,
    this.isSearch = false,
    this.useCustomValidator = false,
    this.validator,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    this.cursorColor = AppColors.disabledColor,
    this.fillColor = AppColors.textFieldBackgroundColor,
    this.color = AppColors.disabledColor,
    this.textColor = AppColors.blackColor,
    this.titleColor = AppColors.blackColor,
    this.labelColor = AppColors.obscureTextColor,
    this.obscureText = false,
    this.hasTitle = false,
    this.formatter,
    this.prefixWidget,
    this.prefixAsset,
    this.onChanged,
    this.regex,
    this.suffixWidget = const SizedBox.shrink(),
    this.fontSize = 14,
    this.labelFontSize = 14,
    this.isRequired = true,
    this.isNumber = false,
    this.readOnly = false,
    this.edgeInsets = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<CustomRoundedInputField> createState() =>
      _CustomRoundedInputFieldState();
}

class _CustomRoundedInputFieldState extends State<CustomRoundedInputField> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasTitle
              ? customText(
                  widget.title,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.labelFontSize.sp,
                  color: widget.titleColor,
                )
              : const SizedBox.shrink(),
          SizedBox(height: widget.hasTitle ? 5.sp : 0.sp),
          Focus(
            onFocusChange: (hasFocus) {
              _hasFocus = hasFocus;
              setState(() {});
            },
            child: TextFormField(
              readOnly: widget.readOnly,
              // textAlign: widget.isCurrency?TextAlign.center:TextAlign.left,
              textAlign: widget.textAlign,
              cursorColor: widget.cursorColor,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              minLines: 1,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatter,
              onChanged: widget.onChanged,
              validator: !widget.isRequired
                  ? null
                  : widget.useCustomValidator
                      ? widget.validator
                      : (value) {
                          if (widget.regex != null) {
                            RegExp regExp = RegExp(
                              widget.regex!,
                              caseSensitive: false,
                              multiLine: false,
                            );
                            if (!regExp.hasMatch(value!)) {
                              return "Invalid ${widget.title}";
                            }
                          }
                          if (value!.isEmpty) {
                            return "${widget.title} field is required";
                          }
                          return null;
                        },
              focusNode: widget.focusNode,
              controller: widget.controller,
              style: widget.isNumber
                  ? TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: widget.textColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp),
              decoration: InputDecoration(
                prefixIcon: widget.isPhone
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8.sp, bottom: 0.1.sp, top: 2.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        SvgAssets.nigerianFlag,
                                        height: 15.sp,
                                      ),
                                      SizedBox(
                                        width: 3.sp,
                                      ),
                                      customText(
                                        '+234 ',
                                        color: widget.color,
                                        fontSize: widget.labelFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // VerticalDivider(
                            //     color: _hasFocus
                            //         ? AppColors.primary
                            //         : Colors.grey,
                            //     thickness: 1)
                          ],
                        ),
                      )
                    : widget.prefixAsset != null
                        ? SizedBox(
                            width: 40.sp,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  widget.prefixAsset!,
                                  height: 20.sp,
                                  width: 20.sp,
                                  color: _hasFocus
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                )
                              ],
                            ),
                          )
                        : widget.prefixWidget,
                suffixIcon: widget.hasDropdown || widget.suffixWidget != null
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [widget.suffixWidget!],
                            ),
                            // VerticalDivider(
                            //     color: _hasFocus
                            //         ? AppColors.primary
                            //         : Colors.grey,
                            //     thickness: 1)
                          ],
                        ),
                      )
                    : widget.suffixWidget,
                labelText: widget.showLabel ? widget.label : '',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                filled: widget.filled,
                fillColor: widget.fillColor,
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.isSearch ? 10.sp : 15.sp,
                    horizontal: widget.isSearch ? 10.sp : 12.sp),
                floatingLabelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                labelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                // label:widget.isNumber?Align(
                // alignment: Alignment.center,child: customText(widget.label) ): customText(widget.label),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: BorderSide(
                      color: widget.isSearch
                          ? AppColors.transparent
                          : AppColors.greyColor.withOpacity(0.3),
                      width: widget.isSearch ? 0 : 0.5),
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: BorderSide(
                      color: widget.isSearch
                          ? widget.color
                          : AppColors.greyColor.withOpacity(0.3),
                      width: widget.isSearch ? 0.5 : 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: BorderSide(
                      color:
                          widget.isSearch ? widget.color : AppColors.redColor,
                      width: widget.isSearch ? 0.5 : 0.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
        ],
      ),
    );
  }
}

class ClickableCustomRoundedInputField extends StatefulWidget {
  final String label;
  final String title;
  final Color titleColor;
  final int maxLines;
  final TextAlign textAlign;
  final List<TextInputFormatter>? formatter;
  final TextEditingController? controller;
  final Color color;
  final Color labelColor;
  final Color cursorColor;
  final Color fillColor;
  final Color textColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? regex;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final Function(dynamic)? onChanged;
  final VoidCallback? onPressed;
  final bool isRequired;
  final bool isNumber;
  final bool isSearch;
  final String? prefixAsset;
  final String? Function(String?)? validator;
  final bool useCustomValidator;
  final bool isPhone;
  final bool readOnly;
  final bool showLabel;
  final bool hasDropdown;
  final bool hasTitle;
  final double fontSize;
  final double labelFontSize;
  final EdgeInsets edgeInsets;

  const ClickableCustomRoundedInputField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.hasDropdown = false,
    this.title = "",
    this.isPhone = false,
    this.isSearch = false,
    this.showLabel = false,
    this.useCustomValidator = false,
    this.validator,
    this.onPressed,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    this.cursorColor = AppColors.disabledColor,
    this.fillColor = AppColors.textFieldBackgroundColor,
    this.color = AppColors.disabledColor,
    this.textColor = AppColors.blackColor,
    this.titleColor = AppColors.blackColor,
    this.labelColor = AppColors.obscureTextColor,
    this.obscureText = false,
    this.hasTitle = false,
    this.formatter,
    this.prefixWidget,
    this.prefixAsset,
    this.onChanged,
    this.regex,
    this.suffixWidget = const SizedBox.shrink(),
    this.fontSize = 14,
    this.labelFontSize = 14,
    this.isRequired = true,
    this.isNumber = false,
    this.readOnly = false,
    this.edgeInsets = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<ClickableCustomRoundedInputField> createState() =>
      _ClickableCustomRoundedInputFieldState();
}

class _ClickableCustomRoundedInputFieldState
    extends State<ClickableCustomRoundedInputField> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasTitle
              ? customText(
                  widget.title,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.labelFontSize.sp,
                  color: widget.titleColor,
                )
              : const SizedBox.shrink(),
          SizedBox(height: widget.hasTitle ? 5.sp : 0.sp),
          Focus(
            onFocusChange: (hasFocus) {
              _hasFocus = hasFocus;
              setState(() {});
            },
            child: TextFormField(
              readOnly: widget.readOnly,
              // textAlign: widget.isCurrency?TextAlign.center:TextAlign.left,
              textAlign: widget.textAlign,
              onTap: () {
                widget.onPressed!.call();
              },
              cursorColor: widget.cursorColor,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              minLines: 1,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatter,
              onChanged: widget.onChanged,
              validator: !widget.isRequired
                  ? null
                  : widget.useCustomValidator
                      ? widget.validator
                      : (value) {
                          if (widget.regex != null) {
                            RegExp regExp = RegExp(
                              widget.regex!,
                              caseSensitive: false,
                              multiLine: false,
                            );
                            if (!regExp.hasMatch(value!)) {
                              return "Invalid ${widget.title}";
                            }
                          }
                          if (value!.isEmpty) {
                            return "${widget.title} field is required";
                          }
                          return null;
                        },
              focusNode: widget.focusNode,
              controller: widget.controller,
              style: widget.isNumber
                  ? TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: widget.textColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp),
              decoration: InputDecoration(
                prefixIcon: widget.isPhone
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 8.sp, bottom: 0.1.sp, top: 2.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        SvgAssets.nigerianFlag,
                                        height: 15.sp,
                                      ),
                                      SizedBox(
                                        width: 3.sp,
                                      ),
                                      customText(
                                        '+234 ',
                                        color: widget.color,
                                        fontSize: widget.labelFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // VerticalDivider(
                            //     color: _hasFocus
                            //         ? AppColors.primary
                            //         : Colors.grey,
                            //     thickness: 1)
                          ],
                        ),
                      )
                    : widget.prefixAsset != null
                        ? SizedBox(
                            width: 40.sp,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  widget.prefixAsset!,
                                  height: 20.sp,
                                  width: 20.sp,
                                  color: _hasFocus
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                )
                              ],
                            ),
                          )
                        : widget.prefixWidget,
                suffixIcon: widget.hasDropdown || widget.suffixWidget != null
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [widget.suffixWidget!],
                            ),
                            // VerticalDivider(
                            //     color: _hasFocus
                            //         ? AppColors.primary
                            //         : Colors.grey,
                            //     thickness: 1)
                          ],
                        ),
                      )
                    : widget.suffixWidget,
                labelText: widget.showLabel ? widget.label : '',
                fillColor: widget.fillColor,
                isDense: true,
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding: EdgeInsets.symmetric(
                    vertical: widget.isSearch ? 10.sp : 15.sp,
                    horizontal: widget.isSearch ? 10.sp : 12.sp),
                floatingLabelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                labelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                // label:widget.isNumber?Align(
                // alignment: Alignment.center,child: customText(widget.label) ): customText(widget.label),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: BorderSide(
                      color: widget.isSearch
                          ? widget.color
                          : AppColors.greyColor.withOpacity(0.3),
                      width: widget.isSearch ? 0.5 : 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide: BorderSide(
                      color: widget.isSearch
                          ? widget.color
                          : AppColors.greyColor.withOpacity(0.3),
                      width: widget.isSearch ? 0.5 : 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.isSearch ? 12.r : 8.r),
                  borderSide:
                      const BorderSide(color: AppColors.redColor, width: 0.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
        ],
      ),
    );
  }
}

class CustomOutlinedRoundedInputField extends StatefulWidget {
  final String label;
  final String title;
  final Color titleColor;
  final int maxLines;
  final List<TextInputFormatter>? formatter;
  final TextEditingController? controller;
  final Color color;
  final Color labelColor;
  final Color cursorColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? regex;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final Function(dynamic)? onChanged;
  final Function(String)? onFieldSubmitted;
  final bool isRequired;
  final bool isCurrency;
  final bool isSearch;
  final String? authPrefix;
  final String? Function(String?)? validator;
  final bool useCustomValidator;
  final bool isPhone;
  final bool readOnly;
  final bool hasDropdown;
  final bool hasTitle;
  final bool autoFocus;
  final double fontSize;
  final double labelFontSize;
  final EdgeInsets edgeInsets;
  final double borderRadius; // New parameter for customizable border radius

  const CustomOutlinedRoundedInputField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.hasDropdown = false,
    this.autoFocus = false,
    this.title = "",
    this.isPhone = false,
    this.isSearch = false,
    this.useCustomValidator = false,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.cursorColor = AppColors.disabledColor,
    this.color = AppColors.disabledColor,
    this.titleColor = AppColors.disabledColor,
    this.labelColor = AppColors.obscureTextColor,
    this.obscureText = false,
    this.hasTitle = false,
    this.formatter,
    this.prefixWidget,
    this.authPrefix,
    this.onChanged,
    this.onFieldSubmitted,
    this.regex,
    this.suffixWidget = const SizedBox.shrink(),
    this.fontSize = 14,
    this.labelFontSize = 14,
    this.isRequired = true,
    this.isCurrency = false,
    this.readOnly = false,
    this.edgeInsets = const EdgeInsets.all(0),
    this.borderRadius = 8.0, // Default border radius
  }) : super(key: key);

  @override
  State<CustomOutlinedRoundedInputField> createState() =>
      _CustomOutlinedRoundedInputFieldState();
}

class _CustomOutlinedRoundedInputFieldState
    extends State<CustomOutlinedRoundedInputField> {
  bool _hasFocus = false;

  double get _effectiveBorderRadius {
    // If isSearch is true, use 22.r, otherwise use the custom borderRadius
    return  widget.borderRadius.r;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasTitle
              ? customText(widget.title,
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: widget.titleColor)
              : const SizedBox.shrink(),
          SizedBox(height: widget.hasTitle ? 5.sp : 0.sp),
          Focus(
            onFocusChange: (hasFocus) {
              _hasFocus = hasFocus;
              setState(() {});
            },
            child: TextFormField(
              readOnly: widget.readOnly,
              // textAlign: widget.isCurrency?TextAlign.center:TextAlign.left,
              cursorColor: widget.cursorColor,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              minLines: 1,
              keyboardType: widget.keyboardType,
              textInputAction: widget.isSearch ? TextInputAction.search : TextInputAction.done,
              inputFormatters: widget.formatter,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onFieldSubmitted,
              validator: !widget.isRequired
                  ? null
                  : widget.useCustomValidator
                  ? widget.validator
                  : (value) {
                if (widget.regex != null) {
                  RegExp regExp = RegExp(
                    widget.regex!,
                    caseSensitive: false,
                    multiLine: false,
                  );
                  if (!regExp.hasMatch(value!)) {
                    return "Invalid ${widget.title}";
                  }
                }
                if (value!.isEmpty) {
                  return "${widget.title} field is required";
                }
                return null;
              },
              focusNode: widget.focusNode,
              controller: widget.controller,
              autofocus: widget.autoFocus,
              style: widget.isCurrency
                  ? TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: widget.fontSize.sp,
                  fontWeight: FontWeight.bold)
                  : TextStyle(
                  color: widget.color,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontSize: widget.fontSize.sp),
              decoration: InputDecoration(
                  prefixIcon: widget.isPhone
                      ? IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.sp, bottom: 1.65.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    SvgAssets.nigerianFlag,
                                    height: 15.sp,
                                  ),
                                  SizedBox(
                                    width: 3.sp,
                                  ),
                                  customText(
                                    '+234 ',
                                    color: widget.color,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // VerticalDivider(
                        //     color: _hasFocus
                        //         ? AppColors.primary
                        //         : Colors.grey,
                        //     thickness: 1)
                      ],
                    ),
                  )
                      : widget.authPrefix != null
                      ? Container(
                    width: 40.sp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          widget.authPrefix!,
                          height: 20.sp,
                          width: 20.sp,
                          color: _hasFocus
                              ? AppColors.primaryColor
                              : Colors.grey,
                        )
                      ],
                    ),
                  )
                      : widget.prefixWidget,
                  suffixIcon: widget.hasDropdown || widget.suffixWidget != null
                      ? IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 12.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [widget.suffixWidget!],
                          ),
                        ),
                        // VerticalDivider(
                        //     color: _hasFocus
                        //         ? AppColors.primary
                        //         : Colors.grey,
                        //     thickness: 1)
                      ],
                    ),
                  )
                      : widget.suffixWidget,
                  labelText: widget.label,
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: widget.isSearch ? 10.sp : 18.sp,
                      horizontal: widget.isSearch ? 10.sp : 12.sp),
                  floatingLabelStyle: TextStyle(
                    color: widget.labelColor,
                    fontSize: widget.labelFontSize.sp,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  labelStyle: TextStyle(
                    color: widget.labelColor,
                    fontSize: widget.labelFontSize.sp,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_effectiveBorderRadius),
                    borderSide: BorderSide(color: widget.color, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_effectiveBorderRadius),
                    borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.5), width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_effectiveBorderRadius),
                    borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.5), width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_effectiveBorderRadius),
                    borderSide:
                    const BorderSide(color: AppColors.redColor, width: 0.5),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomOutlinedRoundedPhoneInputField extends StatefulWidget {
  final String label;
  final String title;
  final Color titleColor;
  final List<TextInputFormatter>? formatter;
  final TextEditingController? controller;
  final Color color;
  final Color labelColor;
  final Color cursorColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? regex;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final Function(dynamic)? onChanged;
  final bool isRequired;
  final bool isCurrency;
  final bool isSearch;
  final String? authPrefix;
  final FutureOr<String?> Function(PhoneNumber?) validator;
  final bool isPhone;
  final bool readOnly;
  final bool hasDropdown;
  final bool hasTitle;
  final double fontSize;
  final double labelFontSize;
  final EdgeInsets edgeInsets;

  const CustomOutlinedRoundedPhoneInputField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.hasDropdown = false,
    this.title = "",
    this.isPhone = false,
    this.isSearch = false,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.cursorColor = AppColors.disabledColor,
    this.color = AppColors.disabledColor,
    this.titleColor = AppColors.disabledColor,
    this.labelColor = AppColors.obscureTextColor,
    this.obscureText = false,
    this.hasTitle = false,
    this.formatter,
    this.prefixWidget,
    this.authPrefix,
    this.onChanged,
    this.regex,
    this.suffixWidget = const SizedBox.shrink(),
    this.fontSize = 14,
    this.labelFontSize = 14,
    this.isRequired = true,
    this.isCurrency = false,
    this.readOnly = false,
    this.edgeInsets = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<CustomOutlinedRoundedPhoneInputField> createState() =>
      _CustomOutlinedRoundedPhoneInputFieldState();
}

class _CustomOutlinedRoundedPhoneInputFieldState
    extends State<CustomOutlinedRoundedPhoneInputField> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasTitle
              ? customText(widget.title,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: widget.titleColor)
              : const SizedBox.shrink(),
          SizedBox(height: widget.hasTitle ? 5.sp : 0.sp),
          Focus(
            onFocusChange: (hasFocus) {
              _hasFocus = hasFocus;
              setState(() {});
            },
            child: IntlPhoneField(
              readOnly: widget.readOnly,
              // textAlign: widget.isCurrency?TextAlign.center:TextAlign.left,
              cursorColor: widget.cursorColor,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatter,
              onChanged: widget.onChanged,
              languageCode: "en",
              countries: [
                countries.firstWhere((Country c) => c.name == "Nigeria"),
              ],
              initialCountryCode:
                  countries.firstWhere((Country c) => c.name == "Nigeria").code,
              showCountryFlag: true,
              validator: !widget.isRequired ? null : widget.validator,
              focusNode: widget.focusNode,
              controller: widget.controller,
              style: widget.isCurrency
                  ? TextStyle(
                      color: AppColors.primaryColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: widget.color,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp),
              decoration: InputDecoration(
                  prefixIcon: widget.isPhone
                      ? IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8.sp, bottom: 1.65.sp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          SvgAssets.nigerianFlag,
                                          height: 15.sp,
                                        ),
                                        SizedBox(
                                          width: 3.sp,
                                        ),
                                        customText(
                                          '+234 ',
                                          color: widget.color,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // VerticalDivider(
                              //     color: _hasFocus
                              //         ? AppColors.primary
                              //         : Colors.grey,
                              //     thickness: 1)
                            ],
                          ),
                        )
                      : widget.authPrefix != null
                          ? Container(
                              width: 40.sp,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    widget.authPrefix!,
                                    height: 20.sp,
                                    width: 20.sp,
                                    color: _hasFocus
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                  )
                                ],
                              ),
                            )
                          : widget.prefixWidget,
                  suffixIcon: widget.hasDropdown || widget.suffixWidget != null
                      ? IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 12.sp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [widget.suffixWidget!],
                                ),
                              ),
                              // VerticalDivider(
                              //     color: _hasFocus
                              //         ? AppColors.primary
                              //         : Colors.grey,
                              //     thickness: 1)
                            ],
                          ),
                        )
                      : widget.suffixWidget,
                  labelText: widget.label,
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: widget.isSearch ? 10.sp : 18.sp,
                      horizontal: widget.isSearch ? 10.sp : 12.sp),
                  floatingLabelStyle: TextStyle(
                    color: widget.labelColor,
                    fontSize: widget.labelFontSize.sp,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  labelStyle: TextStyle(
                    color: widget.labelColor,
                    fontSize: widget.labelFontSize.sp,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.isSearch ? 22.r : 8.r),
                    borderSide: BorderSide(color: widget.color, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.isSearch ? 22.r : 8.r),
                    borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3), width: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.isSearch ? 22.r : 8.r),
                    borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3), width: 0.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(widget.isSearch ? 22.r : 8.r),
                    borderSide:
                        const BorderSide(color: AppColors.redColor, width: 0.5),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRoundedPhoneInputField extends StatefulWidget {
  final String label;
  final String title;
  final Color titleColor;
  final TextAlign textAlign;
  final List<TextInputFormatter>? formatter;
  final TextEditingController? controller;
  final Color color;
  final Color labelColor;
  final Color fillColor;
  final Color cursorColor;
  final Color textColor;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? regex;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final Function(PhoneNumber)? onChanged;
  final bool isRequired;
  final bool disableLengthCheck;
  final bool isNumber;
  final bool filled;
  final String? prefixAsset;
  final FutureOr<String?> Function(PhoneNumber?) validator;
  final bool isPhone;
  final bool readOnly;
  final bool showLabel;
  final bool hasDropdown;
  final bool hasTitle;
  final double fontSize;
  final double labelFontSize;
  final EdgeInsets edgeInsets;

  const CustomRoundedPhoneInputField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.hasDropdown = false,
    this.filled = true,
    this.title = "",
    this.isPhone = false,
    this.showLabel = false,
    this.disableLengthCheck = true,
    required this.validator,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    this.cursorColor = AppColors.disabledColor,
    this.fillColor = AppColors.textFieldBackgroundColor,
    this.color = AppColors.disabledColor,
    this.textColor = AppColors.blackColor,
    this.titleColor = AppColors.blackColor,
    this.labelColor = AppColors.obscureTextColor,
    this.obscureText = false,
    this.hasTitle = false,
    this.formatter,
    this.prefixWidget,
    this.prefixAsset,
    this.onChanged,
    this.regex,
    this.suffixWidget = const SizedBox.shrink(),
    this.fontSize = 14,
    this.labelFontSize = 14,
    this.isRequired = true,
    this.isNumber = false,
    this.readOnly = false,
    this.edgeInsets = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  State<CustomRoundedPhoneInputField> createState() =>
      _CustomRoundedPhoneInputFieldState();
}

class _CustomRoundedPhoneInputFieldState
    extends State<CustomRoundedPhoneInputField> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.hasTitle
              ? customText(
                  widget.title,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.labelFontSize.sp,
                  color: widget.titleColor,
                )
              : const SizedBox.shrink(),
          SizedBox(height: widget.hasTitle ? 5.sp : 0.sp),
          Focus(
            onFocusChange: (hasFocus) {
              _hasFocus = hasFocus;
              setState(() {});
            },
            child: IntlPhoneField(
              readOnly: widget.readOnly,
              showCountryFlag:true,
              disableLengthCheck:widget.disableLengthCheck,
              textAlign: TextAlign.left,
              cursorColor: widget.cursorColor,
              showDropdownIcon: false,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.formatter,
              onChanged: widget.onChanged,
              languageCode: "en",
              countries: [
                countries.firstWhere((Country c) => c.name == "Nigeria"),
              ],
              initialCountryCode:
                  countries.firstWhere((Country c) => c.name == "Nigeria").code,
              validator:  widget.validator,
              focusNode: widget.focusNode,
              controller: widget.controller,
              style: widget.isNumber
                  ? TextStyle(
                      color: AppColors.blackColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: widget.textColor,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: widget.fontSize.sp),
              decoration: InputDecoration(
                prefixIcon: widget.prefixAsset != null
                        ? SizedBox(
                            width: 40.sp,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  widget.prefixAsset!,
                                  height: 20.sp,
                                  width: 20.sp,
                                  color: _hasFocus
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                )
                              ],
                            ),
                          )
                        : widget.prefixWidget,
                suffixIcon: widget.hasDropdown || widget.suffixWidget != null
                    ? IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [widget.suffixWidget!],
                            ),
                            // VerticalDivider(
                            //     color: _hasFocus
                            //         ? AppColors.primary
                            //         : Colors.grey,
                            //     thickness: 1)
                          ],
                        ),
                      )
                    : widget.suffixWidget,
                labelText: widget.showLabel ? widget.label : '',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                isDense: true,
                filled: widget.filled,
                fillColor: widget.fillColor,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.sp, horizontal: 12.sp),
                floatingLabelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                labelStyle: TextStyle(
                  color: widget.labelColor,
                  fontSize: widget.labelFontSize.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                      BorderSide(color: AppColors.greyColor.withOpacity(0.3), width: 0.5),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                      BorderSide(color: AppColors.greyColor.withOpacity(0.3), width: 0.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.redColor, width: 0.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.sp,
          ),
        ],
      ),
    );
  }
}
