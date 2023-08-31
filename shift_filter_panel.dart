import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mes_flutter/utils/widgetUtil.dart';
import 'package:flex_list/flex_list.dart';
import '../../utils/date_util.dart';
import '../../widgets/expand_collapse_button.dart';

class ShiftFilterPanel extends HookConsumerWidget {
  ShiftFilterPanel(
      {Key? key,
      this.start,
      this.end,
      this.diffs,
      this.shift,
      this.segment,
      this.segments,
      this.onConfirm})
      : super(key: key);
  String? start;
  String? end;
  String? diffs;
  String? shift;
  String? segment;
  List<String>? segments;
  void Function(
      {String? newStart,
      String? newEnd,
      String? newDiffs,
      String? newProcedule,
      String? newShift})? onConfirm;
  @override
  Widget build(BuildContext context, ref) {
    final startDate = useState(start ?? "");
    final endDate = useState(end ?? "");
    final diffDays = useState(diffs ?? "");
    final selectShift = useState(shift ?? "");
    final selectProcedule = useState(segment ?? "");

    final bottomBtnWidth = (MediaQuery.of(context).size.width - 80) / 2;
    final scrollMode = useState(false);
    final needMoreBtn = (segments ?? []).length > 10;
    final workProcedules = needMoreBtn && !scrollMode.value
        ? segments!.getRange(0, 9).toList()
        : segments;
    return scrollMode.value && needMoreBtn
        ? Container(
            color: Colors.white,
            height: 700.w,
            child: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      //physics: const NeverScrollableScrollPhysics(),
                      child: construcMain(context,
                          workProcedules: workProcedules,
                          scrollMode: scrollMode,
                          startDate: startDate,
                          endDate: endDate,
                          diffDays: diffDays,
                          selectProcedule: selectProcedule,
                          selectShift: selectShift))),
              SizedBox(
                height: 40.w,
              ),
              constructFooter(bottomBtnWidth,
                  startDate: startDate,
                  endDate: endDate,
                  diffDays: diffDays,
                  selectProcedule: selectProcedule,
                  selectShift: selectShift),
              SizedBox(
                height: 30.w,
              ),
            ]))
        : Container(
            color: Colors.white,
            child: Column(children: [
              Container(
                  child: construcMain(context,
                      workProcedules: workProcedules,
                      scrollMode: scrollMode,
                      startDate: startDate,
                      endDate: endDate,
                      diffDays: diffDays,
                      selectProcedule: selectProcedule,
                      selectShift: selectShift)),
              SizedBox(
                height: 40.w,
              ),
              constructFooter(bottomBtnWidth,
                  startDate: startDate,
                  endDate: endDate,
                  diffDays: diffDays,
                  selectProcedule: selectProcedule,
                  selectShift: selectShift),
              SizedBox(
                height: 30.w,
              ),
            ]));
  }

  Widget construcMain(
    context, {
    required List<String>? workProcedules,
    required ValueNotifier<String> startDate,
    required ValueNotifier<String> endDate,
    required ValueNotifier<String> diffDays,
    required ValueNotifier<String> selectProcedule,
    required ValueNotifier<String> selectShift,
    required ValueNotifier<bool> scrollMode,
  }) {
    final isDayShift = selectShift.value == "白班";
    final isNightShift = selectShift.value == "夜班";
    final needMoreBtn = (segments ?? []).length > 10;
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(25.w),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "日期",
                  style:
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 10.w,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    final formatter = DateFormat("yyyy-MM-dd");
                    showDefaultDatePicker(context, (date) {
                      if (endDate.value.isNotEmpty) {
                        final diff = DateUtil.calculateDifferenceInDays(
                            date, formatter.parse(endDate.value));
                        if (diff < 0) {
                          showSimpleDialog(context, "提示", "开始日期不能小于结束日期");
                          return;
                        }
                        diffDays.value = "${diff}天";
                      }
                      startDate.value = formatter.format(date);
                    });
                  },
                  child: Text(
                      startDate.value.isEmpty ? "开始日期" : startDate.value,
                      style:
                          TextStyle(fontSize: 26.sp, color: Color(0xFF333333))),
                ),
                Spacer(),
                Container(
                  width: 50.w,
                  height: 2.w,
                  color: Color(0xFFD9D9D9),
                ),
                Container(
                  child: Text(diffDays.value),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.w)),
                      border: Border.all(width: 1, color: Color(0xFFD9D9D9))),
                ),
                Container(
                  width: 50.w,
                  height: 2.w,
                  color: Color(0xFFD9D9D9),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    final formatter = DateFormat("yyyy-MM-dd");
                    showDefaultDatePicker(context, (date) {
                      if (startDate.value.isNotEmpty) {
                        final diff = DateUtil.calculateDifferenceInDays(
                            formatter.parse(startDate.value), date);
                        if (diff < 0) {
                          showSimpleDialog(context, "提示", "开始日期不能小于结束日期");
                          return;
                        }
                        diffDays.value = "${diff}天";
                      }
                      endDate.value = formatter.format(date);
                    });
                  },
                  child: Text(endDate.value.isEmpty ? "结束日期" : endDate.value,
                      style:
                          TextStyle(fontSize: 26.sp, color: Color(0xFF333333))),
                ),
              ],
            ),
            SizedBox(
              height: 30.w,
            ),
            Row(
              children: [
                Text(
                  "工序",
                  style:
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Visibility(
                    visible: needMoreBtn,
                    child: ExpandCollapseButton(
                      text: !scrollMode.value ? '更多' : '收起',
                      initiallyExpanded: scrollMode.value,
                      onPressed: (expanded) {
                        scrollMode.value = !scrollMode.value;
                      },
                      // 默认展开
                    )),
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            FlexList(
              horizontalSpacing: 5,
              verticalSpacing: 10,
              children: [
                ...(workProcedules ?? [])
                    .map((e) => SizedBox(
                          height: 50.w,
                          child: Stack(
                            children: [
                              roundCornerBtn(
                                  Text(
                                    e,
                                    style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Color(0xFF333333),
                                        fontWeight: e == selectProcedule.value
                                            ? FontWeight.w700
                                            : FontWeight.normal),
                                  ),
                                  e == selectProcedule.value
                                      ? [
                                          Color(0xFFFFFFFF),
                                          Color(0xFFFFFFFF),
                                        ]
                                      : [
                                          Color(0xFFF3F5F9),
                                          Color(0xFFF3F5F9),
                                        ],
                                  10.r,
                                  borderWidth: 1,
                                  borderColor: e == selectProcedule.value
                                      ? Color(0xFF333333)
                                      : Colors.transparent, onPressed: () {
                                selectProcedule.value = e;
                              }),
                              if (e == selectProcedule.value)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: SizedBox(
                                      width: 30.w,
                                      height: 23.w,
                                      child: Image.asset(
                                          'assets/png/check_tag.webp')),
                                ),
                            ],
                            alignment: Alignment.center,
                          ),
                        ))
                    .toList()
              ],
            ),
            SizedBox(
              height: 30.w,
            ),
            Row(
              children: [
                Text(
                  "班次",
                  style:
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            Row(
              children: [
                SizedBox(
                  height: 50.w,
                  child: Stack(
                    children: [
                      roundCornerBtn(
                          Text(
                            "白班",
                            style: TextStyle(
                                fontSize: 24.sp,
                                color: Color(0xFF333333),
                                fontWeight: isDayShift
                                    ? FontWeight.w700
                                    : FontWeight.normal),
                          ),
                          isDayShift
                              ? [
                                  Color(0xFFFFFFFF),
                                  Color(0xFFFFFFFF),
                                ]
                              : [
                                  Color(0xFFF3F5F9),
                                  Color(0xFFF3F5F9),
                                ],
                          10.r,
                          borderWidth: 1,
                          borderColor: isDayShift
                              ? Color(0xFF333333)
                              : Colors.transparent, onPressed: () {
                        selectShift.value = "白班";
                      }),
                      if (isDayShift)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                              width: 30.w,
                              height: 23.w,
                              child: Image.asset('assets/png/check_tag.webp')),
                        ),
                    ],
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                SizedBox(
                  height: 50.w,
                  child: Stack(alignment: Alignment.center, children: [
                    roundCornerBtn(
                        Text(
                          "夜班",
                          style: TextStyle(
                              fontSize: 24.sp,
                              color: Color(0xFF333333),
                              fontWeight: isNightShift
                                  ? FontWeight.w700
                                  : FontWeight.normal),
                        ),
                        isNightShift
                            ? [
                                Color(0xFFFFFFFF),
                                Color(0xFFFFFFFF),
                              ]
                            : [
                                Color(0xFFF3F5F9),
                                Color(0xFFF3F5F9),
                              ],
                        10.r,
                        borderWidth: 1,
                        borderColor: isNightShift
                            ? Color(0xFF333333)
                            : Colors.transparent, onPressed: () {
                      selectShift.value = "夜班";
                    }),
                    if (isNightShift)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                            width: 30.w,
                            height: 23.w,
                            child: Image.asset('assets/png/check_tag.webp')),
                      ),
                  ]),
                ),
                Spacer()
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget constructFooter(bottomBtnWidth,
      {required ValueNotifier<String> startDate,
      required ValueNotifier<String> endDate,
      required ValueNotifier<String> diffDays,
      required ValueNotifier<String> selectProcedule,
      required ValueNotifier<String> selectShift}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 66.w,
            width: bottomBtnWidth,
            child: roundCornerBtn(
                Text(
                  '重置',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                [
                  Color(0xFFEEEEEF),
                  Color(0xFFEEEEEF),
                  //add more colors
                ],
                6, onPressed: () {
              startDate.value = "";
              endDate.value = "";
              diffDays.value = "";
              selectShift.value = "";
              selectProcedule.value = "";
            }),
          ),
          SizedBox(
            width: 40.w,
          ),
          Container(
            height: 66.w,
            width: bottomBtnWidth,
            child: roundCornerBtn(
                Text(
                  '确认',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                [
                  Color(0xFF88909F),
                  Color(0xFF505766),
                ],
                6, onPressed: () {
              if (onConfirm != null) {
                onConfirm!(
                    newStart: startDate.value,
                    newEnd: endDate.value,
                    newDiffs: diffDays.value,
                    newProcedule: selectProcedule.value,
                    newShift: selectShift.value);
              }
            }),
          ),
        ],
      ),
      height: 70.w,
    );
  }

  void showDefaultDatePicker(
    BuildContext context,
    DateChangedCallback? onSelectDate,
  ) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2015, 1, 1),
        maxTime: DateTime(2100, 1, 1),
        onChanged: (date) {}, onConfirm: (date) {
      onSelectDate!(date);
    }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }
}
