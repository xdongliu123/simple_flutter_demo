import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mes_flutter/assets/assets.dart';
import 'package:mes_flutter/data/models/components_line/component_shift_model.dart';
import 'package:mes_flutter/utils/widgetUtil.dart';
import 'shift_detail_component.dart';

class ShiftDetailPage extends HookConsumerWidget {
  final ComShiftChangeRecord model;
  ShiftDetailPage(this.model, {Key? key}) : super(key: key);

  bool get isDayShift {
    return model.shift == null || model.shift == "D";
  }

  bool get isFinishState {
    return model.state == 2;
  }

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        appBar: customAppBar('详情'),
        backgroundColor: Color(0xFFF3F5F9),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 20.w,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: Container(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              "${model.segmentCode ?? ''}/${model.segmentName ?? ''}",
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
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
                        Container(
                          child: ShiftDetailComponent(model),
                        )
                      ],
                    )),
              ),
            ]),
          )),
          Container(
            height: 100.w,
            color: Colors.white,
            child: Row(
              children: [
                Spacer(),
                Container(
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
                      onPressed: () {}),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
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
                      onPressed: () {}),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ])));
  }
}
