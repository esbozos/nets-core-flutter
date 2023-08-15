import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppState {
  static Map<int, String> mapScreen = {};
  static ValueNotifier<bool> showNavBar = ValueNotifier(false);
  static ValueNotifier<bool> showAppBar = ValueNotifier(false);

  static List<AppStackMenuItem> navigationItems = [];
}

class AppStackMenuItem {
  final String location;
  final String label;
  final IconData icon;

  final Widget Function(BuildContext context, bool active)? itemBuilder;

  AppStackMenuItem(
      {required this.label,
      required this.location,
      required this.icon,
      this.itemBuilder});
}

class AppStack extends ConsumerStatefulWidget {
  const AppStack(
      {Key? key,
      required this.child,
      required this.title,
      required this.menu,
      this.activeColor,
      this.activeGradient,
      this.inactiveColor})
      : super(key: key);
  final Widget child;
  final String title;
  final Color? activeColor;
  final Color? inactiveColor;
  final Gradient? activeGradient;
  final List<AppStackMenuItem> menu;

  @override
  ConsumerState<AppStack> createState() => _AppStackState();
}

class _AppStackState extends ConsumerState<AppStack> {
  String? purchaseStatus;
  final GlobalKey<ConvexAppBarState> _appBarKey =
      GlobalKey<ConvexAppBarState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    buildNavigation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateProviders();
    });
    // updateProviders();
  }

  void updateProviders() {
    // var user = ref.read(authProvider);

    // Auth user = Provider.of<Auth>(context, listen: false);
    // Profile p = Provider.of<Profile>(context, listen: false);
    // if (user.user != null) {
    // ref.read(profileProvider.notifier).setUserProfiles(user.user!.profiles);

    // p.setUserProfiles(user.user!.profiles ?? []);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.showNavBar,
      builder: (context, showBar, child) {
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(child: widget.child),
          bottomNavigationBar: !showBar
              ? null
              : ConvexAppBar.builder(
                  key: _appBarKey,
                  // gradient: logoGradient,
                  curveSize: 0,
                  initialActiveIndex: 0,
                  count: AppState.navigationItems.length,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onTap: (index) => context.go(AppState.mapScreen[index]!),
                  itemBuilder: NavItemBuilder(
                      ref: ref,
                      items: widget.menu,
                      activeColor: widget.activeColor,
                      activeGradient: widget.activeGradient,
                      inactiveColor: widget.inactiveColor),
                  // shadowColor: Colors.white,
                  //  activeColor: Colors.white,
                  // backgroundColor: Colors.transparent,
                  // items: AppState.navigationTabItems
                ),
        );
      },
    );
  }

  void buildNavigation() {
    int counter = 0;
    AppState.navigationItems = [];

    for (var i in widget.menu) {
      AppState.mapScreen[counter] = i.location;

      AppState.navigationItems.add(i);
      counter++;
    }
    AppState.showNavBar.value = true;
  }
}

class NavItemBuilder extends DelegateBuilder {
  List<AppStackMenuItem> items;
  WidgetRef ref;
  Color? activeColor;
  Gradient? activeGradient;
  Color? inactiveColor;
  NavItemBuilder(
      {required this.ref,
      required this.items,
      this.activeColor = Colors.white,
      this.activeGradient,
      this.inactiveColor});

  @override
  Widget build(BuildContext context, int index, bool active) {
    var u;

    return Stack(
      alignment: Alignment.center,
      children: [
        // circle shape background
        Container(
          width: active ? 60 : 30,
          height: active ? 60 : 30,
          decoration: BoxDecoration(
            gradient: active ? activeGradient : null,
            color: active
                ? activeColor ?? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(90),
          ),
          alignment: Alignment.center,
        ),
        // icon
        items[index].itemBuilder != null
            ? items[index].itemBuilder!(context, active)
            : Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[index].icon,
                          color: active
                              ? activeColor ?? Colors.white
                              : inactiveColor ?? Colors.white),
                    ]),
              ),
      ],
    );
  }
}
