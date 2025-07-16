import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// context가 pop 가능하면 pop, 아니면 fallback 경로로 이동합니다.
void smartBack(BuildContext context, {String fallback = '/'}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallback);
  }
}
