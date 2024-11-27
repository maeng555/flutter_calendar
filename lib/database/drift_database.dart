import 'package:drift/drift.dart';
import 'package:card/model/schedule.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
part 'drift_database.g.dart';

@DriftDatabase(tables: [Schedules,],)
class LocalDatebase extends _$LocalDatebase{
  LocalDatebase(): super(_openConnection());
  Stream<List<Schedule>> watchSchedules(DateTime date)=>
      (select(schedules)..where((tbl)=>tbl.date.equals(date))).watch();
  Future<int> createSchedule(SchedulesCompanion data)=>
      into(schedules).insert(data);
  Future<int> removeSchedule(int id)=>
      (delete(schedules)..where((tbl)=>tbl.id.equals(id))).go();

  @override
  int get schemaVersion =>1;
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async{
    final dbFolder = await getApplicationCacheDirectory();

    final file = File(p.join(dbFolder.path,'db.sqlite'));
    return NativeDatabase(file);
  });
}