import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 添加功能
/// 提取 widget
/// 教程 https://codelabs.developers.google.cn/codelabs/flutter-codelab-first?hl=zh-cn#5

/// 在文件的最顶部，您可以找到 main() 函数。目前，该函数只是告知 Flutter 运行 MyApp 中定义的应用。
Future<void> main() async {
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

  /// 单词收藏夹
  /// 您在 MyAppState 中添加了一个名为 favorites 的新属性。此属性使用一个空的列表进行初始化，即 []。
  var favorites = <WordPair>[];

  /// 您还添加了一个新方法 toggleFavorite()，
  /// 它可以从收藏夹列表中删除当前单词对（如果已经存在），
  /// 或者添加单词对（如果不存在）。
  /// 在任何一种情况下，代码都会在之后调用 notifyListeners();。
  void toggleFavorite() {
    if (favorites.contains(current)) {
      // 包含
      favorites.remove(current); // 清除
    } else {
      favorites.add(current); // 添加
    }
    notifyListeners(); // 发出通知
  }
}

/// 输入 StatefulWidget，这是一种具有 State 的 widget。首先，将 MyHomePage 转换为有状态 widget。
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// IDE 为您创建了一个新类 _MyHomePageState。
/// 此类扩展 State，因此可以管理其自己的值。
/// （它可以自行改变。）另请注意，
/// 旧版无状态 widget 中的 build 方法已移至 _MyHomePageState（而不是保留在 widget 中）。
/// build 方法会一字不差的完成移动，其内部不会发生任何改变。该方法现在只是换了个位置。
///
/// _MyHomePageState 开始部分的下划线 (_) 将该类设置为私有类，
/// 并由编译器强制执行。
/// 如果想要详细了解 Dart 中私有属性以及其他主题，请参阅语言导览(https://dart.dev/language/libraries)。
class _MyHomePageState extends State<MyHomePage> {
  // 新的有状态 widget 只需要跟踪一个变量，即 selectedIndex。对 _MyHomePageState 进行以下 3 处更改：
  var selectedIndex = 0;

  /// <-1

  /// 下面分析各项更改：
  ///
  ///     您引入了一个新变量 selectedIndex，并将其初始化为 0。
  ///     您在 NavigationRail 定义中使用此新变量，而不再是像之前那样将其硬编码为 0。
  ///     当调用 onDestinationSelected 回调时，并不是仅仅将新值输出到控制台，
  ///     而是将其分配到 setState() 调用内部的 selectedIndex。
  ///     此调用类似于之前使用的 notifyListeners() 方法 — 它会确保界面始终更新为最新状态。

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    /// Flutter 提供了多个 widget，可帮助您为应用赋予自适用性。例如，Wrap 是一个类似于 Row 或 Column 的 widget，当没有足够的垂直或水平空间时，它会自动将子项封装到下一“行”（称为“运行”）中。FittedBox widget 可以自动根据您的规格将其子项放置到可用空间中。
    ///
    /// 不过，当有足够的空间时，NavigationRail 并不会自动显示标签，因为它无法判断在每个上下文中，什么才算是足够的空间。调用工作应当由您（开发者）来完成。
    ///
    /// 假设您决定仅当 MyHomePage 的宽度至少为 600 像素时才显示标签。
    ///
    /// 注意：Flutter 使用逻辑像素作为长度单位。逻辑像素有时也称为与设备无关的像素。无论应用是在分辨率较低的旧款手机上运行，还是在新款“视网膜”设备上运行，8 像素的内边距在视觉上都是一样的。物理显示器每厘米大约有 38 个逻辑像素，相当于每英寸大约有 96 个逻辑像素。
    ///
    /// 在本例中，我们将使用的 widget 是 LayoutBuilder。它允许根据可用空间大小来更改 widget 树。
    ///
    /// 再次在 VS Code 中使用 Flutter 的 Refactor 菜单进行所需的更改。不过，这一次有点复杂：
    ///
    ///     在 _MyHomePageState 的 build 方法内部，将光标放在 Scaffold 上。
    ///     使用 Ctrl+. 键 (Windows/Linux) 或 Cmd+. 键 (Mac) 调出 Refactor 菜单。
    ///     选择 Wrap with Builder 并按下 Enter 键。
    ///     将新添加的 Builder 的名称修改为 LayoutBuilder。
    ///     将回调参数列表从 (context) 修改为 (context, constraints)。
    ///
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            /// SafeArea 将确保其子项不会被硬件凹口或状态栏遮挡。
            /// 在此应用中，widget 会将 NavigationRail 封装，以防止导航按钮被遮挡，例如被移动状态栏遮挡。
            SafeArea(
              child: NavigationRail(
                /// 您可以将 NavigationRail 中的 extended: false 行更改为 true。
                /// 这将显示图标旁边的标签。在接下来的某个步骤中，你将学习如何在应用有足够的水平空间时自动完成此操作。
                extended: constraints.maxWidth >= 600, // ← Here. /// 现在，您的应用可以响应其环境，例如屏幕尺寸、方向和平台！换句话说，该应用现已具备自适用性！
                destinations: [
                  /// 侧边导航栏有两个目标页面（Home 和 Favorites），两者都有各自的图标和标签。
                  /// 侧边导航栏还定义了当前的 selectedIndex。
                  /// 若选定索引 (selectedIndex) 为零，则会选择第一个目标页面；
                  /// 若选定索引为一，则会选择第二个目标页面，依此类推。目前，它被硬编码为零。
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,

                /// <-2
                onDestinationSelected: (value) {
                  // ↓ Replace print with this.
                  setState(() {
                    selectedIndex = value;
                  });

                  print('selected: $value');
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // return Text('随机字母:[ ${pair.asLowerCase} ]');

    var theme = Theme.of(context); // 获取 context 中的主题

    var color = Color.fromARGB(1, 2, 3, 4); // 自定义颜色

    // 文本主题
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    /// 通过使用 theme.textTheme,，您可以访问应用的字体主题。
    /// 此类包括以下成员：bodyMedium（针对中等大小的标准文本）、caption（针对图片的说明）或 headlineLarge（针对大标题）。
    ///
    /// displayMedium 属性是专用于“展示文本”的大号样式。
    /// 此处的“展示”一词用于反映版式效果，例如展示字体。
    /// displayMedium 的文档指出“展示样式保留用于简短、重要的文本”— 这正是我们的应用场景。
    ///
    /// 从理论上说，主题的 displayMedium 属性可以是 null。
    /// Dart（您编写此应用所使用的编程语言）采用 null 安全机制，因此不会允许您调用值可能为 null 的对象的方法。
    /// 不过，在这种情况下，您可以使用 ! 运算符（“bang 运算符”）向 Dart 保证您知道自己在做什么。
    /// (在本例中，displayMedium 肯定不是 null。不过，判断这一点的方法超出了此 Codelab 的讨论范围。）
    ///
    /// 调用 displayMedium 上的 copyWith() 会返回文本样式的副本，以及您定义的更改。
    /// 在本例中，您只是更改文本的颜色。
    ///
    /// 若要获取新颜色，您需要再次访问应用的主题。
    /// 配色方案的 onPrimary 属性定义了一种非常适合在应用的 primary 颜色上使用的颜色。

    return Card(
        // color: theme.colorScheme.primary,
        //   color: color,
        color: theme.colorScheme.primary,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              // '随机字母:[ ${pair.asLowerCase} ]'
              //     '\n随机字母 first:[ ${pair.first} ]'
              //     '\n随机字母 second:[ ${pair.second} ]' // 拆分单词
              '${pair.first} ${pair.second}',
              style: style,
            )));
  }
}
