// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interface/no_prelude/import_interface_decl.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interface/no_prelude/import_interface_decl.carbon

// --- a.carbon
library "[[@TEST_NAME]]";
interface A;

// --- a.impl.carbon
impl library "[[@TEST_NAME]]";

// --- fail_b.carbon
library "[[@TEST_NAME]]";
interface B {}
// CHECK:STDERR: fail_b.carbon:[[@LINE+3]]:1: error: impl declared but not defined [MissingImplDefinition]
// CHECK:STDERR: impl () as B;
// CHECK:STDERR: ^~~~~~~~~~~~~
impl () as B;

// --- b.impl.carbon
impl library "[[@TEST_NAME]]";

// CHECK:STDOUT: --- a.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %A.type: type = facet_type <@A> [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = %A.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %A.decl: type = interface_decl @A [template = constants.%A.type] {} {}
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @A;
// CHECK:STDOUT:
// CHECK:STDOUT: --- a.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref = import_ref Main//a, A, unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .A = imports.%import_ref
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc1_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc1_6.2 = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_b.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %B.type: type = facet_type <@B> [template]
// CHECK:STDOUT:   %Self: %B.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .B = %B.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %B.decl: type = interface_decl @B [template = constants.%B.type] {} {}
// CHECK:STDOUT:   impl_decl @impl [template] {} {
// CHECK:STDOUT:     %.loc6_7.1: %empty_tuple.type = tuple_literal ()
// CHECK:STDOUT:     %.loc6_7.2: type = converted %.loc6_7.1, constants.%empty_tuple.type [template = constants.%empty_tuple.type]
// CHECK:STDOUT:     %B.ref: type = name_ref B, file.%B.decl [template = constants.%B.type]
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @B {
// CHECK:STDOUT:   %Self: %B.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl: %.loc6_7.2 as %B.ref;
// CHECK:STDOUT:
// CHECK:STDOUT: --- b.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %B.type: type = facet_type <@B> [template]
// CHECK:STDOUT:   %empty_tuple.type: type = tuple_type () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Main//b, B, unloaded
// CHECK:STDOUT:   %import_ref.2 = import_ref Main//b, inst15 [no loc], unloaded
// CHECK:STDOUT:   %import_ref.3: type = import_ref Main//b, loc6_7, loaded [template = constants.%empty_tuple.type]
// CHECK:STDOUT:   %import_ref.4: type = import_ref Main//b, loc6_12, loaded [template = constants.%B.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .B = imports.%import_ref.1
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %default.import.loc1_6.1 = import <invalid>
// CHECK:STDOUT:   %default.import.loc1_6.2 = import <invalid>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @B [from "fail_b.carbon"] {
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = imports.%import_ref.2
// CHECK:STDOUT:   witness = ()
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl: imports.%import_ref.3 as imports.%import_ref.4 [from "fail_b.carbon"];
// CHECK:STDOUT:
