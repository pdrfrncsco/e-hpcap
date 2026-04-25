import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpcapp/main.dart';
import 'package:flutter/material.dart';
import 'package:hpcapp/core/constants/environment.dart';

void main() {
  setUpAll(() {
    // Inicializar o ambiente para os testes
    AppEnvironment.setup(Environment.dev);
  });

  testWidgets('A aplicação deve inicializar e mostrar o ecrã Devocional por padrão', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HPCApp(),
      ),
    );

    // Wait for GoRouter to finish its initial navigation
    await tester.pumpAndSettle();

    // Verify that Devocional is the first screen shown.
    expect(find.text('Devocional'), findsWidgets);
    
    // Verify that the NavigationBar is present
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('A navegação deve alterar os ecrãs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HPCApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on the 'Hinário' icon in the NavigationBar
    await tester.tap(find.text('Hinário').last);
    await tester.pumpAndSettle();

    // Verify that the Hinário screen is shown
    expect(find.text('Hinário'), findsWidgets);
    expect(find.text('Lista de Hinos HPC'), findsOneWidget);
  });
}
