

应用的分层设计是一种将应用程序划分为不同层级的方法, 每个层级负责 `特定` 的功能和 职责.

其中表示层（`Presentation Layer`）负责用户界面和用户交互，将数据呈现给用户并接收用户输入；

业务逻辑层（`Business Logic Layer`）处理应用程序的业务逻辑，包括数据验证、处理和转换；

数据访问层（`Data Access Layer`）负责与数据存储交互，包括数据库或文件系统的读取和写入操作。





让我帮你构思一个现代化的漂流瓶应用。

**1. 核心功能分析：**

基础功能：
- 扔漂流瓶（发送消息）
- 捡漂流瓶（随机接收消息）
- 回复漂流瓶（简单对话）
- 个人中心（查看历史记录）

进阶功能：
- 漂流瓶类型（文字、图片、语音）
- 瓶子保质期（比如7天自动销毁）
- 举报机制（防止不良内容）
- 瓶子标签（心情、话题等）

**2. 技术方案：**

```
前端技术栈：
- Flutter + GetX
- 本地存储：Hive/SharedPreferences
- 网络请求：Dio
- 图片处理：image_picker
- 音频处理：record/audioplayers

后端技术栈：
- Node.js/Python
- MongoDB（存储消息）
- Redis（处理随机获取）
- 对象存储（存储图片）
```

**3. 数据库设计：**

```sql
// 漂流瓶表
Bottle {
  id: String,
  content: String,          // 内容
  type: Enum,              // 类型：text/image/voice
  mediaUrl: String?,       // 媒体URL
  senderId: String,        // 发送者ID
  status: Enum,           // 状态：floating/picked/expired
  tags: Array<String>,    // 标签
  createdAt: DateTime,    // 创建时间
  expireAt: DateTime,     // 过期时间
}

// 用户表
User {
  id: String,
  nickname: String,
  avatar: String?,
  bottlesSent: Number,    // 发送数
  bottlesPicked: Number,  // 捡到数
}

// 对话表
Conversation {
  bottleId: String,
  messages: Array<{
    senderId: String,
    content: String,
    createdAt: DateTime
  }>,
}
```

**4. 界面设计建议：**

```
主要页面：
1. 首页
   - 扔瓶子按钮（大而醒目）
   - 捡瓶子按钮
   - 动画效果（海浪）

2. 瓶子详情页
   - 内容展示
   - 回复功能
   - 举报按钮

3. 个人中心
   - 我扔出的瓶子
   - 我捡到的瓶子
   - 统计信息
```


**5. 项目结构：**

```
lib/
├── app/
│   ├── core/
│   │   ├── theme/
│   │   ├── network/
│   │   └── services/
│   │       ├── auth_service.dart
│   │       └── bottle_service.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── bottle.dart
│   │   │   └── user.dart
│   │   └── providers/
│   │       └── api_provider.dart
│   │
│   ├── modules/
│   │   ├── home/
│   │   ├── bottle/
│   │   └── profile/
│   │
│   └── routes/
│       └── app_pages.dart
```

**6. 关键代码示例：**

```dart:lib/app/data/models/bottle.dart
class Bottle {
  final String id;
  final String content;
  final BottleType type;
  final String? mediaUrl;
  final String senderId;
  final BottleStatus status;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime expireAt;

  Bottle({
    required this.id,
    required this.content,
    required this.type,
    this.mediaUrl,
    required this.senderId,
    required this.status,
    required this.tags,
    required this.createdAt,
    required this.expireAt,
  });
}
```

```dart:lib/app/core/services/bottle_service.dart
class BottleService extends GetxService {
  final _apiProvider = Get.find<ApiProvider>();

  Future<void> throwBottle(Bottle bottle) async {
    try {
      await _apiProvider.post('/bottles', data: bottle.toJson());
      Get.snackbar('成功', '你的漂流瓶已经被海浪带走了~');
    } catch (e) {
      Get.snackbar('错误', '发送失败，请重试');
    }
  }

  Future<Bottle?> pickBottle() async {
    try {
      final response = await _apiProvider.get('/bottles/random');
      return Bottle.fromJson(response.data);
    } catch (e) {
      Get.snackbar('错误', '捡瓶子失败，请重试');
      return null;
    }
  }
}
```

