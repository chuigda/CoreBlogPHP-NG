#let project(name: "", contacts: (), body) = {
  set page(numbering: "1", number-align: center)
  set text(lang: "en", font: "Libertinus Serif")

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
  name: "Chen Tianze",
  contacts: (
    (type: "Phone", value: "(+86) 175 5416 0152"),
    (type: "E-Mail", value: "chuigda@doki7.club", link: "mailto://chuigda@doki7.club"),
    (type: "GitHub", value: "chuigda", link: "https://github.com/chuigda"),
    (type: "Website", value: "CoreBlogN²G", link: "https://chuigda.doki7.club"),
  )
)

= Education
#line(length: 100%)
*Qingdao University*, Computer Science, Bachelor #h(1fr) 2016.9 - 2020.6

= Skills
#line(length: 100%)
- *Programming Languages: * Multilingual (not limited to any specific language), especially experienced in Rust, C, C++, JavaScript. Comfortable with Java, C\#, Go, Python, PHP, Julia, Racket (in random order).
- *Computer Graphics:* Understand how rasterization pipeline works, have experience with OpenGL/OpenGL ES, WebGL and Vulkan. Have some research on game engines.
- *Frontend:* Have the experience of using React and Vue, also capable of using vanilla JavaScript.
- *Backend:* Understand HTTP protocol and semantics, relatively familiar with Express.js, and have experience with SpringBoot. Have basic database knowledge, used MySQL and MongoDB.
- *Compilers:* Familiar with parsers, semantic analysis and type checking, participated in several related company and personal projects.
- *Chess:* Lichess 1505 (June 12, 2024)

= Working Experience
#line(length: 100%)
*Suzhou Tongyuan Software&Control Co.,Ltd*, Suzhou, China #h(1fr) 2023.3 - now

_Compiler engineer_

- Implemented normalisation of Julia IR (intermediate representation) used by Julia static compiler.
- Designed and implemented parser of MATLAB(R) language for our own MATLAB(R) implementation, supporting many dubious syntaxes of MATLAB(R) language and of its dialects. The new parser outperforms the previous ANTLR-based one by 50 times.
- Implemented a networking library for Julia, providing HTTP sever/client and WebSocket server/client. Replacing HTTP.jl and other previous workarounds.
- Implemented a web-based user-interface for wrapping Julia functions to MATLAB(R) functions.
- Implemented VSCode workspace and debugger for our own MATLAB(R) implementation.

*Qingdao Eastsoft Co.,Ltd*, Qingdao, China #h(1fr) 2021.4 - 2022.7

_Fullstack engineer_

- Participated in the development of a cloud platform for power IoT, which uses SpringBoot + MySQL + MongoDB + JPA/MyBatis for backend and Vue2 + iView + eCharts for frontend
- Developed a PDF report generator service based on Express.js + node-canvas + eCharts + LaTeX, where images are generated using node-canvas + eCharts

#colbreak()

*Shanghai Tianxin Technology Co.,Ltd*, Shanghai, China #h(1fr) 2020.6 - 2021.3

_Fullstack engineer_

- Designed and implemented a protocol for uploading videos and audios from low-bandwidth embedded devices to the cloud.
- Implemented an audio and video encoder based on FFmpeg, which encodes the audio and video files uploaded by IoT devices into formats that can be played directly by mainstream browsers and video players (MP4 container + H264 video stream + YUV420P frame + AAC audio).
- Implemented the connection between the encoding server and the Node.js business server through RPC over HTTP.
- Helped solving several problems with the OV5640 camera on IoT devices.
- Implemented a utility for testing WebRTC servers, which uses the same technology as the selected alternative for WebRTC clients.

*Sourcebrella Inc.*, Shenzhen, China #h(1fr) 2018.7 - 2018.9

_Compiler engineer_

- Investigated bugs of clang-3.6, fixed them by writing patches and porting patches from higher versions of clang. Made eosio, Firefox, Android and some other projects compile with clang-3.6.
- Introduced a WebAssembly backend (skeleton only) to llvm-3.6, making it capable of generating LLVM IR targeting WebAssembly.

= Personal projects
#line(length: 100%)

*2V64*, Rust asynchronous runtime #h(1fr) #link("https://github.com/chuigda/2V64", text(blue, "https://github.com/chuigda/2V64"))

_Rust, Unix, async_

- Simple single-thread/multi-thread Rust asyncronous runtime.
- Implemented TCP socket based on Unix `poll` API (two ways: hand-written `Future` and using tokio `AsyncRead`/`AsyncWrite`), and implemented a small HTTP server based on this.

