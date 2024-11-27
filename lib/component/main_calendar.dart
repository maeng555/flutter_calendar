import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:card/const/colors.dart';

class MainCalendar extends StatelessWidget{
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;
  MainCalendar({
    required this.onDaySelected,
    required this.selectedDate,
  });
  @override
  Widget build(BuildContext context) {

    return TableCalendar(
      locale: 'ko_kr',
      onDaySelected: onDaySelected,  // ➌ 날짜 선택 시 실행할 함수
      selectedDayPredicate: (date) =>  // ➍ 선택된 날짜를 구분할 로직
      date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      firstDay: DateTime(1800, 1, 1),  // ➊ 첫째 날
      lastDay: DateTime(2200, 12, 31),   // ➋ 마지막 날
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle(  // ➊ 달력 최상단 스타일
        titleCentered: true,  // 제목 중앙에 위치하기
        formatButtonVisible: false,  // 달력 크기 선택 옵션 없애기
        titleTextStyle: TextStyle(  // 제목 글꼴
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(  // ➋ 기본 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration(  // ➌ 주말 날짜 스타일
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
      ),

    );
  }
}