**7. 特别注意事项：**

1. **安全性考虑：**
   - 内容审核机制
   - 用户认证
   - 防刷机制

2. **性能优化：**
   - 图片压缩
   - 延迟加载
   - 本地缓存

3. **用户体验：**
   - 流畅的动画
   - 离线支持
   - 错误提示

**8. 进阶功能建议：**

1. **社交功能：**
   - 可以加好友
   - 私密瓶子

2. **游戏化元素：**
   - 瓶子等级
   - 成就系统
   - 积分奖励

3. **智能推荐：**
   - 基于标签
   - 基于用户兴趣

**9. 开发步骤建议：**

1. **第一阶段：**
   - 基础UI搭建
   - 文字漂流瓶功能
   - 用户系统

2. **第二阶段：**
   - 多媒体支持
   - 对话功能
   - 动画效果

3. **第三阶段：**
   - 社交功能
   - 游戏化系统
   - 性能优化

这个应用的关键是要注意：
- 用户体验要简单直接
- 保护用户隐私
- 内容安全性
- 随机性要真实
- 互动要有趣

需要我详细展开某个部分吗？







让我为这个漂流瓶应用提供一些创新的功能点：

**1. 时空漂流瓶**
```dart
class TimeCapsuleBottle {
  DateTime deliveryTime;    // 指定投递时间
  Location location;        // 指定位置
  bool isTimeSpecific;     // 是否定时投递
}
```
- 可以设置在特定时间才能被打开的瓶子
- 定时发送：比如写给未来的自己
- 地理位置限定：只有在特定位置才能打开的瓶子
- "时空邮局"：可以写给过去或未来的人

**2. 情绪互动系统**
```dart
class EmotionalBottle {
  EmotionType emotion;     // 情绪类型
  int emotionIntensity;    // 情绪强度
  List<String> keywords;   // 情绪关键词
}
```
- 情绪匹配：系统会根据用户当前心情推送相应的漂流瓶
- 心情日记：记录用户情绪变化曲线
- 情绪共鸣：找到相似心情的人
- AI情绪分析：给出建议和安慰

**3. 创意内容形式**
```dart
class CreativeBottle {
  BottleType type;         // 瓶子类型
  List<String> elements;   // 创意元素
  InteractionType interaction; // 互动方式
}
```
- 拼图瓶子：需要多人合作才能完成的拼图
- 接力故事：多人接力创作的故事
- 音乐片段：可以合成的音乐碎片
- AR漂流瓶：在现实世界中寻找虚拟瓶子

**4. 社交游戏化**
```dart
class GameBottle {
  GameType type;          // 游戏类型
  int participantsNeeded; // 所需参与者
  GameStatus status;      // 游戏状态
}
```
- 解谜瓶子：包含谜题需要解决
- 寻宝任务：通过线索找到其他瓶子
- 角色扮演：每个瓶子都是一个角色
- 瓶子链接：将相关的瓶子串联成故事

**5. 环保互动系统**
```dart
class EcoBottle {
  int ecoPoints;          // 环保积分
  List<String> ecoActions; // 环保行动
  bool isVerified;        // 是否验证
}
```
- 虚拟清理：每捡到一个瓶子相当于清理了一片海洋
- 环保积分：可以用于种树或其他环保项目
- 环保意识传播：分享环保小知识和行动
- 实境互动：结合实际海洋清理活动

**6. AI 创意助手**
```dart
class AIBottleAssistant {
  AIMode mode;            // AI模式
  List<String> suggestions; // AI建议
  CreativeDirection direction; // 创作方向
}
```
- 内容生成：帮助用户创作有趣的内容
- 故事展开：AI辅助故事创作
- 情感分析：理解和回应用户情绪
- 创意建议：提供互动方式建议

