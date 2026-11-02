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
      {super.key,
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
      this.useMaterialNavigation = false,
      this.appBar,
      this.listener});
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
  final AppBar? appBar;
  final bool showNavBar;

  /// Uses an in-flow, labelled Material bar instead of the legacy convex bar.
  final bool useMaterialNavigation;
  final Function(BuildContext context, WidgetRef ref)? listener;

  @override
  ConsumerState<AppStack> createState() => _AppStackState();
}

class _AppStackState extends ConsumerState<AppStack> {
  String? purchaseStatus;
  int _selectedIndex = 0;
  final GlobalKey<ConvexAppBarState> _appBarKey =
      GlobalKey<ConvexAppBarState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  GoRouterDelegate? _routerDelegate;
  VoidCallback? _routeListener;

  @override
  void initState() {
    super.initState();
    buildNavigation();
    if (widget.listener != null) {
      widget.listener!(context, ref);
    }
  }

  @override
  void didUpdateWidget(covariant AppStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    AppState.navigationItems = widget.menu;
    AppState.mapScreen = {
      for (var index = 0; index < widget.menu.length; index++)
        index: widget.menu[index].location,
    };
    _handleRouteInformationChanged();
  }

  @override
  void dispose() {
    if (_routeListener != null) {
      _routerDelegate?.removeListener(_routeListener!);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateProviders();
    final routerDelegate = GoRouter.of(context).routerDelegate;
    if (_routerDelegate != routerDelegate) {
      if (_routeListener != null) {
        _routerDelegate?.removeListener(_routeListener!);
      }
      _routerDelegate = routerDelegate;
      _routeListener = _handleRouteInformationChanged;
      _routerDelegate?.addListener(_routeListener!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRouteInformationChanged();
    });
  }

  void _handleRouteInformationChanged() {
    if (!mounted) return;
    bool match = false;
    String locationPath = GoRouter.of(context).state.uri.path;
    debugPrint('nets-core-flutter: locationPath: $locationPath');
    for (var i in AppState.navigationItems) {
      // check if location starts with any of the matchLocations
      if (i.location == locationPath ||
          (widget.useMaterialNavigation &&
              locationPath.startsWith('${i.location}/'))) {
        debugPrint('nets-core-flutter: match: ${i.location}');
        int index = AppState.navigationItems.indexOf(i);
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
        }
        _tabController?.animateTo(index);
        _appBarKey.currentState?.animateTo(index);
        match = true;
        break;
      }
      if (i.matchLocations.isNotEmpty) {
        for (var j in i.matchLocations) {
          if (locationPath.startsWith(j)) {
            debugPrint('nets-core-flutter: match: $j');
            int index = AppState.navigationItems.indexOf(i);
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
              });
            }
            if (_tabController != null && _tabController!.index != index) {
              _tabController?.animateTo(index);
            }
            _appBarKey.currentState?.animateTo(index);
            match = true;
            break;
          }
        }
        if (match) break;
      }
    }
    if (!match) {
      if (widget.useMaterialNavigation && _selectedIndex != 0) {
        setState(() => _selectedIndex = 0);
      }
      _tabController?.animateTo(0);
      _appBarKey.currentState?.animateTo(0);
    }
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

  Widget navigationWithBottomAppBar() {
    if (widget.useMaterialNavigation) {
      Widget iconFor(AppStackMenuItem item, bool active) {
        final icon = item.itemBuilder?.call(context, active) ?? Icon(item.icon);
        return Badge(
          isLabelVisible: (item.badge ?? 0) > 0,
          label: Text((item.badge ?? 0) > 99 ? '99+' : '${item.badge ?? 0}'),
          child: icon,
        );
      }

      return NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            context.go(widget.menu[index].location),
        destinations: widget.menu
            .map((item) => NavigationDestination(
                  icon: iconFor(item, false),
                  selectedIcon: iconFor(item, true),
                  label: item.label,
                ))
            .toList(),
      );
    }
    return ConvexAppBar.builder(
      key: _appBarKey,
      controller: _tabController,
      // gradient: logoGradient,
      curveSize: 0,
      initialActiveIndex: 0,
      count: AppState.navigationItems.length,
      backgroundColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.showNavBar,
      builder: (context, showNavBar, child) {
        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Scaffold(
                key: _scaffoldKey,
                appBar: widget.appBar,
                body: Row(children: [
                  if (showNavBar && widget.showNavBar)
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        context.go(AppState.mapScreen[index]!);
                      },
                      labelType: NavigationRailLabelType.selected,
                      destinations: AppState.navigationItems
                          .map((e) => NavigationRailDestination(
                                icon: Icon(e.icon),
                                label: Text(e.label),
                              ))
                          .toList(),
                    ),
                  if (showNavBar && widget.showNavBar)
                    const VerticalDivider(thickness: 1, width: 1),
                  Expanded(child: widget.child)
                ]));
          } else {
            return Scaffold(
              key: _scaffoldKey,
              body: SafeArea(child: widget.child),
              bottomNavigationBar: !showNavBar ||
                      !widget.showNavBar ||
                      (widget.useMaterialNavigation &&
                          MediaQuery.viewInsetsOf(context).bottom > 0)
                  ? null
                  : navigationWithBottomAppBar(),
            );
          }
        });
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
