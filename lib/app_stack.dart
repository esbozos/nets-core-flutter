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
  final int? badge;
  final List<String> matchLocations;

  final Widget Function(BuildContext context, bool active)? itemBuilder;

  AppStackMenuItem(
      {required this.label,
      required this.location,
      required this.icon,
      this.itemBuilder,
      this.badge,
      this.matchLocations = const []});
}

class AppStack extends ConsumerStatefulWidget {
  const AppStack(
      {Key? key,
      required this.child,
      required this.title,
      required this.menu,
      this.activeColor,
      this.activeGradient,
      this.inactiveColor,
      this.backgroundColor,
      this.activeBackgroundColor,
      this.inactiveBackgroundColor,
      this.showAppBar = false,
      this.showNavBar = true,
      this.listener})
      : super(key: key);
  final Widget child;
  final String title;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? inactiveBackgroundColor;
  final Gradient? activeGradient;
  final List<AppStackMenuItem> menu;
  final bool showAppBar;
  final bool showNavBar;
  final Function(BuildContext context, WidgetRef ref)? listener;

  @override
  ConsumerState<AppStack> createState() => _AppStackState();
}

class _AppStackState extends ConsumerState<AppStack> {
  String? purchaseStatus;
  final GlobalKey<ConvexAppBarState> _appBarKey =
      GlobalKey<ConvexAppBarState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    buildNavigation();
    if (widget.listener != null) {
      widget.listener!(context, ref);
    }
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
      // add listen to GoRouter.of(context).location
      GoRouter.of(context).routeInformationProvider.addListener(() {
        bool _match = false;
        String locationPath = GoRouter.of(context)
            .routerDelegate
            .currentConfiguration
            .uri
            .toString();
        debugPrint('nets-core-flutter: locationPath: $locationPath');
        for (var i in AppState.navigationItems) {
          // check if location starts with any of the matchLocations
          if (i.location == locationPath) {
            int index = AppState.navigationItems.indexOf(i);
            _tabController?.animateTo(index);
            _match = true;
            break;
          }
          if (i.matchLocations.isNotEmpty) {
            for (var j in i.matchLocations) {
              if (locationPath.startsWith(j)) {
                int index = AppState.navigationItems.indexOf(i);
                _tabController?.animateTo(index);
                _match = true;
                break;
              }
            }
          }
        }
        if (!_match) {
          _tabController?.animateTo(0);
        }
      });
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
      builder: (context, showNavBar, child) {
        return Scaffold(
          key: _scaffoldKey,
          body: SafeArea(child: widget.child),
          bottomNavigationBar: !showNavBar
              ? null
              : ConvexAppBar.builder(
                  key: _appBarKey,
                  controller: _tabController,
                  // gradient: logoGradient,
                  curveSize: 0,
                  initialActiveIndex: 0,
                  count: AppState.navigationItems.length,
                  backgroundColor: widget.backgroundColor ??
                      Theme.of(context).colorScheme.primary,
                  onTap: (index) => context.go(AppState.mapScreen[index]!),
                  itemBuilder: NavItemBuilder(
                      ref: ref,
                      items: widget.menu,
                      activeColor: widget.activeColor,
                      activeGradient: widget.activeGradient,
                      inactiveColor: widget.inactiveColor,
                      backgroundColor: widget.backgroundColor,
                      activeBackgroundColor: widget.activeBackgroundColor,
                      inactiveBackgroundColor: widget.inactiveBackgroundColor),
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
  Color? backgroundColor;
  Color? inactiveBackgroundColor;
  Color? activeBackgroundColor;

  NavItemBuilder(
      {required this.ref,
      required this.items,
      this.activeColor = Colors.white,
      this.activeGradient,
      this.inactiveColor,
      this.backgroundColor,
      this.inactiveBackgroundColor,
      this.activeBackgroundColor});

  @override
  Widget build(BuildContext context, int index, bool active) {
    Color bgColor = active
        ? activeBackgroundColor ?? Theme.of(context).colorScheme.primary
        : inactiveBackgroundColor ?? Colors.transparent;

    Color iconColor = active
        ? activeColor ?? Theme.of(context).colorScheme.onPrimary
        : inactiveColor ?? Theme.of(context).colorScheme.inversePrimary;

    return Stack(
      alignment: Alignment.center,
      children: [
        // circle shape background
        Container(
          width: active ? 60 : 30,
          height: active ? 60 : 30,
          decoration: BoxDecoration(
            gradient: active ? activeGradient : null,
            color: bgColor,
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
                          color: iconColor, size: active ? 30 : 20),
                    ]),
              ),
        // badge
        items[index].badge != null && items[index].badge! > 0
            ? Positioned(
                top: 5,
                right: 15,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    items[index].badge! > 99
                        ? '99+'
                        : items[index].badge.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
