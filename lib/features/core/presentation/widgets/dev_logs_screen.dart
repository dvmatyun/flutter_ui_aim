import 'dart:async';

import 'package:custom_data/custom_data.dart';
import 'package:flutter/material.dart';

final dl = DevLogger();

class DevLogger {
  DevLogger();
  final logs = <String>[];
  final _sw = Stopwatch();

  void log(String message) {
    if (!_sw.isRunning) {
      _sw.start();
    }
    final msgWithTime = '> dev log from app start: [${_sw.elapsedMilliseconds} ms]: $message';
    //l.s(msgWithTime);
    // ignore: avoid_print
    print(msgWithTime);
    logs.add(msgWithTime);
  }

  void clear() {
    logs.clear();
    _sw
      ..stop()
      ..reset();
  }
}

class DevLogsScreen extends StatefulWidget {
  const DevLogsScreen({super.key});

  @override
  State<DevLogsScreen> createState() => _DevLogsScreenState();
}

class _DevLogsScreenState extends State<DevLogsScreen> {
  Timer? refreshTimer;
  List<String>? filteredLogs;

  List<String> get logs => filteredLogs ?? dl.logs;

  @override
  void initState() {
    super.initState();
    refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _setLogs();
    });
    _setLogs();
  }

  void _setLogs() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  final debouncer = DebouncerAim();
  void _onSearchChanged(String value) {
    debouncer.valueChanged(() {
      if (value.isEmpty) {
        filteredLogs = null;
      } else {
        filteredLogs =
            dl.logs.where((element) => element.toLowerCase().contains(value.toLowerCase())).toList(growable: false);
      }
      _setLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Widgets'),
        actions: [
          ElevatedButton.icon(onPressed: dl.logs.clear, label: const Icon(Icons.delete_forever)),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 64),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(logs[index]),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 8,
              right: 8,
              child: TextField(
                onChanged: _onSearchChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