**7. 声音互动系统**
```dart
class AudioBottle {
  AudioType type;         // 音频类型
  Duration duration;      // 时长
  List<String> tags;     // 标签
}
```
- 声音拼图：收集不同的声音片段
- 心跳瓶子：分享心跳声
- 环境音：分享特定地点的环境声
- 语音变声：有趣的声音效果

**8. 互动式艺术创作**
```dart
class ArtBottle {
  ArtStyle style;         // 艺术风格
  List<Contribution> contributions; // 贡献
  ArtStatus status;       // 作品状态
}
```
- 协作画作：多人共同完成的艺术作品
- 诗歌接龙：集体创作诗歌
- 音乐合成：创建协作音乐
- 数字艺术：基于区块链的NFT艺术品

**9. 社会公益系统**
```dart
class CharityBottle {
  CharityType type;       // 公益类型
  int participantsCount;  // 参与人数
  double impact;          // 影响力
}
```
- 公益故事：分享感人的公益故事
- 帮助请求：寻求帮助或建议
- 善意传递：记录善行并传播
- 众筹系统：支持公益项目

**10. 元宇宙互动**
```dart
class MetaverseBottle {
  VirtualSpace space;     // 虚拟空间
  List<Asset> assets;    // 虚拟资产
  InteractionType type;  // 互动类型
}
```
- 虚拟空间：在元宇宙中投放和捡拾瓶子
- 数字收藏：特殊的数字藏品瓶子
- 虚拟展览：展示用户创作的内容
- 跨平台互动：与其他元宇宙平台联动

这些创新点可以：
1. 提高用户参与度
2. 增加社交互动性
3. 加入有意义的社会价值
4. 创造独特的用户体验
5. 形成特色的产品定位

建议可以先选择1-2个特色功能深入开发，待产品有一定用户基础后再逐步扩展其他功能。



### Ai部分

让我重新设计一个以 AI 为核心特色的现代漂流瓶应用。

**1. AI 角色扮演系统**
```dart
class AIBottleCharacter {
  final String id;
  final String name;
  final String personality;  // 性格特征
  final List<String> background; // 背景故事
  final AIModel model;      // 使用的AI模型
  
  // AI角色的记忆系统
  final ConversationMemory memory;
}
```

核心功能：
- AI 扮演不同角色写漂流瓶（作家、诗人、历史人物等）
- 每个 AI 角色都有独特的性格和写作风格
- 用户可以与 AI 角色进行深度对话
- AI 会记住与用户的互动历史

**2. AI 情感分析与匹配系统**
```dart
class EmotionalAISystem {
  final EmotionAnalyzer analyzer;
  final BottleMatcher matcher;
  
  class EmotionAnalyzer {
    EmotionType analyzeText(String content);
    EmotionType analyzeVoice(File audioFile);
    Map<String, double> getEmotionScores();
  }
}
```

功能点：
- 分析用户发送的内容情绪
- 智能匹配相似情绪的瓶子
- 提供情绪咨询和建议
- 生成情绪报告和洞察

**3. AI 创意内容生成器**
```dart
class AIContentGenerator {
  final CreativePrompt prompt;
  final List<String> styles;
  final ContentType type;
  
  Future<Content> generate() async {
    // 根据提示和风格生成内容
  }
}
```

示例实现：
```dart:lib/app/core/services/ai_content_service.dart
class AIContentService extends GetxService {
  final OpenAI _openAI = Get.find<OpenAI>();
  
  Future<String> generateCreativeContent(String prompt, ContentStyle style) async {
    try {
      final response = await _openAI.createCompletion(
        model: "gpt-4",
        prompt: _buildPrompt(prompt, style),
        maxTokens: 1000,
      );
      
      return response.choices.first.text;
    } catch (e) {
      throw AIGenerationException(message: '内容生成失败');
    }
  }
  
  Future<List<String>> generateContentSuggestions(String userInput) async {
    // 生成创意建议
  }
}
```

