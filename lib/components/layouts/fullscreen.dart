import 'package:flutter/material.dart';

class FullScreenLayout extends StatefulWidget {
  const FullScreenLayout({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.footer,
    this.header,
    this.backgroundColor,
    this.gradient,
  });
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final String? title;
  final String? subtitle;
  final Widget? footer;
  final Widget? header;

  @override
  State<FullScreenLayout> createState() => _FullScreenLayoutState();
}

class _FullScreenLayoutState extends State<FullScreenLayout> {
  final Gradient defaultGradientBg = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF0D002A),
      Color(0xFF1A002A),
      Color(0xFF09007F),
      Color(0xFFA800FF),
    ],
    stops: <double>[0.0, 0.3, 0.7, 1.0],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          // systemOverlayStyle: const SystemUiOverlayStyle(
          //     // statusBarIconBrightness: Brightness.light,
          //     // statusBarColor: Colors.transparent,
          //     ),
          // backgroundColor: Colors.transparent,
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        // resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: Container(
            // decoration: BoxDecoration(
            //     // backgroundBlendMode: BlendMode.darken,
            //     // color: widget.backgroundColor,
            //     // gradient: widget.gradient ?? defaultGradientBg
            //     ),
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: SafeArea(
              top: true,
              bottom: true,
              right: true,
              left: true,
              maintainBottomViewPadding: true,
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.header != null) widget.header!,
                      if (widget.title != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, bottom: 20, left: 20, right: 20),
                          child: Text(widget.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              textAlign: TextAlign.center),
                        ),
                      if (widget.subtitle != null)
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 20, left: 20, right: 20),
                            child: Text(
                              widget.subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              textAlign: TextAlign.center,
                            )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [widget.child],
                        ),
                      ),
                      if (widget.footer != null)
                        const SizedBox(
                          height: 20,
                        ),
                      if (widget.footer != null) widget.footer!
                    ]),
              ),
            )));
  }
}