*9T56*, Type theory research #h(1fr) #link("https://github.com/chuigda/9T56", text(blue, "https://github.com/chuigda/9T56"))

_ML, Python, Typst, Type theory_

- Translated paper #link("http://lucacardelli.name/Papers/BasicTypechecking%20(TR%201984).pdf", text(blue, "Basic Polymorphic Typechecking")) and blog #link("https://jeremymikkola.com/posts/2018_03_25_understanding_algorithm_w.html", text(blue, "Understanding Algorithm W"))
- Implemented algorithm $cal(W)$ in the paper _Understanding Algorithm W_ and algorithm $cal(J)$ in _Basic Polymorphic Typechecking_ using Python.
- Designed additional language features (mainly imperative features) and their type checking rules, which are not included in standard ML.

*3N112*, Graphics and General Computing Research Platform #h(1fr) #link("https://github.com/club-doki7/3N112", text(blue, "https://github.com/club-doki7/3N112"))

_Java, Vulkan, CG_

- Designed and implemented a complete set of Vulkan context core and supporting abstractions based on user experience, actual needs, and Vulkan features.
- Implemented automatic resource reclamation for Vulkan resources based on Java garbage collection, `AutoClosable`, `Cleaner`, and delayed reclamation mechanisms.
- Conducted various graphics and general computing experiments based on these encapsulated features.

#colbreak()

*Project-602*, Chess software #h(1fr) #link("https://github.com/chuigda/Project-602", text(blue, "https://github.com/chuigda/Project-602"))

_JavaScript, HTML5, WebGL, CG_

- Designed and implemented user interface with Vanilla JavaScript.
- Designed and implemented highly stylized 3D chessboard rendering based on WebGL.
- Implemented games against AI with fairy-stockfish engine through WebAssembly.
- Designed and implemented a highly extensible script system based on JavaScript, and developed a visual editor based on Blockly, which can achieve interactive teaching functions similar to game BOT.vinnik or software PyChess.

*vulkan4j*, Java CG API bindings based on FFM #h(1fr) #link("https://vulkan4j.doki7.club", text(blue, "https://vulkan4j.doki7.club"))

_Java, Kotlin, Vulkan, OpenGL, WebGPU, OpenAL, CG_

- Designed and implemented extraction of function and type definitions from Vulkan registry `vk.xml`/`video.xml`, OpenGL registry `gl.xml`, WebGPU registry `WebGPU.yml`, Vulkan memory allocator header file `vma.h`, GLFW header file `glfw3.h`/`glfw3native.h` and so on, using automatic program. Java bindings are generated from these extracted metadata.
- Provided moderate Java abstractions to make these APIs easier to use and more type-safe.
- Ported full Vulkan-Tutorial and partial LearnOpenGL tutorial based on the bound APIs.

*Project-WG*, 3D VTuber #h(1fr) #link("https://github.com/chuigda/Project-WG", text(blue, "https://github.com/chuigda/Project-WG"))

_C++, Qt, OpenGL, CG_

- Implemented renderer with C++, Qt and OpenGL (traditional fixed pipeline).
- Implemented face tracking data recever: via UDP from OpenSeeFace or WebSocket from VTubeStudio.
- Implemeted extensible plugin system, supporting plugins written in C++.

*Project-PL5*, Scheme dialect #h(1fr) #link("https://github.com/chuigda/Project-PL5", text(blue, "https://github.com/chuigda/Project-PL5"))

_C, Compiler_

- Imperative first Scheme dialect with special built-in function mechanism.
- Implemented error handling scheme based on C `setjmp` and `longjump`, which can print stack trace and recover from errors.
- Can be extended through C API, and also supports Rust.

= Miscellaneous
#line(length: 100%)

- Contributed to opensource projects *flomonster/easy-gltf * (_Rust_), *franciscoBSalgueiro/en-croissant* (_JavaScript + Rust_), *durch/rust-s3* (_Rust_), *webrtc-rs/webrtc* (_Rust_), *KyleMayes/vulkanalia* (_Rust_) and *open-webrtc-toolkit/owt-client-native* (_C++_).
- Attended Rust China Conference 2020 as a lecturer.
- In 2019 Tianjin Lanqiao training, the Hahadoop OJ (online judging system, supporting distributed judging machines) developed by me won the excellent training project award.
- Got 310/500 in CCF-CSP in 2018
- Got the second prize in the provincial competition of Lanqiao Cup in 2017