**4. AI 互动故事系统**
```dart
class AIStorySystem {
  final StoryContext context;
  final List<Character> characters;
  final StoryProgress progress;
  
  Future<StoryUpdate> continueStory(String userInput) async {
    // AI 根据用户输入继续发展故事
  }
}
```

功能特点：
- 多人协作的 AI 辅助故事创作
- AI 根据情节发展给出建议
- 自动生成故事插图
- 多结局可能性

**5. AI 语音互动系统**
```dart
class AIVoiceSystem {
  final VoiceRecognizer recognizer;
  final VoiceSynthesizer synthesizer;
  final EmotionDetector emotionDetector;
  
  Future<AudioResponse> generateVoiceResponse(String text, VoiceStyle style) async {
    // 生成个性化语音回复
  }
}
```

**6. 智能瓶子推荐系统**
```dart:lib/app/core/services/recommendation_service.dart
class AIRecommendationService extends GetxService {
  final UserPreferences _preferences = Get.find<UserPreferences>();
  
  Future<List<Bottle>> getPersonalizedBottles() async {
    final userProfile = await _buildUserProfile();
    return await _recommendBottles(userProfile);
  }
  
  Future<UserProfile> _buildUserProfile() async {
    // 分析用户兴趣和行为
  }
}
```

**7. AI 安全审核系统**
```dart
class AIContentModerator {
  final ContentAnalyzer analyzer;
  final SafetyChecker safetyChecker;
  
  Future<SafetyReport> checkContent(Content content) async {
    // 检查内容安全性
  }
}
```

**8. 实现示例**

主要服务类：
```dart:lib/app/core/services/ai_bottle_service.dart
class AIBottleService extends GetxService {
  final OpenAI _openAI;
  final AIContentGenerator _contentGenerator;
  final EmotionalAISystem _emotionalSystem;
  
  Future<Bottle> createAIBottle(BottlePrompt prompt) async {
    // 验证内容
    final safetyReport = await _moderator.checkContent(prompt.content);
    if (!safetyReport.isSafe) {
      throw ContentViolationException();
    }
    
    // 生成 AI 内容
    final aiContent = await _contentGenerator.generate(prompt);
    
    // 情感分析
    final emotions = await _emotionalSystem.analyzer.analyzeText(aiContent);
    
    return Bottle(
      content: aiContent,
      emotions: emotions,
      type: BottleType.ai,
      createdAt: DateTime.now(),
    );
  }
  
  Future<AIResponse> getAIResponse(String userMessage, String bottleId) async {
    // 获取上下文
    final context = await _getConversationContext(bottleId);
    
    // 生成回复
    final response = await _openAI.createChatCompletion(
      model: "gpt-4",
      messages: [
        ...context,
        {"role": "user", "content": userMessage}
      ],
    );
    
    return AIResponse(
      content: response.choices.first.message.content,
      emotion: await _emotionalSystem.analyzer.analyzeText(response.choices.first.message.content),
    );
  }
}
```

使用示例：
```dart:lib/app/modules/bottle/controllers/bottle_controller.dart
class BottleController extends GetxController {
  final _aiService = Get.find<AIBottleService>();
  final bottles = <Bottle>[].obs;
  
  Future<void> createAIBottle() async {
    try {
      final bottle = await _aiService.createAIBottle(
        BottlePrompt(
          type: BottleType.story,
          style: WritingStyle.poetic,
          theme: "海洋",
        ),
      );
      
      bottles.add(bottle);
      Get.snackbar('成功', 'AI已创建了一个新的漂流瓶');
    } catch (e) {
      Get.snackbar('错误', '创建失败，请重试');
    }
  }
}
```

**9. 特色功能**

1. **AI 人格定制**
- 用户可以定制 AI 角色的性格
- AI 会随着互动逐渐发展性格
- 记住与用户的互动历史

