import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 在文件的最顶部，您可以找到 main() 函数。目前，该函数只是告知 Flutter 运行 MyApp 中定义的应用。
///
/// 添加按钮
void main() {
  runApp(MyApp());
}

/// MyApp 类扩展 StatelessWidget。在构建每一个 Flutter 应用时，widget 都是一个基本要素。如您所见，应用本身也是一个 widget
/// 注意：我们稍后将详细解释 StatelessWidget（相对于 StatefulWidget）。
/// MyApp 中的代码设置了整个应用，包括创建应用级状态（稍后会详细介绍）、命名应用、定义视觉主题以及设置“主页” widget，即应用的起点。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: '第一个 App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

/// 接下来，MyAppState 类定义应用的状态。这是您第一次使用 Flutter。
/// 因此，在此 Codelab 中，我们让该类保持简单和专注。
/// 在 Flutter 中，可以采用许多有效的方法来管理应用状态。
/// 其中最容易理解的一种方法就是 ChangeNotifier，也是此应用所采用的方法。
///
/// - MyAppState 定义应用运行所需的数据。现在，其中仅包含一个变量，即通过随机函数生成当前的随机单词对。您稍后将在其中添加代码。
/// - 状态类扩展 ChangeNotifier，这意味着它可以向其他人通知自己的更改。例如，如果当前单词对发生变化，应用中的一些 widget 需要知晓此变化。
/// - 使用 ChangeNotifierProvider 创建状态并将其提供给整个应用（参见上面 MyApp 中的代码）。这样一来，应用中的任何 widget 都可以获取状态。
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  /// 新的 getNext() 方法为 current 重新分配了新的随机 WordPair。
  /// 它还调用 notifyListeners() (ChangeNotifier) 的一个方法），以确保向任何通过 watch 方法跟踪 MyAppState 的对象发出通知。
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

}

/// 最后是 MyHomePage，这是您已经修改过的 widget。下面每个带编号的行均映射到上面代码中相应行编号的注释：
///
///    1. 每个 widget 均定义了一个 build() 方法，每当 widget 的环境发生变化时，系统都会自动调用该方法，以便 widget 始终保持最新状态。
///    2. MyHomePage 使用 watch 方法跟踪对应用当前状态的更改。
///    3. 每个 build 方法都必须返回一个 widget 或（更常见的）嵌套 widget 树。
///       在本例中，顶层 widget 是 Scaffold。您不会在此 Codelab 中使用 Scaffold，但它是一个有用的 widget。
///       在绝大多数真实的 Flutter 应用中都可以找到该 widget。
///    4. Column 是 Flutter 中最基础的布局 widget 之一。
///       它接受任意数量的子项并将这些子项从上到下放在一列中。默认情况下，该列会以可视化形式将其子项置于顶部。
///       您很快就会对其进行更改，使该列居中。
///    5. 您在第一步中更改了此 Text widget。
///    6. 第二个 Text widget 接受 appState，并访问该类的唯一成员 current（这是一个 WordPair）。
///       WordPair 提供了一些有用的 getter，例如 asPascalCase 或 asSnakeCase。
///       此处，我们使用了 asLowerCase。但如果您希望选择其他选项，您现在可以对其进行更改。
///    7. 请注意，Flutter 代码大量使用了尾随逗号。
///       此处并不需要这种特殊的逗号，因为 children 是此特定 Column 参数列表的最后一个（也是唯一一个）成员。
///       不过，在一般情况下，使用尾随逗号是一种不错的选择。
///       尾随逗号可大幅减小添加更多成员的必要性，并且还可以在 Dart 的自动格式化程序中作为添加换行符的提示。如需了解详细信息，请参阅代码格式。
///
/// 接下来，您会将按钮关联至状态。
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          Text('随机字母:[ ${appState.current.asLowerCase} ]'),
          ElevatedButton(
              onPressed: () {
                // 打印到控制台
                print("button pressed!");

                // 调用方法
                appState.getNext();
              },
              child: Text("Next - 下一个随机字母"))
        ],
      ),
    );
  }
}
