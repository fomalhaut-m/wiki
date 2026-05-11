// Dart（最简形式）
// main函数添加async修饰，才能在内部使用await
void main() async {
  print('=' * 60);
  print('🚀 Dart基础语法示例运行开始');
  print('=' * 60);

  printHello();
  useVar();
  useNullSafety();
  useFunction();
  useClass();
  useInherit();
  useInterface();
  useCollection();
  await useAsync(); // await等待异步函数执行完成


  print('\n' + '=' * 60);
  print('✅ Dart基础语法示例运行结束');
  print('=' * 60);
}

//1. Hello World
void printHello() {
  print('\n📌 [1/9] Hello World 示例:');
  print('   输出内容: Hello');
}

//2. 变量和类型
void useVar() {
  print('\n📌 [2/9] 变量和类型 示例:');
  // Dart（很像，但有var和final）
  var name = "Luke"; // 自动推断 String
  print('   var自动推断类型 name：$name (类型: ${name.runtimeType})');
  String name2 = "Luke"; // 显式类型也可以
  print('   显式声明String类型 name2：$name2 (类型: ${name2.runtimeType})');
  int age = 34;
  print('   显式声明int类型 age：$age (类型: ${age.runtimeType})');
  final double height = 183.0; // Java的final，Dart也用final、
  print('   final修饰不可变变量 height：$height (类型: ${height.runtimeType})');
  const PI = 3.14; // 编译时常量，Java没有这个、
  print('   const编译时常量 PI：$PI (类型: ${PI.runtimeType})');
}

//3. 空安全（Null Safety）
void useNullSafety() {
  print('\n📌 [3/9] 空安全（Null Safety） 示例:');
  // Java（烦人的NPE）
  //String name = null; // 编译不报错，但运行时可能炸
  // name.length(); // NullPointerException!

  // Dart（空安全，默认不可为null）
  String name = "Luke";
  print('   默认不可为null变量 name = "$name"，不可赋值为null');
  // name = null;  // ❌ 编译错误！安全

  // 如果真的需要null，加 ?
  String? nullableName = null; // 加?表示可以为null
  print('   可为null变量 nullableName = $nullableName');
  int? length = nullableName?.length; // 安全调用，null就返回null
  print('   安全调用nullableName?.length结果: $length');
}

//4. 函数
void useFunction() {
  print('\n📌 [4/9] 函数 示例:');
  // 函数（lambda）
  int add(int a, int b) => a + b;
  print('   Lambda函数 add(1, 2) = ${add(1, 2)}');

  // 函数（普通）
  int sub(int a, int b) {
    return a - b;
  }

  print('   普通函数 sub(1, 2) = ${sub(1, 2)}');

  // 可选参数
  int greet(String name, {int age = 0}) {
    return name.length + age;
  }

  print('   可选参数函数 greet("Luke") = ${greet("Luke")} (age默认值0)');
  print(
    '   可选参数函数 greet("Luke", age: 34) = ${greet("Luke", age: 34)} (age传值34)',
  );
}

//5. 类和对象
void useClass() {
  print('\n📌 [5/9] 类和对象 示例:');
  // Dart创建对象（不用new）
  var song = Song('晴天', '周杰伦');
  print('   Song实例 title: ${song.title} (类型: ${song.title.runtimeType})'); // 直接访问，不用getter/setter
  print('   Song实例 artist: ${song.artist} (类型: ${song.artist.runtimeType})');
}

// Dart（更简洁）
class Song {
  String title; // 不用写getter/setter，Flutter直接song.title访问
  String artist;
  Song(this.title, this.artist); // 构造器简写
}

//6. 继承
void useInherit() {
  print('\n📌 [6/9] 继承 示例:');
  // Dart创建对象（不用new）
  BaseController player = PlayerController();
  print('   父类引用指向子类实例 player.play() 输出:');
  player.play();

  PlayerController player2 = PlayerController();
  print('   子类实例 player2.play() 输出:');
  player2.play();
}

// Dart（更简洁）
class BaseController {
  void play() {
    print('     父类BaseController.play() 执行');
  }
}

class PlayerController extends BaseController {
  @override // Dart用@override注解，不是@Override
  void play() {
    print('     子类PlayerController.play() 调用super.play()前');
    super.play();
    print('     子类PlayerController.play() 调用super.play()后');
  }
}

//7. 接口和抽象类
void useInterface() {
  print('\n📌 [7/9] 接口和抽象类 示例:');
  // Dart创建对象（不用new）
  PlayerService player = PlayerImpl();
  print('   接口实现类实例 player.play() 输出:');
  player.play();
  print('   接口实现类实例 player.pause() 输出:');
  player.pause();
}

