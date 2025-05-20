#let zh-fonts = ("Noto Serif", "Noto Serif SC", "Noto Serif CJK SC")

#let project(name: "", contacts: (), body) = {
  set page(numbering: "1", number-align: center)
  set text(lang: "en", font: "Libertinus Serif")
  set text(lang: "zh", font: zh-fonts)
  show raw: set text(lang: "zh", size: 11pt)

  set par(spacing: 0.9em)

  set par(leading: 0.58em)

  align(center)[
    #block(text(weight: 700, 1.65em, name))
  ]

  align(center, pad(
    top: 0.3em,
    bottom: 0.3em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(4, contacts.len()),
      gutter: 1em,
      ..contacts.map(contact => {
        let target = contact.at("link", default: "none")
        if (target == "none") {
          align(center)[
            *#contact.type* \
            #contact.value
          ]
        }
        else {
          align(center)[
            *#contact.type* \
            #link(target, text(blue, contact.value))
          ]
        }
      }),
    ),
  ))

  // Main body.
  set par(justify: true)
  body
}

#show: project.with(
  name: "陈天泽",
  contacts: (
    (type: "电话", value: "175 5416 0152"),
    (type: "邮箱", value: "icey@icey.tech", link: "mailto://icey@icey.tech"),
    (type: "GitHub", value: "chuigda", link: "https://github.com/chuigda"),
    (type: "网站", value: "CoreBlogN²G", link: "https://chuigda.doki7.club"),
  ),
)

= 教育经历
#line(length: 100%)
*青岛大学*，计算机科学与技术，学士学位 #h(1fr) 2016.9 - 2020.6

= 技能
#line(length: 100%)
- *编程语言: * 能使用多种语言，相对熟悉 Rust、C、C++、Java、JavaScript，亦有 C\#、Go、Python、PHP、Julia、Racket 等语言的开发经验
- *图形学:* 理解光栅化原理、坐标变换等基本知识，图形学中的基本算法；有 OpenGL、WebGL 和 Vulkan 开发经验；对游戏引擎技术有一定研究
- *前端:* 有 React 和 Vue 经验，亦有能力使用原生 JavaScript
- *后端:* 了解 HTTP 协议和语义，相对熟悉 Express.js，也有少许 SpringBoot 使用经验。了解基本的数据库知识，使用过 MySQL 和 MongoDB
- *编译原理:* 熟悉解析器、语义分析和类型检查等话题，参与过若干与相关的公司和个人项目
- *国际象棋:* Lichess 1505 （2024 年 6 月 12 日）

= 工作经验
#line(length: 100%)
*苏州同元软控* #h(1fr) 2023.3 - now

_编译器工程师_

- 实现了 Julia 静态编译器所用的 Julia IR 的正规化
- 实现了 MATLAB(R) 语言的解析器，支持 MATLAB(R) 语言及其方言中的许多奇怪语法。新解析器的性能是之前基于 ANTLR 的解析器的 50 倍
- 实现了 Julia 的网络库，提供 HTTP 服务器/客户端和 WebSocket 服务器/客户端，以替代之前的 HTTP.jl 和其他解决方案
- 使用 Vue3 实现了可视化的 MATLAB(R) 函数封装工具
- 为我们自己的 MATLAB(R) 语言实现了 VSCode 工作区和调试器功能

*青岛东软载波* #h(1fr) 2021.4 - 2022.7

_全栈工程师_

- 参与了电力物联网云平台的开发，该项目后端使用 SpringBoot + MySQL + MongoDB + JPA/MyBatis，前端使用 Vue2 + iView + eCharts
- 基于 Express.js + node-canvas + eCharts + LaTeX 实现了一个 PDF 报告生成器服务，其中图像基于 node-canvas + eCharts 生成

*上海甜新科技* #h(1fr) 2020.6 - 2021.3

_全栈工程师_

- 设计并实现了用于从低带宽、低性能的 IoT 设备上传视频和音频到云端的协议
- 基于 FFmpeg 编写了音视频编码器，可将 IoT 设备上传的音视频文件编码为主流浏览器和视频播放器直接播放的格式（MP4 容器 + H264 视频流 + YUV420P 帧 + AAC 音频）
- 通过 RPC over HTTP 将编码服务器与 Node.js 业务服务器连接
- 协助解决了 IoT 设备上 OV5640 摄像头的若干问题
- 编写了一个用于测试 WebRTC 服务器的实用程序，该程序使用的技术也被选定作为 WebRTC 客户端的备用方案

#colbreak()

*深圳源伞科技* #h(1fr) 2018.7 - 2018.9

_编译器工程师_

- 调查了 clang-3.6 的若干 bug，并编写补丁或移植高版本补丁以修复它们，使 eosio、Firefox、Android 等项目能够使用 clang-3.6 编译
- 为 LLVM-3.6 实现了一个（空壳）WebAssembly 后端，使其能够以 WebAssembly 为目标生成 LLVM IR

= 个人项目
#line(length: 100%)

*2V64*，Rust 异步运行时 #h(1fr) #link("https://github.com/chuigda/2V64", text(blue, "https://github.com/chuigda/2V64"))

_Rust, Unix, async_

- 简单的单线程/多线程 Rust 异步运行时
- 基于 Unix `poll` API 实现了异步 TCP socket（两种方式：手写 `Future` 和使用 tokio `AsyncRead`/`AsyncWrite`），并以此为基础实现了一个小型的 HTTP 服务器