2. **多模态内容生成**
- 文字+图片+语音的组合
- 风格化的内容生成
- 情境感知的回复

3. **智能情感陪伴**
- 心理咨询辅助
- 情绪分析和建议
- 个性化的安慰和鼓励

4. **创意写作助手**
- 提供写作建议
- 完善内容结构
- 多种写作风格切换

这个设计的优势：
1. AI 提供个性化体验
2. 增加互动的深度和趣味性
3. 保证内容的质量和安全性
4. 提供情感价值
5. 具有技术壁垒

建议：
1. 使用最新的 AI 模型
2. 注意 AI 响应速度优化
3. 做好内容审核
4. 保护用户隐私
5. 控制 AI 使用成本







## 路由管理 二次封装Get Router

我来帮你封装一个更易用的路由管理类。我们将创建一个 AppRoute 类来更好地管理路由。

以下是对 `lib/app/router/index.dart` 的修改建议：

```dart
import 'package:get/get.dart';

/// 路由管理类
class AppRoute {
  /// 路由名称
  final String name;
  
  /// 页面构建器
  final GetPageBuilder page;
  
  /// 转场动画
  final Transition? transition;
  
  /// 中间件
  final List<GetMiddleware>? middlewares;
  
  /// 是否需要认证
  final bool? needAuth;

  const AppRoute({
    required this.name,
    required this.page,
    this.transition,
    this.middlewares,
    this.needAuth,
  });

  /// 转换为GetPage
  GetPage toGetPage() {
    return GetPage(
      name: name,
      page: page,
      transition: transition ?? Transition.rightToLeft,
      middlewares: middlewares,
    );
  }
}

/// 路由管理
class AppRoutes {
  /// 定义路由名称常量
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
  
  /// 路由表
  static final routes = <AppRoute>[
    // AppRoute(
    //   name: home,
    //   page: () => const HomePage(),
    // ),
    // AppRoute(
    //   name: login,
    //   page: () => const LoginPage(),
    //   transition: Transition.fadeIn,
    // ),
    // AppRoute(
    //   name: profile,
    //   page: () => const ProfilePage(),
    //   needAuth: true,
    // ),
  ];

  /// 获取所有GetPage路由
  static List<GetPage> getPages() {
    return routes.map((route) => route.toGetPage()).toList();
  }

  /// 导航到指定页面
  static Future<T?>? to<T>(String name, {dynamic arguments}) {
    return Get.toNamed<T>(name, arguments: arguments);
  }

  /// 替换当前页面
  static Future<T?>? off<T>(String name, {dynamic arguments}) {
    return Get.offNamed<T>(name, arguments: arguments);
  }

  /// 清空所有页面并导航
  static Future<T?>? offAll<T>(String name, {dynamic arguments}) {
    return Get.offAllNamed<T>(name, arguments: arguments);
  }

  /// 返回上一页
  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }
}
```

这个封装主要做了以下几点改进：

1. 创建了 `AppRoute` 类来封装路由信息，包含：
   - 路由名称
   - 页面构建器
   - 转场动画
   - 中间件
   - 是否需要认证等配置

2. 在 `AppRoutes` 类中：
   - 使用常量定义路由名称，避免字符串硬编码
   - 提供了路由表配置
   - 封装了常用的导航方法（to、off、offAll、back）
   - 提供 `getPages()` 方法用于获取 GetX 需要的路由列表

使用示例：

```dart
// 定义路由
final routes = <AppRoute>[
  AppRoute(
    name: AppRoutes.home,
    page: () => const HomePage(),
  ),
  AppRoute(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    transition: Transition.fadeIn,
  ),
];

// 导航
AppRoutes.to(AppRoutes.login);
AppRoutes.back();
```

在 `main.dart` 中使用：

```dart
GetMaterialApp(
  // ...
  getPages: AppRoutes.getPages(),
  // ...
)
```

