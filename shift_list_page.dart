import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mes_flutter/utils/widgetUtil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_drawer/simple_drawer.dart';
import '../../data/models/components_line/component_shift_model.dart';
import '../../data/models/modshift_segment_dic_list.dart';
import '../../data/network/api_client.dart';
import '../../utils/date_util.dart';
import '../widgets/toast.dart';
import 'shift_detail_page.dart';
import 'shift_filter_panel.dart';
import 'shift_list_cell.dart';

class ShiftListPage extends HookConsumerWidget {
  ShiftListPage({Key? key}) : super(key: key);
  String? start;
  String? end;
  String? diffs;
  String? segment;
  String? shift;

  var pageNum = 0;
  final pageSize = 10;
  List<ComShiftChangeRecord> loadedData = [];
  List<ModshiftSegmentDicList> segments = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context, ref) {
    final showFilter = useState(false);
    final reload = useState(null);
    ValueNotifier<List<ModshiftSegmentDicList>> segmentStore = useState([]);

    useEffect(() {
      getShiftRecordList(context, reload, showLoading: true);
      getSegmentList(context, segmentStore);
      return () => {};
    }, []);

    return Scaffold(
      appBar: customAppBar('交接班记录', actions: [
        Container(
          margin: EdgeInsets.only(right: 32.w),
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  Text(
                    !showFilter.value ? "筛选" : "",
                    style: TextStyle(
                      color: const Color(0XFF999999),
                      fontSize: 28.0.sp,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: Image.asset(
                      !showFilter.value
                          ? 'assets/png/filter_icon.webp'
                          : 'assets/png/close_icon.webp',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              if (showFilter.value) {
                SimpleDrawer.deactivate("filter_panel");
              } else {
                SimpleDrawer.activate("filter_panel");
              }
              showFilter.value = !showFilter.value;
            },
          ),
        ),
      ]),
      backgroundColor: Color(0xFFF3F5F9),
      body: Stack(children: [
        Column(children: [
          Container(
            height: 20.w,
          ),
          Expanded(
              child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("上拉加载更多");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败，再试一次");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("松手加载更多");
                } else {
                  body = Text("没有更多数据");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            header: WaterDropHeader(),
            onRefresh: () async {
              reloadData(context, reload);
            },
            onLoading: () async {
              await getShiftRecordList(context, reload);
              reload.notifyListeners();
            },
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: loadedData.length,
                itemBuilder: (_, index) {
                  return ShiftListCell(
                    loadedData[index],
                    onViewTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShiftDetailPage(loadedData[index])),
                      );
                    },
                    onEditTap: () {},
                    onDeleteTap: () {
                      showDeleteDialog(context, loadedData[index].shiftId, reload);
                    },
                    onQcTap: () {
                      showConfirmDialog(context, loadedData[index].shiftId, reload);
                    },
                  );
                }),
          )),
        ]),
        SimpleDrawer(
          child: showFilter.value ? ShiftFilterPanel(
            start: start,
            end: end,
            diffs: diffs,
            shift: shift,
            segment: segment,
            segments:
                segmentStore.value.map((e) => e.segmentName ?? "").toList(),
            onConfirm: (
                {String? newStart,
                String? newEnd,
                String? newDiffs,
                String? newShift,
                String? newProcedule}) {
              start = newStart;
              end = newEnd;
              diffs = newDiffs;
              shift = newShift;
              segment = newProcedule;
              SimpleDrawer.deactivate("filter_panel");
              reloadData(context, reload);
            },
          ) : Container(),
          childHeight: 1000.w,
          direction: Direction.top,
          id: "filter_panel",
          animationDurationInMilliseconds: 200,
          onDrawerStatusChanged: (status) {
            //解决点击panel透明背景消失，导航栏右上角图标不正确问题
            if (status == DrawerStatus.inactive) {
              showFilter.value = false;
            }
          },
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        //mini: true,
        ///长按提示
        tooltip: "",

        ///设置悬浮按钮的背景
        backgroundColor: Colors.white,

        ///获取焦点时显示的颜色
        focusColor: Colors.white,

        ///鼠标悬浮在按钮上时显示的颜色
        hoverColor: Colors.white,

        ///水波纹颜色
        splashColor: Colors.lightBlueAccent,

        ///定义前景色 主要影响文字的颜色
        foregroundColor: Colors.red,
        shape: CircleBorder(
          side: BorderSide(
              color: Colors.red, width: 6.w, style: BorderStyle.solid),
        ),

        ///配制阴影高度 未点击时
        elevation: 0.0,

        ///配制阴影高度 点击时
        highlightElevation: 0.0,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }

  Future<void> getSegmentList(
    context,
    ValueNotifier<List<ModshiftSegmentDicList>> segmentStore,
  ) async {
    try {
      final response = await apiClient.modshiftSegment();
      if (response.code == 200) {
        segments = response.data ?? [];
        segmentStore.value = response.data ?? [];
      }
    } catch (err, stack) {
      print(err);
    }
  }

  void reloadData(context, reload) {
    pageNum = 0;
    loadedData.clear();
    getShiftRecordList(context, reload, showLoading: true);
  }

  Future<void> getShiftRecordList(context, ValueNotifier<void> reloadTrigger,
      {bool showLoading = false}) async {
    if (showLoading) {
      EasyLoading.show(
        status: '加载中...',
        maskType: EasyLoadingMaskType.clear,
      );
    }
    try {
      ModshiftSegmentDicList? selectSegment;
      if (segment != null && segment!.isNotEmpty) {
        selectSegment =
            segments.firstWhere((element) => element.segmentName == segment);
      }
      var formatShift = "";
      if (shift == "白班") {
        formatShift = "D";
      } else if (shift == "夜班") {
        formatShift = "N";
      }
      final response = await apiClient.getComShiftRecordList({
        "pageNum": pageNum,
        "pageSize": pageSize,
        "startDate": start ?? "",
        "endDate": end ?? "",
        "shift": formatShift,
        "segmentCode": selectSegment?.segmentCode ?? "",
        "segmentName": selectSegment?.segmentName ?? "",
      });
      if (response.code == 200) {
        final shiftList = response.data?.data ?? [];
        loadedData.addAll(shiftList);
        if (shiftList.length < pageSize) {
          _refreshController.loadNoData();
        } else {
          pageNum += 1;
          _refreshController.loadComplete();
        }
      } else {
        _refreshController.loadFailed();
      }
    } catch (err, stack) {
      _refreshController.loadFailed();
      print(err);
    }
    if (showLoading) {
      EasyLoading.dismiss();
    }
    _refreshController.refreshCompleted();
    reloadTrigger.notifyListeners();
  }

  showDeleteDialog(
      context,
      int? shiftId,
      ValueNotifier<void> reloadTrigger,
      ) {
    showConfirmCancelDialog(context, "警告!", "确认删除这条记录？", confirmHandler: () {
      deleteShiftRecord(shiftId, reloadTrigger);
    });
  }

  showConfirmDialog(
      context,
      int? shiftId,
      ValueNotifier<void> reloadTrigger,
      ) {
    showConfirmCancelDialog(context, "提示!", "你确认进行交接吗？", confirmHandler: () {
      confirmShiftRecord(shiftId, reloadTrigger);
    });
  }

  Future<void> deleteShiftRecord(
      int? shiftId,
      ValueNotifier<void> reloadTrigger,
      ) async {
    EasyLoading.show(status: '正在删除...');
    try {
      final response = await apiClient.deleteShiftRecord({"shiftId": shiftId});
      if (response.code == 200) {
        Toast.show("删除成功");
        loadedData.removeWhere(
                (element) => element.shiftId == shiftId);
        reloadTrigger.notifyListeners();
      } else {
        Toast.show("删除失败：${response.msg}");
      }
    } catch (err, stack) {
      Toast.show("删除失败：${err}");
    }
    EasyLoading.dismiss();
  }

  Future<void> confirmShiftRecord(
      int? shiftId,
      ValueNotifier<void> reloadTrigger,
      ) async {
    EasyLoading.show(status: '正在确认...');
    try {
      final response = await apiClient.confirmShiftRecord({"shiftId": shiftId, "state": 2});
      if (response.code == 200) {
        Toast.show("确认交接成功");
        final record = loadedData.firstWhereOrNull(
                (element) => element.shiftId == shiftId);
        record?.state = 2;
        reloadTrigger.notifyListeners();
      } else {
        Toast.show("确认失败：${response.msg}");
      }
    } catch (err, stack) {
      Toast.show("确认失败：${err}");
    }
    EasyLoading.dismiss();
  }
}
