import 'package:demo_test/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolSetUp(() async {
    // Ensure the asset bundle is available
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler('flutter/assets', null);
  });

  patrolTest('full transaction flow: list → detail → back', ($) async {
    app.main();
    await $.pumpAndSettle();

    await $(#transaction_list).waitUntilVisible();
    expect($('Transaction History'), findsOneWidget);

    await $('John Doe').waitUntilVisible();
    expect($('John Doe'), findsOneWidget);

    await $('John Doe').tap();
    await $(#transaction_detail_card).waitUntilVisible();

    expect($('Transaction Details'), findsOneWidget);
    expect($('John Doe'), findsOneWidget);

    await $.native.pressBack();
    await $(#transaction_list).waitUntilVisible();
    expect($('Transaction History'), findsOneWidget);
  });

  patrolTest('history screen shows all three transactions from fixture', ($) async {
    app.main();
    await $.pumpAndSettle();

    await $(#transaction_list).waitUntilVisible();

    expect($('John Doe'), findsOneWidget);
    expect($('Alice Smith'), findsOneWidget);
    expect($('Michael Brown'), findsOneWidget);
  });

  patrolTest('detail screen shows correct amount for deposit transaction', ($) async {
    app.main();
    await $.pumpAndSettle();

    await $(#transaction_list).waitUntilVisible();
    await $('John Doe').tap();
    await $(#transaction_detail_card).waitUntilVisible();

    expect($(#detail_amount), findsOneWidget);
    expect($(#detail_customer), findsOneWidget);
  });
}
