// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/struct/import.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/struct/import.carbon

// --- implicit.carbon

package Implicit;

var a_ref: {.a: i32} = {.a = 0};
var b_ref: {.a: {.b: i32, .c: (i32,)}, .d: i32} =
    {.a = {.b = 0, .c = (0,)}, .d = 0};

class C(S:! {.a: i32, .b: i32}) {}
fn F() -> C({.a = 1, .b = 2});

// --- implicit.impl.carbon

impl package Implicit;

var a: {.a: i32} = a_ref;
var b: {.a: {.b: i32, .c: (i32,)}, .d: i32} = b_ref;
var c: C({.a = 1, .b = 2}) = F();

// --- fail_bad_type.impl.carbon

impl package Implicit;
// CHECK:STDERR: fail_bad_type.impl.carbon:[[@LINE+8]]:14: error: missing value for field `a` in struct initialization [StructInitMissingFieldInLiteral]
// CHECK:STDERR: var c_bad: C({.c = 1, .d = 2}) = F();
// CHECK:STDERR:              ^~~~~~~~~~~~~~~~
// CHECK:STDERR: fail_bad_type.impl.carbon:[[@LINE-4]]:6: in import [InImport]
// CHECK:STDERR: implicit.carbon:8:1: note: while deducing parameters of generic declared here [DeductionGenericHere]
// CHECK:STDERR: class C(S:! {.a: i32, .b: i32}) {}
// CHECK:STDERR: ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CHECK:STDERR:
var c_bad: C({.c = 1, .d = 2}) = F();

// --- fail_bad_value.impl.carbon

impl package Implicit;
// CHECK:STDERR: fail_bad_value.impl.carbon:[[@LINE+6]]:1: error: cannot implicitly convert from `C({.a = 1, .b = 2})` to `C({.a = 3, .b = 4})` [ImplicitAsConversionFailure]
// CHECK:STDERR: var c_bad: C({.a = 3, .b = 4}) = F();
// CHECK:STDERR: ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// CHECK:STDERR: fail_bad_value.impl.carbon:[[@LINE+3]]:1: note: type `C({.a = 1, .b = 2})` does not implement interface `Core.ImplicitAs(C({.a = 3, .b = 4}))` [MissingImplInMemberAccessNote]
// CHECK:STDERR: var c_bad: C({.a = 3, .b = 4}) = F();
// CHECK:STDERR: ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
var c_bad: C({.a = 3, .b = 4}) = F();