这样的封装带来以下好处：

1. 路由配置更加集中和清晰
2. 通过常量管理路由名称，避免拼写错误
3. 可以方便地为路由添加通用配置（如转场动画、中间件等）
4. 提供了统一的导航方法接口
5. 为后续添加路由守卫、权限控制等功能提供了扩展性

你可以根据实际需求，在 `AppRoute` 类中添加更多配置项，或在 `AppRoutes` 中添加更多辅助方法。





## 网络请求dio 封装

我来帮你创建一个优雅的 Dio 封装。我们将创建以下文件结构：

```
lib/app/core/http/
├── dio_client.dart      # Dio 客户端封装
├── interceptors.dart    # 拦截器
└── api_response.dart    # 统一响应格式
```

首先是 `dio_client.dart`:

```dart:lib/app/core/http/dio_client.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import './interceptors.dart';

/// Dio 客户端封装
class DioClient extends GetxService {
  late final Dio _dio;
  
  /// 基础URL
  final String baseUrl;
  
  /// 连接超时时间
  final Duration connectTimeout;
  
  /// 响应超时时间
  final Duration receiveTimeout;

  DioClient({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    )..interceptors.addAll([
        AuthInterceptor(),
        LoggerInterceptor(),
        ErrorInterceptor(),
      ]);
  }

  /// GET 请求
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// POST 请求
  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT 请求
  Future<T?> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE 请求
  Future<T?> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
```

接下来是 `interceptors.dart`:

```dart:lib/app/core/http/interceptors.dart
import 'package:dio/dio.dart';

/// 认证拦截器
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 从本地存储获取token
    // final token = StorageService.to.getString('token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }
}

/// 日志拦截器
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    return super.onError(err, handler);
  }
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            err = BadRequestException(err.requestOptions);
            break;
          case 401:
            err = UnauthorizedException(err.requestOptions);
            break;
          case 403:
            err = ForbiddenException(err.requestOptions);
            break;
          case 404:
            err = NotFoundException(err.requestOptions);
            break;
          case 409:
            err = ConflictException(err.requestOptions);
            break;
          case 500:
            err = InternalServerErrorException(err.requestOptions);
            break;
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        err = NoInternetConnectionException(err.requestOptions);
        break;
      default:
        break;
    }
    return super.onError(err, handler);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Internal server error occurred';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested resource does not exist';
  }
}

class ForbiddenException extends DioException {
  ForbiddenException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access to resource is forbidden';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection';
  }
}
```

最后是 `api_response.dart`:

```dart:lib/app/core/http/api_response.dart
/// API 响应格式
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? code;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.code,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String?,
      code: json['code'] as int?,
      data: json['data'] == null ? null : fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson(dynamic Function(T?) toJson) {
    return {
      'success': success,
      'message': message,
      'code': code,
      'data': data == null ? null : toJson(data),
    };
  }
}
```

使用示例：

```dart
// 初始化
final dioClient = Get.put(DioClient(
  baseUrl: 'https://api.example.com',
));

// 使用
class UserRepository {
  final _dio = Get.find<DioClient>();

  Future<User?> getUser(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/users/$id');
    if (response != null) {
      return User.fromJson(response);
    }
    return null;
  }

  Future<List<User>?> getUsers() async {
    final response = await _dio.get<List<dynamic>>('/users');
    if (response != null) {
      return response.map((json) => User.fromJson(json)).toList();
    }
    return null;
  }
}
```

这个封装提供了以下特性：

1. 统一的请求客户端
2. 完整的错误处理
3. 请求/响应拦截器
4. 日志记录
5. 统一的响应格式
6. 类型安全的响应处理
7. 超时处理
8. Token 认证支持

记得在 `pubspec.yaml` 中添加 dio 依赖：

```yaml
dependencies:
  dio: ^5.4.0
```

这个封装既保持了代码的简洁性，又提供了足够的功能性和扩展性。你可以根据实际需求继续添加更多功能。