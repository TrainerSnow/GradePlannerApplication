import 'package:f_logs/model/flog/flog.dart';
import 'package:f_logs/model/flog/log.dart';
import 'package:flutter/material.dart';

class ScreenViewLogs extends StatelessWidget {
  final String title;

  const ScreenViewLogs({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Log>>(
            future: FLog.getAllLogs(),
            builder: (context, shot) {
              if (shot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (int i = 0; i < shot.data!.length; i++) Text("(${i + 1}) ${shot.data![i].text}\n")],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ));
  }
}