*9T56*，类型论相关研究 #h(1fr) #link("https://github.com/chuigda/9T56", text(blue, "https://github.com/chuigda/9T56"))

_ML, Python, Typst, Type theory_

- 翻译了论文 #link("http://lucacardelli.name/Papers/BasicTypechecking%20(TR%201984).pdf", text(blue, "Basic Polymorphic Typechecking")) 和博客 #link("https://jeremymikkola.com/posts/2018_03_25_understanding_algorithm_w.html", text(blue, "Understanding Algorithm W"))
- 使用 Python 实现了 _Understanding Algorithm W_ 论文中的算法 $cal(W)$，并实现了 _Basic Polymorphic Typechecking_ 中的算法 $cal(J)$
- 设计了一些标准 ML 以外的语言特性（主要是命令式特性）及其类型检查规则

*Project-WGX*，3D 虚拟形象 #h(1fr) #link("https://github.com/chuigda/Project-WGX", text(blue, "https://github.com/chuigda/Project-WGX"))

_Java, Vulkan, OpenGL, CG_

- 结合 `MonoBehavior` 和 ECS 两种系统的特性，根据实际需要设计了可扩展的 $mono("reactor")$ 系统
- 实现了基于 Vulkan 和 OpenGL ES2 两种后端的数据驱动渲染器，支持多线程：以 Vulkan 为后端时，可以利用 Vulkan 的多线程和异步特性；以 OpenGL ES2 为后端时，通过 channel 将实际在渲染线程上进行的操作封装为同步操作

*Project-602*，国际象棋软件 #h(1fr) #link("https://github.com/chuigda/Project-602", text(blue, "https://github.com/chuigda/Project-602"))

_JavaScript, HTML5, WebGL, CG_

- 基于 Vanilla JavaScript 实现用户界面，动画丝滑流畅
- 基于 WebGL 渲染高度风格化的 3D 棋盘
- 通过 WebAssembly 接入 fairy-stockfish 引擎实现人机对战
- 基于 JavaScript 设计了高度可扩展的脚本系统，并基于 Blockly 开发了可视化编辑器，可实现类似于游戏 BOT.vinnik 或软件 PyChess 的交互式教学功能

*vulkan4j*，基于 FFM 的图形学 API Java 绑定 #h(1fr) #link("https://github.com/chuigda/vulkan4j", text(blue, "https://github.com/chuigda/vulkan4j"))

_Java, Kotlin, Vulkan, OpenGL, CG_

- 使用自动脚本从 Vulkan 注册表 `vk.xml`、OpenGL 注册表 `gl.xml`、Vulkan 内存分配器头文件 `vma.h` 和 GLFW  头文件 `glfw3.h` 抽取函数和类型定义，并生成 Java 绑定
- 提供适度的 Java 抽象，使这些 API 更易于使用，也更加类型安全
- 基于绑定后的 API 移植了完整的 Vulkan 教程

*Vulkan-Tutorial-Rust-CN*，Vulkan 教程（Rust）的中文翻译 #h(1fr) #link("https://vk.7dg.tech", text(blue, "https://vk.7dg.tech"))

_Rust, Vulkan, CG, Translation_

- 主导完整翻译了 #link("https://kylemayes.github.io/vulkanalia/introduction.html", text(blue, "Rust 版 Vulkan 教程"))，主要参与人员多达 8 人
- 参考了未完成的 C++ 版教程中文翻译，在术语上作了严格的考证，表达方式尽可能贴合中文习惯

#colbreak()

*Project-WG*，3D 虚拟形象 #h(1fr) #link("https://github.com/chuigda/Project-WG", text(blue, "https://github.com/chuigda/Project-WG"))

_C++, Qt, OpenGL, CG_

- 基于 C++，Qt 和 OpenGL（传统固定管线）实现了渲染器
- 能通过 UDP 从 OpenSeeFace 接收面捕数据，或者通过 WebSocket 从 VTubeStudio 接收面捕数据
- 具有可扩展的插件系统，支持 C++ 语言编写的插件

*Project-PL5*，Scheme 方言 #h(1fr) #link("https://github.com/chuigda/Project-PL5", text(blue, "https://github.com/chuigda/Project-PL5"))

_C, Compiler_

- 使用 C 实现了命令式优先，且具有特殊内建函数机制的 Scheme 方言
- 基于 C `setjmp` 和 `longjump` 实现了错误处理方案，可在出错时打印栈追踪并从中恢复
- 可通过 C API 扩展，也支持 Rust

= 杂项
#line(length: 100%)

- 曾在开源项目 *flomonster/easy-gltf * (_Rust_), *franciscoBSalgueiro/en-croissant* (_JavaScript + Rust_), *durch/rust-s3* (_Rust_), *webrtc-rs/webrtc* (_Rust_), *KyleMayes/vulkanalia* (_Rust_) 和 *open-webrtc-toolkit/owt-client-native* (_C++_) 作出过贡献
- 于 2020 年 12 月以讲师身份参加过 Rust China Conference
- 于 2019 年在天津蓝桥实训中，开发的 Hahadoop OJ（在线评测系统，支持分布式评测机）获得优秀实训项目
- 于 2018 年在 CCF-CSP 中获得 310/500 分
- 于 2017 年获得蓝桥杯省赛二等奖
