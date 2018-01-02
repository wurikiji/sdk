// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:expect/expect.dart';
import 'package:async_helper/async_helper.dart';
import '../compiler_helper.dart';

const String TEST_ONE = r"""
  foo(b) {
    var a = b ? [1,2,3] : null;
    print(a.first);
  }
""";

main() {
  runTest({bool useKernel}) async {
    // Check that almost-constant interceptor is used.
    await compile(TEST_ONE, entry: 'foo', useKernel: useKernel,
        check: (String generated) {
      String re = r'a && [\w\.]*_methods';
      Expect.isTrue(generated.contains(new RegExp(re)), 'contains /$re/');
    });
  }

  asyncTest(() async {
    print('--test from ast---------------------------------------------------');
    await runTest(useKernel: false);
    print('--test from kernel------------------------------------------------');
    await runTest(useKernel: true);
  });
}
