import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 必须加上这一行。
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 720),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      minimumSize: Size(800, 720));
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Flutter Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blue,
          actionTextColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<String> list = <String>['秒', '分钟', '小时', '天', '周', '年'];

  String _display = "";
  String _dropdownValue = "秒";
  String _dropdownValue2 = "分钟";

  dynamic _transNum(String value) {
    double num = 0;
    if (value.isNotEmpty) {
      num = double.parse(value);
    }

    switch (_dropdownValue) {
      case '秒':
        num = num * 1;
        break;
      case '分钟':
        num = num * 60;
        break;
      case '小时':
        num = num * 60 * 60;
        break;
      case '天':
        num = num * 60 * 60 * 24;
        break;
      case '周':
        num = num * 60 * 60 * 24 * 7;
        break;
      case '年':
        num = num * 60 * 60 * 24 * 365.25;
        break;
      default:
        num = num * 1;
    }

    switch (_dropdownValue2) {
      case '秒':
        num = num / 1;
        break;
      case '分钟':
        num = num / 60;
        break;
      case '小时':
        num = num / 60 / 60;
        break;
      case '天':
        num = num / 60 / 60 / 24;
        break;
      case '周':
        num = num / 60 / 60 / 24 / 7;
        break;
      case '年':
        num = num / 60 / 60 / 24 / 365.25;
        break;
      default:
        num = num / 1;
    }

    if (num == num.toInt()) {
      if (num > 1000000000000000) {
        return num.toInt().toStringAsExponential(6);
      } else {
        return num.toInt().toString();
      }
    }

    if (num > 1000000000000000) {
      return num.toInt().toStringAsExponential(6);
    } else if (num > 1000000) {
      return num.toStringAsFixed(0);
    } else if (num > 100000) {
      return num.toStringAsFixed(1);
    } else if (num > 10000) {
      return num.toStringAsFixed(2);
    } else if (num > 1000) {
      return num.toStringAsFixed(3);
    } else if (num > 100) {
      return num.toStringAsFixed(4);
    } else if (num > 10) {
      return num.toStringAsFixed(5);
    } else if (num > 1) {
      return num.toStringAsFixed(6);
    } else if (num > 0.1) {
      return num.toStringAsFixed(7);
    } else {
      return num.toStringAsFixed(8);
    }
  }

  void _setNum(String value) {
    setState(() {
      if (_display.length >= 15) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('数值长度不能超过15位。'),
            duration: Duration(seconds: 1),
          ),
        );

        return;
      }

      if (_display.isEmpty && value == '0') return;
      _display += value;
    });
  }

  void _clearNum(String value) {
    setState(() {
      _display = '';
    });
  }

  void _deleNum(String value) {
    setState(() {
      if (_display.isNotEmpty) {
        _display = _display.substring(0, _display.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _display == '' ? '0' : _display,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(width: 20),
                DropdownMenu<String>(
                  initialSelection: list.first,
                  width: 100,
                  inputDecorationTheme:
                      const InputDecorationTheme(border: InputBorder.none),
                  onSelected: (String? value) {
                    setState(() {
                      _dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _transNum(_display),
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(width: 20),
                DropdownMenu<String>(
                  initialSelection: list[1],
                  width: 100,
                  inputDecorationTheme:
                      const InputDecorationTheme(border: InputBorder.none),
                  onSelected: (String? value) {
                    setState(() {
                      _dropdownValue2 = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                )
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Btn(num: '0', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: 'C', onPressed: _clearNum),
                const SizedBox(width: 10),
                Btn(num: 'X', onPressed: _deleNum),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Btn(num: '7', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '8', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '9', onPressed: _setNum),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Btn(num: '4', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '5', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '6', onPressed: _setNum),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Btn(num: '1', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '2', onPressed: _setNum),
                const SizedBox(width: 10),
                Btn(num: '3', onPressed: _setNum),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  const Btn({super.key, required this.num, required this.onPressed});

  final String num;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(num),
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          )),
      child: Text(num,
          style: const TextStyle(
            fontSize: 30,
          )),
    );
  }
}
