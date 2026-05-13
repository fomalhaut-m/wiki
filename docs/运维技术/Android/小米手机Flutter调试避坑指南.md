# 📱 小米/Redmi 手机 Flutter 调试避坑清单（Android 16 专属）

> 按优先级排序，99% 的调试问题一次性解决。

---

## 一、设备连接与驱动篇（最关键）

### 问题 1：ADB 识别不到设备（显示 WinUSB/通用串行总线设备）

| 解决步骤 | 关键说明 |
|----------|----------|
| 1. 右键设备 → 更新驱动 | — |
| 2. 手动选择：**Android 设备** → **Android ADB Interface** | — |
| 3. 执行 `adb kill-server && adb start-server` | 必须安装 Google 官方 ADB 驱动 |

**WinUSB 模式会直接导致 Flutter 版本识别错误。**

### 问题 2：无线调试能连，但 Flutter 识别为 Android 6.0.1

**原因**：小米 Android 16 的无线调试存在已知兼容性 Bug。

| 解决步骤 |
|----------|
| 1. 关闭手机「开发者选项」里的「无线调试」和「ADB TLS 连接」 |
| 2. 改用**原装数据线有线连接** |

### 问题 3：设备管理器出现黄色感叹号

| 方案 | 说明 |
|------|------|
| 安装「小米助手」自动补全驱动 | 装完可卸载 |
| 手动下载「Google USB 驱动」安装 | 备选方案 |

---

## 二、手机开发者选项配置篇（必全开）

**路径**：`设置 → 我的设备 → 全部参数 → 连续点击 MIUI/OS 版本号`

### ✅ 必须开启的选项

```
☐ USB 调试
☐ USB 调试（安全模式）
☐ USB 安装
☐ USB 调试（Security settings）
☐ 允许模拟位置（调试定位相关时）
```

### ✅ 额外设置

- 连接电脑时，手机弹窗选择**「文件传输（MTP）」**，并勾选**「始终允许此计算机」**
- 关闭「USB 安装安全校验」，避免小米拦截 Flutter 安装应用

---

## 三、电脑端 ADB 与 Flutter 配置篇

### 1. 重置 ADB 服务（每次调试前必做）

```powershell
adb kill-server
adb start-server
adb devices
```

**判断连接正常**：`设备ID + device`

**如果是 `unauthorized`**：手机上点击「始终允许」授权电脑。

### 2. Flutter 项目强制兼容配置

修改 `android/app/build.gradle`：

```gradle
android {
    compileSdkVersion 35        // Android 16 对应 API 35
    buildToolsVersion "35.0.0"

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 35       // 必须和 compileSdkVersion 一致
    }
}
```

### 3. 调试命令（遇到版本识别异常时直接用）

```powershell
# 跳过版本校验强制运行
flutter run --no-version-check

# 指定设备运行（设备 ID 从 adb devices 获取）
flutter run -d 你的设备ID --no-version-check
```

---

## 四、常见问题快速排查

### 问题 1：Flutter 能看到设备，但无法安装应用

```powershell
# 排查步骤
1. 检查手机是否开启「USB 安装」权限
2. 关闭小米手机管家的「安装未知应用」拦截
3. flutter clean && flutter pub get  清理缓存后重试
```

### 问题 2：应用安装成功，但打开后闪退

```powershell
# 排查步骤
1. 检查 targetSdkVersion 是否为 35，是否和 compileSdkVersion 一致
2. 检查手机是否开启了「开发者选项」里的「不保留活动」，关闭该选项
```

### 问题 3：ADB 能识别设备，Flutter devices 看不到

```powershell
# 排查步骤
1. 重启电脑和手机，重新插拔数据线
2. 检查数据线是否为原装（劣质数据线只充电不传数据）
```

---

## 五、终极兜底方案

所有方法都无效时：

1. **备份手机数据，更新到最新版 MIUI/HyperOS**
2. **电脑端重新安装 Android SDK Platform-Tools，确保版本 ≥ 35**
3. **彻底卸载电脑上的第三方手机助手**（可能会劫持 ADB 驱动）
4. **改用 Android Studio 自带的 ADB 工具调试**

---

*来源：实际踩坑经验 · Android 16 + MIUI/HyperOS*