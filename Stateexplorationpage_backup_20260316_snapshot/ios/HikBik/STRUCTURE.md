# iOS 项目结构说明

## 📁 目录结构

```
HikBik/
├── App/                    # 应用入口
│   ├── HikBikApp.swift     # App 主入口
│   └── ContentView.swift   # TabView 容器
│
├── Core/                   # 核心功能
│   ├── Theme/              # 主题配置
│   │   └── HikBikTheme.swift
│   └── Components/         # 可复用组件
│       └── FlowLayout.swift
│
├── Features/               # 功能模块（按功能组织）
│   ├── Home/               # 首页
│   │   └── HomeView.swift
│   ├── Explore/            # 探索模块
│   │   ├── ExploreView.swift
│   │   ├── StateParks/     # 州立公园
│   │   ├── NationalParks/  # 国家公园
│   │   ├── Forests/        # 国家森林
│   │   ├── Grasslands/     # 国家草原
│   │   └── Recreation/     # 国家休闲区
│   ├── Trips/              # 行程模块
│   │   └── TripsListView.swift
│   └── Profile/            # 个人中心
│       ├── ProfileView.swift
│       └── FavoritesListView.swift
│
├── Models/                 # 数据模型
│   ├── StateModels.swift
│   ├── NationalParkModels.swift
│   ├── NationalParkExtendedModels.swift
│   ├── ForestGrasslandModels.swift
│   └── TripModels.swift
│
├── Services/               # 数据服务
│   ├── DataLoader.swift
│   ├── TripStore.swift
│   └── FavoritesStore.swift
│
└── Resources/              # 资源文件
    ├── *.json              # JSON 数据文件
    └── Assets.xcassets/    # 图片资源
```

## 🎯 设计原则

### 1. **按功能模块组织** (Features/)
- 每个主要功能（Home、Explore、Trips、Profile）有独立目录
- Explore 下的子功能（StateParks、NationalParks 等）按类型分组
- 便于定位和维护相关代码

### 2. **核心功能分离** (Core/)
- **Theme/**: 统一的主题配置（颜色、字体、间距等）
- **Components/**: 可复用的 UI 组件（如 FlowLayout）

### 3. **数据层分离**
- **Models/**: 数据模型定义
- **Services/**: 数据加载和存储逻辑
- **Resources/**: 静态资源文件

### 4. **应用入口** (App/)
- 应用启动和主容器视图

## 📝 文件说明

### App/
- `HikBikApp.swift`: SwiftUI App 入口
- `ContentView.swift`: TabView 主容器（Home/Explore/Trips/Profile）

### Core/Components/
- `FlowLayout.swift`: 流式布局组件，用于标签、活动等横向排列元素

### Features/Explore/
每个子模块包含：
- **Tab.swift**: 列表页（如 `NationalParksTab.swift`）
- **DetailView.swift**: 详情页（如 `NationalParkDetailView.swift`）

### Models/
- `NationalParkExtendedModels.swift`: 国家公园扩展数据（设施、天气、图库等），对应 Figma 设计

### Services/
- `DataLoader.swift`: 从 Bundle 加载 JSON 数据
- `TripStore.swift`: 行程数据存储
- `FavoritesStore.swift`: 收藏数据存储

## 🔄 迁移说明

从旧的扁平结构迁移到新结构：
- `Views/` → `Features/`（按功能分组）
- `Theme/` → `Core/Theme/`
- `FlowLayout` → `Core/Components/FlowLayout.swift`（从 ParkDetailView 提取）

## ✅ 优势

1. **清晰的功能划分**：每个功能模块独立，易于理解和维护
2. **可扩展性**：新增功能只需在 Features 下创建新目录
3. **组件复用**：Core/Components 中的组件可在任何地方使用
4. **符合 SwiftUI 最佳实践**：按功能组织，而非按文件类型
