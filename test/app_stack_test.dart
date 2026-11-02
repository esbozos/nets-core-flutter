import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nets_core/app_stack.dart';

void main() {
  Future<GoRouter> mount(
    WidgetTester tester, {
    bool material = true,
    bool visible = true,
    String initialLocation = '/chats',
  }) async {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: (_, state, child) => AppStack(
            title: 'Test',
            useMaterialNavigation: material,
            showNavBar: visible,
            menu: [
              AppStackMenuItem(
                location: '/chats',
                label: 'Chats',
                icon: Icons.forum,
                badge: 120,
                matchLocations: ['/project/'],
              ),
              AppStackMenuItem(
                location: '/account',
                label: 'Account',
                icon: Icons.person,
              ),
            ],
            child: child,
          ),
          routes: [
            for (final path in [
              '/chats',
              '/chats/:id',
              '/project/:id',
              '/account',
              '/account/privacy',
              '/other',
            ])
              GoRoute(
                path: path,
                builder: (_, state) => Scaffold(
                  body: Center(child: Text(state.uri.path)),
                ),
              ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
    return router;
  }

  setUp(() {
    AppState.showNavBar.value = false;
    AppState.navigationItems = [];
    AppState.mapScreen = {};
  });

  testWidgets('Material bar reserves space and retains labels and badges',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await mount(tester);
    expect(find.byType(ConvexAppBar), findsNothing);
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('99+'), findsWidgets);
    final bar = tester.getRect(find.byType(NavigationBar));
    final body = tester.getRect(find.byType(Scaffold).last);
    expect(body.bottom, lessThanOrEqualTo(bar.top));
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('routes, query parameters, aliases and back keep selection',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router =
        await mount(tester, initialLocation: '/account/privacy?from=settings');
    int selection() =>
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;
    expect(selection(), 1);
    router.push('/project/42');
    await tester.pumpAndSettle();
    expect(selection(), 0);
    router.pop();
    await tester.pumpAndSettle();
    expect(selection(), 1);
    router.go('/chats/5?filter=unread');
    await tester.pumpAndSettle();
    expect(selection(), 0);
    router.go('/account');
    await tester.pumpAndSettle();
    router.go('/other');
    await tester.pumpAndSettle();
    expect(selection(), 0);
  });

  for (final size in [const Size(390, 844), const Size(1024, 768)]) {
    testWidgets('visibility is respected at $size', (tester) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await mount(tester, visible: false);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byType(NavigationRail), findsNothing);
    });
  }

  testWidgets('Material bar hides while keyboard is open', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await mount(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('legacy consumers still get convex navigation', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await mount(tester, material: false);
    expect(find.byType(ConvexAppBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