// Dart（Dart没有interface关键字，class就是接口）
// 用abstract class定义抽象类
abstract class PlayerService {
  void play(); // 抽象方法，不用abstract也行
  void pause();
}

class PlayerImpl implements PlayerService {
  @override
  void play() {
    print('     PlayerImpl.play() 执行: 播放');
  }

  @override
  void pause() {
    print('     PlayerImpl.pause() 执行: 暂停');
  }
}

//8. 集合（List/Map/Set）
void useCollection() {
  print('\n📌 [8/9] 集合（List/Map/Set） 示例:');
  // Java
  // List<String> list = Arrays.asList("a", "b", "c");
  // Map<String, int> map = new HashMap<>();
  // map.put("key", 1);
  // for (String item : list) { }

  // Dart（更简洁）
  var list = ['a', 'b', 'c']; // List字面量
  var map = {'key': 1}; // Map字面量
  map['key'] = 1; // 直接访问

  print('   List字面量 list: $list (类型: ${list.runtimeType})');
  print('   for-in遍历list结果:');
  // 遍历
  for (var item in list) {
    print('     $item');
  }

  print('   forEach遍历list结果:');
  // 函数式
  list.forEach((item) => print('     $item'));
  var doubled = list.map((e) => e * 2).toList();
  print('   函数式操作 list.map((e) => e * 2).toList() 结果: $doubled');
  print('   Map字面量 map: $map (类型: ${map.runtimeType})');
  print('   Map直接访问 map["key"] 结果: ${map['key']}');
}

//9. 异步（Future + async/await）
// 异步函数需要返回Future，返回值类型为Future<void>表示没有返回值
Future<void> useAsync() async {
  print('\n📌 [9/9] 异步（Future + async/await） 示例:');
  // Dart（和JavaScript很像）
  Future<String> fetchData(int requestId) async {
    // ✅ await只能在async修饰的函数内部使用
    // await会暂停当前函数执行，等待Future完成后再继续
    var startTime = DateTime.now().millisecondsSinceEpoch;
    print('     [请求$requestId] ${DateTime.now().toIso8601String()} 开始执行，等待1秒模拟网络请求...');
    await Future.delayed(Duration(seconds: 1));
    var endTime = DateTime.now().millisecondsSinceEpoch;
    print('     [请求$requestId] ${DateTime.now().toIso8601String()} 执行完成，耗时${endTime - startTime}ms');
    return '异步请求返回结果';
  }

  // 方式1：通过then链式调用接收异步结果（非阻塞）
  print('\n   方式1：通过.then链式调用获取异步结果（非阻塞）:');
  var startTime1 = DateTime.now().millisecondsSinceEpoch;
  print('   ${DateTime.now().toIso8601String()} 调用fetchData(1)，不等待直接执行后续代码');
  fetchData(1).then((value) {
    var endTime1 = DateTime.now().millisecondsSinceEpoch;
    print('     ${DateTime.now().toIso8601String()} 收到.then结果: $value，从调用到收到结果总耗时${endTime1 - startTime1}ms');
  }).catchError((error) => print('     出现错误: $error'));

  // 方式2：通过await等待异步结果（需要当前函数也是async修饰）
  print('\n   方式2：通过await关键字等待异步结果（同步写法，会阻塞等待）:');
  try {
    var startTime2 = DateTime.now().millisecondsSinceEpoch;
    print('   ${DateTime.now().toIso8601String()} 调用await fetchData(2)，暂停执行等待结果...');
    // await会等待Future执行完成，直接返回结果
    var result = await fetchData(2); 
    var endTime2 = DateTime.now().millisecondsSinceEpoch;
    print('   ${DateTime.now().toIso8601String()} 收到await结果: $result，总耗时${endTime2 - startTime2}ms');
  } catch (error) {
    print('     await捕获到错误: $error');
  }

  // 额外演示：并行执行多个异步请求
  print('\n   额外演示：并行执行多个异步请求（同时发起，总耗时≈1秒）:');
  var startParallel = DateTime.now().millisecondsSinceEpoch;
  print('   ${DateTime.now().toIso8601String()} 同时发起3个异步请求...');
  // Future.wait可以并行等待多个Future完成
  var results = await Future.wait([
    fetchData(3),
    fetchData(4),
    fetchData(5),
  ]);
  var endParallel = DateTime.now().millisecondsSinceEpoch;
  print('   ${DateTime.now().toIso8601String()} 所有并行请求完成，总耗时${endParallel - startParallel}ms');
  print('   并行请求结果列表: $results');
}
