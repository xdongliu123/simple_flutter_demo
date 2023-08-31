import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mes_flutter/data/models/components_line/component_shift_model.dart';

import '../../assets/assets.dart';
import '../../utils/widgetUtil.dart';
import '../../widgets/expand_collapse_button.dart';

class ShiftListCell extends HookConsumerWidget {
  ShiftListCell(this.model,
      {Key? key,
      required this.onViewTap,
      this.onEditTap,
      this.onQcTap,
      this.onDeleteTap})
      : super(key: key);
  final ComShiftChangeRecord model;
  final Function? onViewTap;
  final Function? onEditTap;
  final Function? onDeleteTap;
  final Function? onQcTap;

  bool get isDayShift {
    return model.shift == null || model.shift == "D";
  }

  bool get isFinishState {
    return model.state == 2;
  }

  @override
  Widget build(BuildContext context, ref) {
    ValueNotifier<bool> expandState = useState(true);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text("${model.segmentCode ?? ''}/${model.segmentName ?? ''}",
                      style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                      maxLines: 2,
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isFinishState ? Color(0x1A18B681) : Color(0x1A588CE9),
                        ),
                        child: Text(
                          isFinishState ? '完成' : '新建',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: isFinishState ? Color(0xFF18B681) : Color(0xFF3775E2)),
                        )),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xFFEEEEEF),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: Image.asset(
                                  "assets/images/lajing_icon_time.webp")),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            model.date ?? "",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                            maxLines: 3,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFEEEEEF),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: Image.asset(isDayShift ? Assets.qmSunIcon : Assets.qmMoonIcon)),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            isDayShift ? '白班' : "夜班",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w500),
                            maxLines: 3,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (onViewTap != null) {
                          onViewTap!();
                        }
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              '工序详情',
                              style: TextStyle(
                                  color: Color(0xFF588CE9), fontSize: 24.sp),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xFF588CE9),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ExpandCollapseButton(
                    //   text: '展开',
                    //   initiallyExpanded: true,
                    //   onPressed: (expanded) {
                    //     expandState.value = expanded;
                    //   },
                    //   // 默认展开
                    // ),
                    Spacer(),
                    Visibility(
                      visible: true,
                      child: Container(
                        width: 120.w,
                        height: 60.w,
                        child: roundCornerBtn(
                            Text(
                              '编 辑',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.black,
                              ),
                            ),
                            [
                              Color(0xFFEEEEEF),
                              Color(0xFFEEEEEF),
                              //add more colors
                            ],
                            6,
                            onPressed: () {
                              if (onEditTap != null) {
                                onEditTap!();
                              }
                            }),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Visibility(
                      visible: true,
                      child: Container(
                        width: 120.w,
                        height: 60.w,
                        child: roundCornerBtn(
                            Text(
                              '确 认',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                            [
                              Color(0xFF88909F),
                              Color(0xFF505766),
                            ],
                            6,
                            onPressed: () {
                              if (onQcTap != null) {
                                onQcTap!();
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                // Visibility(
                //     visible: true,
                //     child: Container(
                //       child: ShiftDetailComponent(),
                //     )),
              ],
            )),
        onTap: () {},
      ),
    );
  }
}
