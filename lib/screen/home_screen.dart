import 'package:card/component/main_calendar.dart';
import 'package:card/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:card/component/schedule_card.dart';
import 'package:card/component/today_banner.dart';
import 'package:card/component/schedule_bottom_sheet.dart';
import 'package:card/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:card/provider/schedule_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/schedule_model.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(  // ➋ 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: PRIMARY_COLOR,
          onPressed: (){
            showModalBottomSheet(context: context,
              isDismissible: true,
              builder: (_)=>ScheduleBottomSheet(
                selectedDate: selectedDate,
              ),isScrollControlled: true);
          },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate,focusedDate)=>onDaySelected(selectedDate,focusedDate,context),
            ),
            SizedBox(height: 8.0,),

            StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance
                  .collection(
                'schedule',
              ).where('date',isEqualTo: '${selectedDate.year}${selectedDate.month}${selectedDate.day}',)
                  .snapshots(),
              builder: (context,snapshot){
                return TodayBanner(selectedDate: selectedDate, count: snapshot.data?.docs.length??0,);
              },
            )

            ,
            Expanded( child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection(
                'schedule',)
                  .where(
                  'date',
                  isEqualTo: '${selectedDate.year}${selectedDate.month}${selectedDate.day}')
              .snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Center(
                    child: Text('일정 정보를 가져오지 못했습니다'),
                  );
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Container();
                }
                final  schedules =snapshot.data!.docs.map(
                    (QueryDocumentSnapshot e)=> ScheduleModel.fromJson(
                      json:  (e.data() as Map<String,dynamic>)
                    ),
                ).toList();
                return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context,index){
                      final schedule = schedules[index];
                      return Dismissible(key: ObjectKey(schedule.id),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (DismissDirection direction){
                        FirebaseFirestore.instance.collection('schedule',).doc(schedule.id).delete();
                          },
                          child: Padding(padding: const EdgeInsets.only(
                      bottom: 8.0 ,left: 8.0, right:8.0),
                      child: ScheduleCard(
                       startTime : schedule.startTime,
                      endTime: schedule.endTime,
                      content: schedule.content,
                      ),),
                      );
                    },
                );
              },
            ),
            )

          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    // ➌ 날짜 선택될 때마다 실행할 함수
   setState(() {
     this.selectedDate =selectedDate;
   });
  }

}