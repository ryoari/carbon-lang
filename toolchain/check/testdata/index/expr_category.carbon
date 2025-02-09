// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/index/expr_category.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/index/expr_category.carbon

fn F() -> [i32; 3];

fn G(b: [i32; 3]) {
  var a: [i32; 3] = (1, 2, 3);

  // Indexing a durable array reference gives a durable reference.
  var pa: i32* = &a[0];
  a[0] = 4;
}

fn ValueBinding(b: [i32; 3]) {
  var a: [i32; 3] = (1, 2, 3);

  // Index but don't do anything else so we can check that a value binding is
  // produced when appropriate.
  a[0];
  b[0];
  F()[0];
}

// CHECK:STDOUT: --- expr_category.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %int_3.1: Core.IntLiteral = int_value 3 [template]
// CHECK:STDOUT:   %array_type: type = array_type %int_3.1, %i32 [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT:   %int_1.1: Core.IntLiteral = int_value 1 [template]
// CHECK:STDOUT:   %int_2.1: Core.IntLiteral = int_value 2 [template]
// CHECK:STDOUT:   %tuple.type: type = tuple_type (Core.IntLiteral, Core.IntLiteral, Core.IntLiteral) [template]
// CHECK:STDOUT:   %int_0.1: Core.IntLiteral = int_value 0 [template]
// CHECK:STDOUT:   %Convert.type.2: type = fn_type @Convert.1, @ImplicitAs(%i32) [template]
// CHECK:STDOUT:   %Convert.type.10: type = fn_type @Convert.2, @impl.1(%int_32) [template]
// CHECK:STDOUT:   %Convert.10: %Convert.type.10 = struct_value () [template]
// CHECK:STDOUT:   %interface.19: <witness> = interface_witness (%Convert.10) [template]
// CHECK:STDOUT:   %Convert.bound.1: <bound method> = bound_method %int_1.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.1: <specific function> = specific_function %Convert.bound.1, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_1.2: %i32 = int_value 1 [template]
// CHECK:STDOUT:   %Convert.bound.2: <bound method> = bound_method %int_2.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.2: <specific function> = specific_function %Convert.bound.2, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_2.2: %i32 = int_value 2 [template]
// CHECK:STDOUT:   %Convert.bound.3: <bound method> = bound_method %int_3.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.3: <specific function> = specific_function %Convert.bound.3, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_3.2: %i32 = int_value 3 [template]
// CHECK:STDOUT:   %array: %array_type = tuple_value (%int_1.2, %int_2.2, %int_3.2) [template]
// CHECK:STDOUT:   %ptr.2: type = ptr_type %i32 [template]
// CHECK:STDOUT:   %Convert.bound.4: <bound method> = bound_method %int_0.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.4: <specific function> = specific_function %Convert.bound.4, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_0.2: %i32 = int_value 0 [template]
// CHECK:STDOUT:   %int_4.1: Core.IntLiteral = int_value 4 [template]
// CHECK:STDOUT:   %Convert.bound.5: <bound method> = bound_method %int_4.1, %Convert.10 [template]
// CHECK:STDOUT:   %Convert.specific_fn.5: <specific function> = specific_function %Convert.bound.5, @Convert.2(%int_32) [template]
// CHECK:STDOUT:   %int_4.2: %i32 = int_value 4 [template]
// CHECK:STDOUT:   %ValueBinding.type: type = fn_type @ValueBinding [template]
// CHECK:STDOUT:   %ValueBinding: %ValueBinding.type = struct_value () [template]
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
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:     .ValueBinding = %ValueBinding.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %return.patt: %array_type = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %array_type = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int_32: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:     %i32: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:     %int_3: Core.IntLiteral = int_value 3 [template = constants.%int_3.1]
// CHECK:STDOUT:     %array_type: type = array_type %int_3, %i32 [template = constants.%array_type]
// CHECK:STDOUT:     %return.param: ref %array_type = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %array_type = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {
// CHECK:STDOUT:     %b.patt: %array_type = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %array_type = value_param_pattern %b.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %b.param: %array_type = value_param runtime_param0
// CHECK:STDOUT:     %.loc13: type = splice_block %array_type [template = constants.%array_type] {
// CHECK:STDOUT:       %int_32.loc13: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc13: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %int_3.loc13: Core.IntLiteral = int_value 3 [template = constants.%int_3.1]
// CHECK:STDOUT:       %array_type: type = array_type %int_3.loc13, %i32 [template = constants.%array_type]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %b: %array_type = bind_name b, %b.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %ValueBinding.decl: %ValueBinding.type = fn_decl @ValueBinding [template = constants.%ValueBinding] {
// CHECK:STDOUT:     %b.patt: %array_type = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %array_type = value_param_pattern %b.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %b.param: %array_type = value_param runtime_param0
// CHECK:STDOUT:     %.loc21: type = splice_block %array_type [template = constants.%array_type] {
// CHECK:STDOUT:       %int_32.loc21: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc21: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %int_3.loc21: Core.IntLiteral = int_value 3 [template = constants.%int_3.1]
// CHECK:STDOUT:       %array_type: type = array_type %int_3.loc21, %i32 [template = constants.%array_type]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %b: %array_type = bind_name b, %b.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F() -> %array_type;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G(%b.param_patt: %array_type) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.var: ref %array_type = var a
// CHECK:STDOUT:   %a: ref %array_type = bind_name a, %a.var
// CHECK:STDOUT:   %int_1.loc14_22: Core.IntLiteral = int_value 1 [template = constants.%int_1.1]
// CHECK:STDOUT:   %int_2.loc14_25: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:   %int_3.loc14: Core.IntLiteral = int_value 3 [template = constants.%int_3.1]
// CHECK:STDOUT:   %.loc14_29.1: %tuple.type = tuple_literal (%int_1.loc14_22, %int_2.loc14_25, %int_3.loc14)
// CHECK:STDOUT:   %impl.elem0.loc14_29.1: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc14_29.1: <bound method> = bound_method %int_1.loc14_22, %impl.elem0.loc14_29.1 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc14_29.1: <specific function> = specific_function %Convert.bound.loc14_29.1, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc14_29.1: init %i32 = call %Convert.specific_fn.loc14_29.1(%int_1.loc14_22) [template = constants.%int_1.2]
// CHECK:STDOUT:   %.loc14_29.2: init %i32 = converted %int_1.loc14_22, %int.convert_checked.loc14_29.1 [template = constants.%int_1.2]
// CHECK:STDOUT:   %int_0.loc14: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc14_29.3: ref %i32 = array_index %a.var, %int_0.loc14
// CHECK:STDOUT:   %.loc14_29.4: init %i32 = initialize_from %.loc14_29.2 to %.loc14_29.3 [template = constants.%int_1.2]
// CHECK:STDOUT:   %impl.elem0.loc14_29.2: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc14_29.2: <bound method> = bound_method %int_2.loc14_25, %impl.elem0.loc14_29.2 [template = constants.%Convert.bound.2]
// CHECK:STDOUT:   %Convert.specific_fn.loc14_29.2: <specific function> = specific_function %Convert.bound.loc14_29.2, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.2]
// CHECK:STDOUT:   %int.convert_checked.loc14_29.2: init %i32 = call %Convert.specific_fn.loc14_29.2(%int_2.loc14_25) [template = constants.%int_2.2]
// CHECK:STDOUT:   %.loc14_29.5: init %i32 = converted %int_2.loc14_25, %int.convert_checked.loc14_29.2 [template = constants.%int_2.2]
// CHECK:STDOUT:   %int_1.loc14_29: Core.IntLiteral = int_value 1 [template = constants.%int_1.1]
// CHECK:STDOUT:   %.loc14_29.6: ref %i32 = array_index %a.var, %int_1.loc14_29
// CHECK:STDOUT:   %.loc14_29.7: init %i32 = initialize_from %.loc14_29.5 to %.loc14_29.6 [template = constants.%int_2.2]
// CHECK:STDOUT:   %impl.elem0.loc14_29.3: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc14_29.3: <bound method> = bound_method %int_3.loc14, %impl.elem0.loc14_29.3 [template = constants.%Convert.bound.3]
// CHECK:STDOUT:   %Convert.specific_fn.loc14_29.3: <specific function> = specific_function %Convert.bound.loc14_29.3, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.3]
// CHECK:STDOUT:   %int.convert_checked.loc14_29.3: init %i32 = call %Convert.specific_fn.loc14_29.3(%int_3.loc14) [template = constants.%int_3.2]
// CHECK:STDOUT:   %.loc14_29.8: init %i32 = converted %int_3.loc14, %int.convert_checked.loc14_29.3 [template = constants.%int_3.2]
// CHECK:STDOUT:   %int_2.loc14_29: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:   %.loc14_29.9: ref %i32 = array_index %a.var, %int_2.loc14_29
// CHECK:STDOUT:   %.loc14_29.10: init %i32 = initialize_from %.loc14_29.8 to %.loc14_29.9 [template = constants.%int_3.2]
// CHECK:STDOUT:   %.loc14_29.11: init %array_type = array_init (%.loc14_29.4, %.loc14_29.7, %.loc14_29.10) to %a.var [template = constants.%array]
// CHECK:STDOUT:   %.loc14_30: init %array_type = converted %.loc14_29.1, %.loc14_29.11 [template = constants.%array]
// CHECK:STDOUT:   assign %a.var, %.loc14_30
// CHECK:STDOUT:   %pa.var: ref %ptr.2 = var pa
// CHECK:STDOUT:   %pa: ref %ptr.2 = bind_name pa, %pa.var
// CHECK:STDOUT:   %a.ref.loc17: ref %array_type = name_ref a, %a
// CHECK:STDOUT:   %int_0.loc17: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %int_32.loc17: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:   %i32.loc17: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:   %impl.elem0.loc17: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc17: <bound method> = bound_method %int_0.loc17, %impl.elem0.loc17 [template = constants.%Convert.bound.4]
// CHECK:STDOUT:   %Convert.specific_fn.loc17: <specific function> = specific_function %Convert.bound.loc17, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.4]
// CHECK:STDOUT:   %int.convert_checked.loc17: init %i32 = call %Convert.specific_fn.loc17(%int_0.loc17) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc17_21.1: %i32 = value_of_initializer %int.convert_checked.loc17 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc17_21.2: %i32 = converted %int_0.loc17, %.loc17_21.1 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc17_22: ref %i32 = array_index %a.ref.loc17, %.loc17_21.2
// CHECK:STDOUT:   %addr: %ptr.2 = addr_of %.loc17_22
// CHECK:STDOUT:   assign %pa.var, %addr
// CHECK:STDOUT:   %a.ref.loc18: ref %array_type = name_ref a, %a
// CHECK:STDOUT:   %int_0.loc18: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %int_32.loc18: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:   %i32.loc18: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:   %impl.elem0.loc18_5: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc18_5: <bound method> = bound_method %int_0.loc18, %impl.elem0.loc18_5 [template = constants.%Convert.bound.4]
// CHECK:STDOUT:   %Convert.specific_fn.loc18_5: <specific function> = specific_function %Convert.bound.loc18_5, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.4]
// CHECK:STDOUT:   %int.convert_checked.loc18_5: init %i32 = call %Convert.specific_fn.loc18_5(%int_0.loc18) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc18_5.1: %i32 = value_of_initializer %int.convert_checked.loc18_5 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc18_5.2: %i32 = converted %int_0.loc18, %.loc18_5.1 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc18_6: ref %i32 = array_index %a.ref.loc18, %.loc18_5.2
// CHECK:STDOUT:   %int_4: Core.IntLiteral = int_value 4 [template = constants.%int_4.1]
// CHECK:STDOUT:   %impl.elem0.loc18_8: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc18_8: <bound method> = bound_method %int_4, %impl.elem0.loc18_8 [template = constants.%Convert.bound.5]
// CHECK:STDOUT:   %Convert.specific_fn.loc18_8: <specific function> = specific_function %Convert.bound.loc18_8, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.5]
// CHECK:STDOUT:   %int.convert_checked.loc18_8: init %i32 = call %Convert.specific_fn.loc18_8(%int_4) [template = constants.%int_4.2]
// CHECK:STDOUT:   %.loc18_8: init %i32 = converted %int_4, %int.convert_checked.loc18_8 [template = constants.%int_4.2]
// CHECK:STDOUT:   assign %.loc18_6, %.loc18_8
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @ValueBinding(%b.param_patt: %array_type) {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.var: ref %array_type = var a
// CHECK:STDOUT:   %a: ref %array_type = bind_name a, %a.var
// CHECK:STDOUT:   %int_1.loc22_22: Core.IntLiteral = int_value 1 [template = constants.%int_1.1]
// CHECK:STDOUT:   %int_2.loc22_25: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:   %int_3.loc22: Core.IntLiteral = int_value 3 [template = constants.%int_3.1]
// CHECK:STDOUT:   %.loc22_29.1: %tuple.type = tuple_literal (%int_1.loc22_22, %int_2.loc22_25, %int_3.loc22)
// CHECK:STDOUT:   %impl.elem0.loc22_29.1: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc22_29.1: <bound method> = bound_method %int_1.loc22_22, %impl.elem0.loc22_29.1 [template = constants.%Convert.bound.1]
// CHECK:STDOUT:   %Convert.specific_fn.loc22_29.1: <specific function> = specific_function %Convert.bound.loc22_29.1, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.1]
// CHECK:STDOUT:   %int.convert_checked.loc22_29.1: init %i32 = call %Convert.specific_fn.loc22_29.1(%int_1.loc22_22) [template = constants.%int_1.2]
// CHECK:STDOUT:   %.loc22_29.2: init %i32 = converted %int_1.loc22_22, %int.convert_checked.loc22_29.1 [template = constants.%int_1.2]
// CHECK:STDOUT:   %int_0.loc22: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc22_29.3: ref %i32 = array_index %a.var, %int_0.loc22
// CHECK:STDOUT:   %.loc22_29.4: init %i32 = initialize_from %.loc22_29.2 to %.loc22_29.3 [template = constants.%int_1.2]
// CHECK:STDOUT:   %impl.elem0.loc22_29.2: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc22_29.2: <bound method> = bound_method %int_2.loc22_25, %impl.elem0.loc22_29.2 [template = constants.%Convert.bound.2]
// CHECK:STDOUT:   %Convert.specific_fn.loc22_29.2: <specific function> = specific_function %Convert.bound.loc22_29.2, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.2]
// CHECK:STDOUT:   %int.convert_checked.loc22_29.2: init %i32 = call %Convert.specific_fn.loc22_29.2(%int_2.loc22_25) [template = constants.%int_2.2]
// CHECK:STDOUT:   %.loc22_29.5: init %i32 = converted %int_2.loc22_25, %int.convert_checked.loc22_29.2 [template = constants.%int_2.2]
// CHECK:STDOUT:   %int_1.loc22_29: Core.IntLiteral = int_value 1 [template = constants.%int_1.1]
// CHECK:STDOUT:   %.loc22_29.6: ref %i32 = array_index %a.var, %int_1.loc22_29
// CHECK:STDOUT:   %.loc22_29.7: init %i32 = initialize_from %.loc22_29.5 to %.loc22_29.6 [template = constants.%int_2.2]
// CHECK:STDOUT:   %impl.elem0.loc22_29.3: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc22_29.3: <bound method> = bound_method %int_3.loc22, %impl.elem0.loc22_29.3 [template = constants.%Convert.bound.3]
// CHECK:STDOUT:   %Convert.specific_fn.loc22_29.3: <specific function> = specific_function %Convert.bound.loc22_29.3, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.3]
// CHECK:STDOUT:   %int.convert_checked.loc22_29.3: init %i32 = call %Convert.specific_fn.loc22_29.3(%int_3.loc22) [template = constants.%int_3.2]
// CHECK:STDOUT:   %.loc22_29.8: init %i32 = converted %int_3.loc22, %int.convert_checked.loc22_29.3 [template = constants.%int_3.2]
// CHECK:STDOUT:   %int_2.loc22_29: Core.IntLiteral = int_value 2 [template = constants.%int_2.1]
// CHECK:STDOUT:   %.loc22_29.9: ref %i32 = array_index %a.var, %int_2.loc22_29
// CHECK:STDOUT:   %.loc22_29.10: init %i32 = initialize_from %.loc22_29.8 to %.loc22_29.9 [template = constants.%int_3.2]
// CHECK:STDOUT:   %.loc22_29.11: init %array_type = array_init (%.loc22_29.4, %.loc22_29.7, %.loc22_29.10) to %a.var [template = constants.%array]
// CHECK:STDOUT:   %.loc22_30: init %array_type = converted %.loc22_29.1, %.loc22_29.11 [template = constants.%array]
// CHECK:STDOUT:   assign %a.var, %.loc22_30
// CHECK:STDOUT:   %a.ref: ref %array_type = name_ref a, %a
// CHECK:STDOUT:   %int_0.loc26: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %int_32.loc26: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:   %i32.loc26: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:   %impl.elem0.loc26: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc26: <bound method> = bound_method %int_0.loc26, %impl.elem0.loc26 [template = constants.%Convert.bound.4]
// CHECK:STDOUT:   %Convert.specific_fn.loc26: <specific function> = specific_function %Convert.bound.loc26, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.4]
// CHECK:STDOUT:   %int.convert_checked.loc26: init %i32 = call %Convert.specific_fn.loc26(%int_0.loc26) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc26_5.1: %i32 = value_of_initializer %int.convert_checked.loc26 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc26_5.2: %i32 = converted %int_0.loc26, %.loc26_5.1 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc26_6: ref %i32 = array_index %a.ref, %.loc26_5.2
// CHECK:STDOUT:   %b.ref: %array_type = name_ref b, %b
// CHECK:STDOUT:   %int_0.loc27: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %int_32.loc27: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:   %i32.loc27: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:   %impl.elem0.loc27: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc27: <bound method> = bound_method %int_0.loc27, %impl.elem0.loc27 [template = constants.%Convert.bound.4]
// CHECK:STDOUT:   %Convert.specific_fn.loc27: <specific function> = specific_function %Convert.bound.loc27, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.4]
// CHECK:STDOUT:   %int.convert_checked.loc27: init %i32 = call %Convert.specific_fn.loc27(%int_0.loc27) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc27_5.1: %i32 = value_of_initializer %int.convert_checked.loc27 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc27_5.2: %i32 = converted %int_0.loc27, %.loc27_5.1 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc27_6.1: ref %array_type = value_as_ref %b.ref
// CHECK:STDOUT:   %.loc27_6.2: ref %i32 = array_index %.loc27_6.1, %.loc27_5.2
// CHECK:STDOUT:   %.loc27_6.3: %i32 = bind_value %.loc27_6.2
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, file.%F.decl [template = constants.%F]
// CHECK:STDOUT:   %.loc28_5.1: ref %array_type = temporary_storage
// CHECK:STDOUT:   %F.call: init %array_type = call %F.ref() to %.loc28_5.1
// CHECK:STDOUT:   %int_0.loc28: Core.IntLiteral = int_value 0 [template = constants.%int_0.1]
// CHECK:STDOUT:   %.loc28_5.2: ref %array_type = temporary %.loc28_5.1, %F.call
// CHECK:STDOUT:   %int_32.loc28: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:   %i32.loc28: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:   %impl.elem0.loc28: %Convert.type.2 = interface_witness_access constants.%interface.19, element0 [template = constants.%Convert.10]
// CHECK:STDOUT:   %Convert.bound.loc28: <bound method> = bound_method %int_0.loc28, %impl.elem0.loc28 [template = constants.%Convert.bound.4]
// CHECK:STDOUT:   %Convert.specific_fn.loc28: <specific function> = specific_function %Convert.bound.loc28, @Convert.2(constants.%int_32) [template = constants.%Convert.specific_fn.4]
// CHECK:STDOUT:   %int.convert_checked.loc28: init %i32 = call %Convert.specific_fn.loc28(%int_0.loc28) [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc28_7.1: %i32 = value_of_initializer %int.convert_checked.loc28 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc28_7.2: %i32 = converted %int_0.loc28, %.loc28_7.1 [template = constants.%int_0.2]
// CHECK:STDOUT:   %.loc28_8.1: ref %i32 = array_index %.loc28_5.2, %.loc28_7.2
// CHECK:STDOUT:   %.loc28_8.2: %i32 = bind_value %.loc28_8.1
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
