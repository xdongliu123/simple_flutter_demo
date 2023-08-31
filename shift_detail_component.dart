import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mes_flutter/data/models/components_line/component_shift_model.dart';

class ShiftDetailComponent extends HookConsumerWidget {
  final ComShiftChangeRecord model;
  ShiftDetailComponent(this.model, {Key? key}) : super(key: key);

  List<ComShiftChangeItem> get shiftItems {
    return model.shiftItemList ?? [];
  }

  @override
  Widget build(BuildContext context, ref) {
    return Column(children: [
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Color(0xFFF7F7F7),
        ),
        margin: EdgeInsets.symmetric(vertical: 10.w),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '交班人 ',
                      style:
                          TextStyle(color: Color(0xFF999999), fontSize: 25.sp),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.updateBy ?? '',
                      style:
                          TextStyle(color: Color(0xFF333333), fontSize: 25.sp),
                    )
                  ],
                )),
                flex: 1,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '交班时间 ',
                      style:
                          TextStyle(color: Color(0xFF999999), fontSize: 25.sp),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.updateTime ?? '',
                      style:
                          TextStyle(color: Color(0xFF333333), fontSize: 25.sp),
                    )
                  ],
                )),
                flex: 1,
              ),
            ]),
            SizedBox(
              height: 12,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '接班人 ',
                      style:
                          TextStyle(color: Color(0xFF999999), fontSize: 25.sp),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.confirmBy ?? '',
                      style:
                          TextStyle(color: Color(0xFF333333), fontSize: 25.sp),
                    )
                  ],
                )),
                flex: 1,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '接班时间 ',
                      style:
                          TextStyle(color: Color(0xFF999999), fontSize: 25.sp),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.confirmTime ?? '',
                      style:
                          TextStyle(color: Color(0xFF333333), fontSize: 25.sp),
                    )
                  ],
                )),
                flex: 1,
              ),
            ]),
          ],
        ),
      ),
      Visibility(
          visible: shiftItems.length > 0,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Color(0xFFF7F7F7),
            ),
            margin: EdgeInsets.symmetric(vertical: 10.w),
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: shiftItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final item = shiftItems[index];
                  return Container(
                    child: Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '${index + 1}.订单：${item.orderNo ?? ''}',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                flex: 1,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '产量 ',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Container(
                                child: Text(
                                  item.qtyYield?.toStringAsFixed(2) ?? '',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 25.sp),
                                ),
                              )),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'BOM物料 ',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '${item.matCode ?? ''}/${item.matName ?? ''}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '单位',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    item.uomName ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    'BOM单耗',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '200元/千克',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '损耗',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    item.loss?.toStringAsFixed(2) ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '邻料数',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    item.qtyReceive?.toStringAsFixed(2) ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        SizedBox(
                          height: 10.w,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    '结余数',
                                    style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 1,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    item.qtyResidue?.toStringAsFixed(2) ?? '',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Color(0xFF999999),
                                        fontSize: 25.sp),
                                  ),
                                ),
                                flex: 2,
                              ),
                            ]),
                        if (index != shiftItems.length - 1)
                          Container(
                            child: Divider(
                              height: 1,
                              thickness: 0.5,
                            ),
                            margin: EdgeInsets.all(20.w),
                          )
                      ],
                    ),
                  );
                }),
          ))
    ]);
  }
}