// CHECK:STDOUT: --- implicit.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %struct_type.a.1: type = struct_type {.a: %i32} [template]
// CHECK:STDOUT:   %int_0.1: Core.IntLiteral = int_value 0 [template]
// CHECK:STDOUT:   %struct_type.a.2: type = struct_type {.a: Core.IntLiteral} [template]
// CHECK:STDOUT:   %Convert.type.2: type = fn_type @Convert.1, @ImplicitAs(%i32) [template]
// CHECK:STDOUT:   %Convert.type.10: type = fn_type @Convert.2, @impl.1(%int_32) [template]
// CHECK:STDOUT:   %Convert.10: %Convert.type.10 = struct_value () [template]
// CHECK:STDOUT:   %interface.19: <witness> = interface_witness (%Convert.10) [template]
// CHECK:STDOUT:   %Convert.bound.1: <bound method> = bound_method %int_0.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.1: <specific function> = specific_function %Convert.bound.1, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_0.2: %i32 = int_value 0 [template]
// CHECK:STDOUT:   %struct.1: %struct_type.a.1 = struct_value (%int_0.2) [template]
// CHECK:STDOUT:   %tuple.type.2: type = tuple_type (%i32) [template]
// CHECK:STDOUT:   %struct_type.b.c.1: type = struct_type {.b: %i32, .c: %tuple.type.2} [template]
// CHECK:STDOUT:   %struct_type.a.d.1: type = struct_type {.a: %struct_type.b.c.1, .d: %i32} [template]
// CHECK:STDOUT:   %tuple.type.3: type = tuple_type (Core.IntLiteral) [template]
// CHECK:STDOUT:   %struct_type.b.c.2: type = struct_type {.b: Core.IntLiteral, .c: %tuple.type.3} [template]
// CHECK:STDOUT:   %struct_type.a.d.3: type = struct_type {.a: %struct_type.b.c.2, .d: Core.IntLiteral} [template]
// CHECK:STDOUT:   %tuple: %tuple.type.2 = tuple_value (%int_0.2) [template]
// CHECK:STDOUT:   %struct.2: %struct_type.b.c.1 = struct_value (%int_0.2, %tuple) [template]
// CHECK:STDOUT:   %struct.3: %struct_type.a.d.1 = struct_value (%struct.2, %int_0.2) [template]
// CHECK:STDOUT:   %struct_type.a.b.1: type = struct_type {.a: %i32, .b: %i32} [template]
// CHECK:STDOUT:   %S: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [template]
// CHECK:STDOUT:   %C.1: type = class_type @C, @C(%S) [symbolic]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %int_1.1: Core.IntLiteral = int_value 1 [template]
// CHECK:STDOUT:   %int_2.1: Core.IntLiteral = int_value 2 [template]
// CHECK:STDOUT:   %struct_type.a.b.2: type = struct_type {.a: Core.IntLiteral, .b: Core.IntLiteral} [template]
// CHECK:STDOUT:   %Convert.bound.2: <bound method> = bound_method %int_1.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.2: <specific function> = specific_function %Convert.bound.2, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_1.2: %i32 = int_value 1 [template]
// CHECK:STDOUT:   %Convert.bound.3: <bound method> = bound_method %int_2.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.3: <specific function> = specific_function %Convert.bound.3, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_2.2: %i32 = int_value 2 [template]
// CHECK:STDOUT:   %struct.4: %struct_type.a.b.1 = struct_value (%int_1.2, %int_2.2) [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%struct.4) [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     .ImplicitAs = %import_ref.5
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .a_ref = %a_ref
// CHECK:STDOUT:     .b_ref = %b_ref
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %a_ref.var: ref %struct_type.a.1 = var a_ref
// CHECK:STDOUT:   %a_ref: ref %struct_type.a.1 = bind_name a_ref, %a_ref.var
// CHECK:STDOUT:   %b_ref.var: ref %struct_type.a.d.1 = var b_ref
// CHECK:STDOUT:   %b_ref: ref %struct_type.a.d.1 = bind_name b_ref, %b_ref.var
// CHECK:STDOUT:   %C.decl: %C.type = class_decl @C [template = constants.%C.generic] {
// CHECK:STDOUT:     %S.patt.loc8_9.1: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic = %S.patt.loc8_9.2 (constants.%S.patt)]
// CHECK:STDOUT:     %S.param_patt: %struct_type.a.b.1 = value_param_pattern %S.patt.loc8_9.1, runtime_param<invalid> [symbolic = %S.patt.loc8_9.2 (constants.%S.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %S.param: %struct_type.a.b.1 = value_param runtime_param<invalid>
// CHECK:STDOUT:     %.loc8: type = splice_block %struct_type.a.b [template = constants.%struct_type.a.b.1] {
// CHECK:STDOUT:       %int_32.loc8_18: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc8_18: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %int_32.loc8_27: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc8_27: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %struct_type.a.b: type = struct_type {.a: %i32, .b: %i32} [template = constants.%struct_type.a.b.1]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %S.loc8_9.1: %struct_type.a.b.1 = bind_symbolic_name S, 0, %S.param [symbolic = %S.loc8_9.2 (constants.%S)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %return.patt: %C.2 = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %C.2 = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %C.ref: %C.type = name_ref C, file.%C.decl [template = constants.%C.generic]
// CHECK:STDOUT:     %int_1: Core.IntLiteral = int_value 1 [template = constants.%int_1.1]
// CHECK:STDOUT:     %int_2: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:     %.loc9_28.1: %struct_type.a.b.2 = struct_literal (%int_1, %int_2)
// CHECK:STDOUT:     %impl.elem0.loc9_28.1: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:     %Convert.bound.loc9_28.1: <bound method> = bound_method %int_1, %impl.elem0.loc9_28.1 [template = constants.%Convert.bound.2]
// CHECK:STDOUT:     %Convert.specific_fn.loc9_28.1: <specific function> = specific_function %Convert.bound.loc9_28.1, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.2]
// CHECK:STDOUT:     %int.convert_checked.loc9_28.1: init %i32 = call %Convert.specific_fn.loc9_28.1(%int_1) [template = constants.%int_1.2]
// CHECK:STDOUT:     %.loc9_28.2: %i32 = value_of_initializer %int.convert_checked.loc9_28.1 [template = constants.%int_1.2]
// CHECK:STDOUT:     %.loc9_28.3: %i32 = converted %int_1, %.loc9_28.2 [template = constants.%int_1.2]
// CHECK:STDOUT:     %impl.elem0.loc9_28.2: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:     %Convert.bound.loc9_28.2: <bound method> = bound_method %int_2, %impl.elem0.loc9_28.2 [template = constants.%Convert.bound.3]
// CHECK:STDOUT:     %Convert.specific_fn.loc9_28.2: <specific function> = specific_function %Convert.bound.loc9_28.2, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.3]
// CHECK:STDOUT:     %int.convert_checked.loc9_28.2: init %i32 = call %Convert.specific_fn.loc9_28.2(%int_2) [template = constants.%int_2.2]
// CHECK:STDOUT:     %.loc9_28.4: %i32 = value_of_initializer %int.convert_checked.loc9_28.2 [template = constants.%int_2.2]
// CHECK:STDOUT:     %.loc9_28.5: %i32 = converted %int_2, %.loc9_28.4 [template = constants.%int_2.2]
// CHECK:STDOUT:     %struct: %struct_type.a.b.1 = struct_value (%.loc9_28.3, %.loc9_28.5) [template = constants.%struct.4]
// CHECK:STDOUT:     %.loc9_29: %struct_type.a.b.1 = converted %.loc9_28.1, %struct [template = constants.%struct.4]
// CHECK:STDOUT:     %C: type = class_type @C, @C(constants.%struct.4) [template = constants.%C.2]
// CHECK:STDOUT:     %return.param: ref %C.2 = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %C.2 = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(%S.loc8_9.1: %struct_type.a.b.1) {
// CHECK:STDOUT:   %S.loc8_9.2: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic = %S.loc8_9.2 (constants.%S)]
// CHECK:STDOUT:   %S.patt.loc8_9.2: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic = %S.patt.loc8_9.2 (constants.%S.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:     %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type.3]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = constants.%C.1
// CHECK:STDOUT:     complete_type_witness = %complete_type
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %C.2;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %int_0.loc4: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc4_31.1: %struct_type.a.2 = struct_literal (%int_0.loc4)
// CHECK:STDOUT:   %impl.elem0.loc4: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc4: <bound method> = bound_method %int_0.loc4, %impl.elem0.loc4 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc4: <specific function> = specific_function %Convert.bound.loc4, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc4: init %i32 = call %Convert.specific_fn.loc4(%int_0.loc4) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc4_31.2: init %i32 = converted %int_0.loc4, %int.convert_checked.loc4 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc4_31.3: init %struct_type.a.1 = struct_init (%.loc4_31.2) to file.%a_ref.var [template = constants.%struct.1]
// CHECK:STDOUT:   %.loc4_32: init %struct_type.a.1 = converted %.loc4_31.1, %.loc4_31.3 [template = constants.%struct.1]
// CHECK:STDOUT:   assign file.%a_ref.var, %.loc4_32
// CHECK:STDOUT:   %int_0.loc6_17: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %int_0.loc6_26: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc6_28.1: %tuple.type.3 = tuple_literal (%int_0.loc6_26)
// CHECK:STDOUT:   %.loc6_29.1: %struct_type.b.c.2 = struct_literal (%int_0.loc6_17, %.loc6_28.1)
// CHECK:STDOUT:   %int_0.loc6_37: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc6_38.1: %struct_type.a.d.3 = struct_literal (%.loc6_29.1, %int_0.loc6_37)
// CHECK:STDOUT:   %impl.elem0.loc6_29: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc6_29: <bound method> = bound_method %int_0.loc6_17, %impl.elem0.loc6_29 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc6_29: <specific function> = specific_function %Convert.bound.loc6_29, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc6_29: init %i32 = call %Convert.specific_fn.loc6_29(%int_0.loc6_17) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_29.2: init %i32 = converted %int_0.loc6_17, %int.convert_checked.loc6_29 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_38.2: ref %struct_type.b.c.1 = struct_access file.%b_ref.var, element0
// CHECK:STDOUT:   %.loc6_29.3: ref %i32 = struct_access %.loc6_38.2, element0
// CHECK:STDOUT:   %.loc6_29.4: init %i32 = initialize_from %.loc6_29.2 to %.loc6_29.3 [template = constants.%int_0.2]
// CHECK:STDOUT:   %impl.elem0.loc6_28: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc6_28: <bound method> = bound_method %int_0.loc6_26, %impl.elem0.loc6_28 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc6_28: <specific function> = specific_function %Convert.bound.loc6_28, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc6_28: init %i32 = call %Convert.specific_fn.loc6_28(%int_0.loc6_26) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_28.2: init %i32 = converted %int_0.loc6_26, %int.convert_checked.loc6_28 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_29.5: ref %tuple.type.2 = struct_access %.loc6_38.2, element1
// CHECK:STDOUT:   %.loc6_28.3: init %tuple.type.2 = tuple_init (%.loc6_28.2) to %.loc6_29.5 [template = constants.%tuple]
// CHECK:STDOUT:   %.loc6_29.6: init %tuple.type.2 = converted %.loc6_28.1, %.loc6_28.3 [template = constants.%tuple]
// CHECK:STDOUT:   %.loc6_29.7: init %tuple.type.2 = initialize_from %.loc6_29.6 to %.loc6_29.5 [template = constants.%tuple]
// CHECK:STDOUT:   %.loc6_29.8: init %struct_type.b.c.1 = struct_init (%.loc6_29.4, %.loc6_29.7) to %.loc6_38.2 [template = constants.%struct.2]
// CHECK:STDOUT:   %.loc6_38.3: init %struct_type.b.c.1 = converted %.loc6_29.1, %.loc6_29.8 [template = constants.%struct.2]
// CHECK:STDOUT:   %impl.elem0.loc6_38: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc6_38: <bound method> = bound_method %int_0.loc6_37, %impl.elem0.loc6_38 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc6_38: <specific function> = specific_function %Convert.bound.loc6_38, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc6_38: init %i32 = call %Convert.specific_fn.loc6_38(%int_0.loc6_37) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_38.4: init %i32 = converted %int_0.loc6_37, %int.convert_checked.loc6_38 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_38.5: ref %i32 = struct_access file.%b_ref.var, element1
// CHECK:STDOUT:   %.loc6_38.6: init %i32 = initialize_from %.loc6_38.4 to %.loc6_38.5 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc6_38.7: init %struct_type.a.d.1 = struct_init (%.loc6_38.3, %.loc6_38.6) to file.%b_ref.var [template = constants.%struct.3]
// CHECK:STDOUT:   %.loc6_39: init %struct_type.a.d.1 = converted %.loc6_38.1, %.loc6_38.7 [template = constants.%struct.3]
// CHECK:STDOUT:   assign file.%b_ref.var, %.loc6_39
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%S) {
// CHECK:STDOUT:   %S.loc8_9.2 => constants.%S
// CHECK:STDOUT:   %S.patt.loc8_9.2 => constants.%S
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%struct.4) {
// CHECK:STDOUT:   %S.loc8_9.2 => constants.%struct.4
// CHECK:STDOUT:   %S.patt.loc8_9.2 => constants.%struct.4
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- implicit.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %struct_type.a: type = struct_type {.a: %i32} [template]
// CHECK:STDOUT:   %tuple.type.2: type = tuple_type (%i32) [template]
// CHECK:STDOUT:   %struct_type.b.c: type = struct_type {.b: %i32, .c: %tuple.type.2} [template]
// CHECK:STDOUT:   %struct_type.a.d.1: type = struct_type {.a: %struct_type.b.c, .d: %i32} [template]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %struct_type.a.b.1: type = struct_type {.a: %i32, .b: %i32} [template]
// CHECK:STDOUT:   %S: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic]
// CHECK:STDOUT:   %int_1.2: %i32 = int_value 1 [template]
// CHECK:STDOUT:   %int_2.2: %i32 = int_value 2 [template]
// CHECK:STDOUT:   %struct: %struct_type.a.b.1 = struct_value (%int_1.2, %int_2.2) [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%struct) [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1: ref %struct_type.a = import_ref Implicit//default, a_ref, loaded
// CHECK:STDOUT:   %import_ref.2: ref %struct_type.a.d.1 = import_ref Implicit//default, b_ref, loaded
// CHECK:STDOUT:   %import_ref.3: %C.type = import_ref Implicit//default, C, loaded [template = constants.%C.generic]
// CHECK:STDOUT:   %import_ref.4: %F.type = import_ref Implicit//default, F, loaded [template = constants.%F]
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.230
// CHECK:STDOUT:     .ImplicitAs = %import_ref.233
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.231: <witness> = import_ref Implicit//default, loc8_34, loaded [template = constants.%complete_type.3]
// CHECK:STDOUT:   %import_ref.232 = import_ref Implicit//default, inst988 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .a_ref = imports.%import_ref.1
// CHECK:STDOUT:     .b_ref = imports.%import_ref.2
// CHECK:STDOUT:     .C = imports.%import_ref.3
// CHECK:STDOUT:     .F = imports.%import_ref.4
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .a = %a
// CHECK:STDOUT:     .b = %b
// CHECK:STDOUT:     .c = %c
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Implicit.import = import Implicit
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %a.var: ref %struct_type.a = var a
// CHECK:STDOUT:   %a: ref %struct_type.a = bind_name a, %a.var
// CHECK:STDOUT:   %b.var: ref %struct_type.a.d.1 = var b
// CHECK:STDOUT:   %b: ref %struct_type.a.d.1 = bind_name b, %b.var
// CHECK:STDOUT:   %c.var: ref %C.2 = var c
// CHECK:STDOUT:   %c: ref %C.2 = bind_name c, %c.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(constants.%S: %struct_type.a.b.1) [from "implicit.carbon"] {
// CHECK:STDOUT:   %S: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic = %S (constants.%S)]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic = %S.patt (constants.%S.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = imports.%import_ref.232
// CHECK:STDOUT:     complete_type_witness = imports.%import_ref.231
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %C.2 [from "implicit.carbon"];
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a_ref.ref: ref %struct_type.a = name_ref a_ref, imports.%import_ref.1
// CHECK:STDOUT:   %.loc4_20.1: ref %i32 = struct_access %a_ref.ref, element0
// CHECK:STDOUT:   %.loc4_20.2: %i32 = bind_value %.loc4_20.1
// CHECK:STDOUT:   %.loc4_20.3: init %struct_type.a = struct_init (%.loc4_20.2) to file.%a.var
// CHECK:STDOUT:   %.loc4_25: init %struct_type.a = converted %a_ref.ref, %.loc4_20.3
// CHECK:STDOUT:   assign file.%a.var, %.loc4_25
// CHECK:STDOUT:   %b_ref.ref: ref %struct_type.a.d.1 = name_ref b_ref, imports.%import_ref.2
// CHECK:STDOUT:   %.loc5_47.1: ref %struct_type.b.c = struct_access %b_ref.ref, element0
// CHECK:STDOUT:   %.loc5_47.2: ref %i32 = struct_access %.loc5_47.1, element0
// CHECK:STDOUT:   %.loc5_47.3: %i32 = bind_value %.loc5_47.2
// CHECK:STDOUT:   %.loc5_47.4: ref %struct_type.b.c = struct_access file.%b.var, element0
// CHECK:STDOUT:   %.loc5_47.5: ref %i32 = struct_access %.loc5_47.4, element0
// CHECK:STDOUT:   %.loc5_47.6: init %i32 = initialize_from %.loc5_47.3 to %.loc5_47.5
// CHECK:STDOUT:   %.loc5_47.7: ref %tuple.type.2 = struct_access %.loc5_47.1, element1
// CHECK:STDOUT:   %tuple.elem0: ref %i32 = tuple_access %.loc5_47.7, element0
// CHECK:STDOUT:   %.loc5_47.8: %i32 = bind_value %tuple.elem0
// CHECK:STDOUT:   %.loc5_47.9: ref %tuple.type.2 = struct_access %.loc5_47.4, element1
// CHECK:STDOUT:   %.loc5_47.10: init %tuple.type.2 = tuple_init (%.loc5_47.8) to %.loc5_47.9
// CHECK:STDOUT:   %.loc5_47.11: init %tuple.type.2 = converted %.loc5_47.7, %.loc5_47.10
// CHECK:STDOUT:   %.loc5_47.12: init %tuple.type.2 = initialize_from %.loc5_47.11 to %.loc5_47.9
// CHECK:STDOUT:   %.loc5_47.13: init %struct_type.b.c = struct_init (%.loc5_47.6, %.loc5_47.12) to %.loc5_47.4
// CHECK:STDOUT:   %.loc5_47.14: init %struct_type.b.c = converted %.loc5_47.1, %.loc5_47.13
// CHECK:STDOUT:   %.loc5_47.15: ref %i32 = struct_access %b_ref.ref, element1
// CHECK:STDOUT:   %.loc5_47.16: %i32 = bind_value %.loc5_47.15
// CHECK:STDOUT:   %.loc5_47.17: ref %i32 = struct_access file.%b.var, element1
// CHECK:STDOUT:   %.loc5_47.18: init %i32 = initialize_from %.loc5_47.16 to %.loc5_47.17
// CHECK:STDOUT:   %.loc5_47.19: init %struct_type.a.d.1 = struct_init (%.loc5_47.14, %.loc5_47.18) to file.%b.var
// CHECK:STDOUT:   %.loc5_52: init %struct_type.a.d.1 = converted %b_ref.ref, %.loc5_47.19
// CHECK:STDOUT:   assign file.%b.var, %.loc5_52
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.4 [template = constants.%F]
// CHECK:STDOUT:   %.loc6: ref %C.2 = splice_block file.%c.var {}
// CHECK:STDOUT:   %F.call: init %C.2 = call %F.ref() to %.loc6
// CHECK:STDOUT:   assign file.%c.var, %F.call
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%S) {
// CHECK:STDOUT:   %S => constants.%S
// CHECK:STDOUT:   %S.patt => constants.%S
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%struct) {
// CHECK:STDOUT:   %S => constants.%struct
// CHECK:STDOUT:   %S.patt => constants.%struct
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_bad_type.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %struct_type.a.b: type = struct_type {.a: %i32, .b: %i32} [template]
// CHECK:STDOUT:   %S: %struct_type.a.b = bind_symbolic_name S, 0 [symbolic]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b = symbolic_binding_pattern S, 0 [symbolic]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %int_2.2: %i32 = int_value 2 [template]
// CHECK:STDOUT:   %int_1.2: %i32 = int_value 1 [template]
// CHECK:STDOUT:   %struct: %struct_type.a.b = struct_value (%int_1.2, %int_2.2) [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%struct) [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Implicit//default, a_ref, unloaded
// CHECK:STDOUT:   %import_ref.2 = import_ref Implicit//default, b_ref, unloaded
// CHECK:STDOUT:   %import_ref.3: %C.type = import_ref Implicit//default, C, loaded [template = constants.%C.generic]
// CHECK:STDOUT:   %import_ref.4: %F.type = import_ref Implicit//default, F, loaded [template = constants.%F]
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.230: <witness> = import_ref Implicit//default, loc8_34, loaded [template = constants.%complete_type.3]
// CHECK:STDOUT:   %import_ref.231 = import_ref Implicit//default, inst988 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .a_ref = imports.%import_ref.1
// CHECK:STDOUT:     .b_ref = imports.%import_ref.2
// CHECK:STDOUT:     .C = imports.%import_ref.3
// CHECK:STDOUT:     .F = imports.%import_ref.4
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .c_bad = %c_bad
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Implicit.import = import Implicit
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %c_bad.var: ref <error> = var c_bad
// CHECK:STDOUT:   %c_bad: ref <error> = bind_name c_bad, %c_bad.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(constants.%S: %struct_type.a.b) [from "implicit.carbon"] {
// CHECK:STDOUT:   %S: %struct_type.a.b = bind_symbolic_name S, 0 [symbolic = %S (constants.%S)]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b = symbolic_binding_pattern S, 0 [symbolic = %S.patt (constants.%S.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = imports.%import_ref.231
// CHECK:STDOUT:     complete_type_witness = imports.%import_ref.230
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %C.2 [from "implicit.carbon"];
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.4 [template = constants.%F]
// CHECK:STDOUT:   %.loc11: ref %C.2 = temporary_storage
// CHECK:STDOUT:   %F.call: init %C.2 = call %F.ref() to %.loc11
// CHECK:STDOUT:   assign file.%c_bad.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%S) {
// CHECK:STDOUT:   %S => constants.%S
// CHECK:STDOUT:   %S.patt => constants.%S
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%struct) {
// CHECK:STDOUT:   %S => constants.%struct
// CHECK:STDOUT:   %S.patt => constants.%struct
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_bad_value.impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %C.type: type = generic_class_type @C [template]
// CHECK:STDOUT:   %C.generic: %C.type = struct_value () [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type.3: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %struct_type.a.b.1: type = struct_type {.a: %i32, .b: %i32} [template]
// CHECK:STDOUT:   %S: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic]
// CHECK:STDOUT:   %int_3.2: %i32 = int_value 3 [template]
// CHECK:STDOUT:   %int_4.2: %i32 = int_value 4 [template]
// CHECK:STDOUT:   %struct.1: %struct_type.a.b.1 = struct_value (%int_3.2, %int_4.2) [template]
// CHECK:STDOUT:   %C.2: type = class_type @C, @C(%struct.1) [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %int_2: %i32 = int_value 2 [template]
// CHECK:STDOUT:   %int_1: %i32 = int_value 1 [template]
// CHECK:STDOUT:   %struct.2: %struct_type.a.b.1 = struct_value (%int_1, %int_2) [template]
// CHECK:STDOUT:   %C.3: type = class_type @C, @C(%struct.2) [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %import_ref.1 = import_ref Implicit//default, a_ref, unloaded
// CHECK:STDOUT:   %import_ref.2 = import_ref Implicit//default, b_ref, unloaded
// CHECK:STDOUT:   %import_ref.3: %C.type = import_ref Implicit//default, C, loaded [template = constants.%C.generic]
// CHECK:STDOUT:   %import_ref.4: %F.type = import_ref Implicit//default, F, loaded [template = constants.%F]
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .ImplicitAs = %import_ref.232
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %import_ref.230: <witness> = import_ref Implicit//default, loc8_34, loaded [template = constants.%complete_type.3]
// CHECK:STDOUT:   %import_ref.231 = import_ref Implicit//default, inst988 [no loc], unloaded
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .a_ref = imports.%import_ref.1
// CHECK:STDOUT:     .b_ref = imports.%import_ref.2
// CHECK:STDOUT:     .C = imports.%import_ref.3
// CHECK:STDOUT:     .F = imports.%import_ref.4
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .c_bad = %c_bad
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Implicit.import = import Implicit
// CHECK:STDOUT:   %default.import = import <invalid>
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %c_bad.var: ref %C.2 = var c_bad
// CHECK:STDOUT:   %c_bad: ref %C.2 = bind_name c_bad, %c_bad.var
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic class @C(constants.%S: %struct_type.a.b.1) [from "implicit.carbon"] {
// CHECK:STDOUT:   %S: %struct_type.a.b.1 = bind_symbolic_name S, 0 [symbolic = %S (constants.%S)]
// CHECK:STDOUT:   %S.patt: %struct_type.a.b.1 = symbolic_binding_pattern S, 0 [symbolic = %S.patt (constants.%S.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   class {
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = imports.%import_ref.231
// CHECK:STDOUT:     complete_type_witness = imports.%import_ref.230
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %C.3 [from "implicit.carbon"];
// CHECK:STDOUT:
// CHECK:STDOUT: fn @__global_init() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, imports.%import_ref.4 [template = constants.%F]
// CHECK:STDOUT:   %.loc9_36: ref %C.3 = temporary_storage
// CHECK:STDOUT:   %F.call: init %C.3 = call %F.ref() to %.loc9_36
// CHECK:STDOUT:   %.loc9_37: %C.2 = converted %F.call, <error> [template = <error>]
// CHECK:STDOUT:   assign file.%c_bad.var, <error>
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%S) {
// CHECK:STDOUT:   %S => constants.%S
// CHECK:STDOUT:   %S.patt => constants.%S
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%struct.1) {
// CHECK:STDOUT:   %S => constants.%struct.1
// CHECK:STDOUT:   %S.patt => constants.%struct.1
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @C(constants.%struct.2) {
// CHECK:STDOUT:   %S => constants.%struct.2
// CHECK:STDOUT:   %S.patt => constants.%struct.2
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT: }
// CHECK:STDOUT:
