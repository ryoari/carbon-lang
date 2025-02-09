// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/interface/member_lookup.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/interface/member_lookup.carbon

// --- member_access.carbon

library "[[@TEST_NAME]]";

interface Interface(T:! type) {
  let X:! T;
}

fn AccessGeneric[T:! type](I:! Interface(T)) -> T {
  return I.X;
}

fn AccessConcrete(I:! Interface(i32)) -> i32 {
  return I.X;
}

// --- fail_no_member.carbon

library "[[@TEST_NAME]]";

interface Interface(T:! type) {
  let X:! T;
}

fn AccessMissingGeneric[T:! type](I:! Interface(T)) -> T {
  // CHECK:STDERR: fail_no_member.carbon:[[@LINE+4]]:10: error: member name `nonesuch` not found in `Interface(T)` [MemberNameNotFoundInScope]
  // CHECK:STDERR:   return I.nonesuch;
  // CHECK:STDERR:          ^~~~~~~~~~
  // CHECK:STDERR:
  return I.nonesuch;
}

fn AccessMissingConcrete(I:! Interface(i32)) -> i32 {
  // CHECK:STDERR: fail_no_member.carbon:[[@LINE+3]]:10: error: member name `nonesuch` not found in `Interface(i32)` [MemberNameNotFoundInScope]
  // CHECK:STDERR:   return I.nonesuch;
  // CHECK:STDERR:          ^~~~~~~~~~
  return I.nonesuch;
}

// CHECK:STDOUT: --- member_access.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T, 0 [symbolic]
// CHECK:STDOUT:   %T.patt: type = symbolic_binding_pattern T, 0 [symbolic]
// CHECK:STDOUT:   %Interface.type.1: type = generic_interface_type @Interface [template]
// CHECK:STDOUT:   %Interface.generic: %Interface.type.1 = struct_value () [template]
// CHECK:STDOUT:   %Interface.type.2: type = facet_type <@Interface, @Interface(%T)> [symbolic]
// CHECK:STDOUT:   %Self: %Interface.type.2 = bind_symbolic_name Self, 1 [symbolic]
// CHECK:STDOUT:   %require_complete.1: <witness> = require_complete_type %T [symbolic]
// CHECK:STDOUT:   %assoc_type.1: type = assoc_entity_type %Interface.type.2, %T [symbolic]
// CHECK:STDOUT:   %assoc0.1: %assoc_type.1 = assoc_entity element0, @Interface.%X [symbolic]
// CHECK:STDOUT:   %I.1: %Interface.type.2 = bind_symbolic_name I, 1 [symbolic]
// CHECK:STDOUT:   %I.patt.1: %Interface.type.2 = symbolic_binding_pattern I, 1 [symbolic]
// CHECK:STDOUT:   %AccessGeneric.type: type = fn_type @AccessGeneric [template]
// CHECK:STDOUT:   %AccessGeneric: %AccessGeneric.type = struct_value () [template]
// CHECK:STDOUT:   %require_complete.2: <witness> = require_complete_type %Interface.type.2 [symbolic]
// CHECK:STDOUT:   %I.as_wit.1: <witness> = facet_access_witness %I.1 [symbolic]
// CHECK:STDOUT:   %impl.elem0.1: %T = interface_witness_access %I.as_wit.1, element0 [symbolic]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %Interface.type.3: type = facet_type <@Interface, @Interface(%i32)> [template]
// CHECK:STDOUT:   %I.2: %Interface.type.3 = bind_symbolic_name I, 0 [symbolic]
// CHECK:STDOUT:   %I.patt.2: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic]
// CHECK:STDOUT:   %AccessConcrete.type: type = fn_type @AccessConcrete [template]
// CHECK:STDOUT:   %AccessConcrete: %AccessConcrete.type = struct_value () [template]
// CHECK:STDOUT:   %i32.builtin: type = int_type signed, %int_32 [template]
// CHECK:STDOUT:   %complete_type.2: <witness> = complete_type_witness %i32.builtin [template]
// CHECK:STDOUT:   %assoc_type.2: type = assoc_entity_type %Interface.type.3, %i32 [template]
// CHECK:STDOUT:   %assoc0.2: %assoc_type.2 = assoc_entity element0, @Interface.%X [template]
// CHECK:STDOUT:   %I.as_wit.2: <witness> = facet_access_witness %I.2 [symbolic]
// CHECK:STDOUT:   %impl.elem0.2: %i32 = interface_witness_access %I.as_wit.2, element0 [symbolic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Interface = %Interface.decl
// CHECK:STDOUT:     .AccessGeneric = %AccessGeneric.decl
// CHECK:STDOUT:     .AccessConcrete = %AccessConcrete.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Interface.decl: %Interface.type.1 = interface_decl @Interface [template = constants.%Interface.generic] {
// CHECK:STDOUT:     %T.patt.loc4_21.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:     %T.param_patt: type = value_param_pattern %T.patt.loc4_21.1, runtime_param<invalid> [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = value_param runtime_param<invalid>
// CHECK:STDOUT:     %T.loc4_21.1: type = bind_symbolic_name T, 0, %T.param [symbolic = %T.loc4_21.2 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %AccessGeneric.decl: %AccessGeneric.type = fn_decl @AccessGeneric [template = constants.%AccessGeneric] {
// CHECK:STDOUT:     %T.patt.loc8_18.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc8_18.2 (constants.%T.patt)]
// CHECK:STDOUT:     %T.param_patt: type = value_param_pattern %T.patt.loc8_18.1, runtime_param<invalid> [symbolic = %T.patt.loc8_18.2 (constants.%T.patt)]
// CHECK:STDOUT:     %I.patt.loc8_28.1: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) = symbolic_binding_pattern I, 1 [symbolic = %I.patt.loc8_28.2 (constants.%I.patt.1)]
// CHECK:STDOUT:     %I.param_patt: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) = value_param_pattern %I.patt.loc8_28.1, runtime_param<invalid> [symbolic = %I.patt.loc8_28.2 (constants.%I.patt.1)]
// CHECK:STDOUT:     %return.patt: @AccessGeneric.%T.loc8_18.2 (%T) = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: @AccessGeneric.%T.loc8_18.2 (%T) = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.ref.loc8_49: type = name_ref T, %T.loc8_18.1 [symbolic = %T.loc8_18.2 (constants.%T)]
// CHECK:STDOUT:     %T.param: type = value_param runtime_param<invalid>
// CHECK:STDOUT:     %T.loc8_18.1: type = bind_symbolic_name T, 0, %T.param [symbolic = %T.loc8_18.2 (constants.%T)]
// CHECK:STDOUT:     %I.param: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) = value_param runtime_param<invalid>
// CHECK:STDOUT:     %.loc8: type = splice_block %Interface.type.loc8_43.1 [symbolic = %Interface.type.loc8_43.2 (constants.%Interface.type.2)] {
// CHECK:STDOUT:       %Interface.ref: %Interface.type.1 = name_ref Interface, file.%Interface.decl [template = constants.%Interface.generic]
// CHECK:STDOUT:       %T.ref.loc8_42: type = name_ref T, %T.loc8_18.1 [symbolic = %T.loc8_18.2 (constants.%T)]
// CHECK:STDOUT:       %Interface.type.loc8_43.1: type = facet_type <@Interface, @Interface(constants.%T)> [symbolic = %Interface.type.loc8_43.2 (constants.%Interface.type.2)]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %I.loc8_28.1: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) = bind_symbolic_name I, 1, %I.param [symbolic = %I.loc8_28.2 (constants.%I.1)]
// CHECK:STDOUT:     %return.param: ref @AccessGeneric.%T.loc8_18.2 (%T) = out_param runtime_param0
// CHECK:STDOUT:     %return: ref @AccessGeneric.%T.loc8_18.2 (%T) = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %AccessConcrete.decl: %AccessConcrete.type = fn_decl @AccessConcrete [template = constants.%AccessConcrete] {
// CHECK:STDOUT:     %I.patt.loc12_19.1: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic = %I.patt.loc12_19.2 (constants.%I.patt.2)]
// CHECK:STDOUT:     %I.param_patt: %Interface.type.3 = value_param_pattern %I.patt.loc12_19.1, runtime_param<invalid> [symbolic = %I.patt.loc12_19.2 (constants.%I.patt.2)]
// CHECK:STDOUT:     %return.patt: %i32 = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %i32 = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int_32.loc12_42: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:     %i32.loc12_42: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:     %I.param: %Interface.type.3 = value_param runtime_param<invalid>
// CHECK:STDOUT:     %.loc12: type = splice_block %Interface.type [template = constants.%Interface.type.3] {
// CHECK:STDOUT:       %Interface.ref: %Interface.type.1 = name_ref Interface, file.%Interface.decl [template = constants.%Interface.generic]
// CHECK:STDOUT:       %int_32.loc12_33: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc12_33: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %Interface.type: type = facet_type <@Interface, @Interface(constants.%i32)> [template = constants.%Interface.type.3]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %I.loc12_19.1: %Interface.type.3 = bind_symbolic_name I, 0, %I.param [symbolic = %I.loc12_19.2 (constants.%I.2)]
// CHECK:STDOUT:     %return.param: ref %i32 = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %i32 = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic interface @Interface(%T.loc4_21.1: type) {
// CHECK:STDOUT:   %T.loc4_21.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc4_21.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc4_21.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type: type = facet_type <@Interface, @Interface(%T.loc4_21.2)> [symbolic = %Interface.type (constants.%Interface.type.2)]
// CHECK:STDOUT:   %Self.2: %Interface.type.2 = bind_symbolic_name Self, 1 [symbolic = %Self.2 (constants.%Self)]
// CHECK:STDOUT:   %require_complete: <witness> = require_complete_type @Interface.%T.loc4_21.2 (%T) [symbolic = %require_complete (constants.%require_complete.1)]
// CHECK:STDOUT:   %assoc_type: type = assoc_entity_type @Interface.%Interface.type (%Interface.type.2), @Interface.%T.loc4_21.2 (%T) [symbolic = %assoc_type (constants.%assoc_type.1)]
// CHECK:STDOUT:   %assoc0.loc5_12.2: @Interface.%assoc_type (%assoc_type.1) = assoc_entity element0, %X [symbolic = %assoc0.loc5_12.2 (constants.%assoc0.1)]
// CHECK:STDOUT:
// CHECK:STDOUT:   interface {
// CHECK:STDOUT:     %Self.1: @Interface.%Interface.type (%Interface.type.2) = bind_symbolic_name Self, 1 [symbolic = %Self.2 (constants.%Self)]
// CHECK:STDOUT:     %X: @Interface.%T.loc4_21.2 (%T) = assoc_const_decl X [template]
// CHECK:STDOUT:     %assoc0.loc5_12.1: @Interface.%assoc_type (%assoc_type.1) = assoc_entity element0, %X [symbolic = %assoc0.loc5_12.2 (constants.%assoc0.1)]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = %Self.1
// CHECK:STDOUT:     .X = %assoc0.loc5_12.1
// CHECK:STDOUT:     witness = (%X)
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @AccessGeneric(%T.loc8_18.1: type, %I.loc8_28.1: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2)) {
// CHECK:STDOUT:   %T.loc8_18.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc8_18.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc8_18.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc8_18.2 (constants.%T.patt)]
// CHECK:STDOUT:   %Interface.type.loc8_43.2: type = facet_type <@Interface, @Interface(%T.loc8_18.2)> [symbolic = %Interface.type.loc8_43.2 (constants.%Interface.type.2)]
// CHECK:STDOUT:   %I.loc8_28.2: %Interface.type.2 = bind_symbolic_name I, 1 [symbolic = %I.loc8_28.2 (constants.%I.1)]
// CHECK:STDOUT:   %I.patt.loc8_28.2: %Interface.type.2 = symbolic_binding_pattern I, 1 [symbolic = %I.patt.loc8_28.2 (constants.%I.patt.1)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %require_complete.loc9_10: <witness> = require_complete_type @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) [symbolic = %require_complete.loc9_10 (constants.%require_complete.2)]
// CHECK:STDOUT:   %assoc_type: type = assoc_entity_type @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2), @AccessGeneric.%T.loc8_18.2 (%T) [symbolic = %assoc_type (constants.%assoc_type.1)]
// CHECK:STDOUT:   %assoc0: @AccessGeneric.%assoc_type (%assoc_type.1) = assoc_entity element0, @Interface.%X [symbolic = %assoc0 (constants.%assoc0.1)]
// CHECK:STDOUT:   %I.as_wit.loc9_11.2: <witness> = facet_access_witness %I.loc8_28.2 [symbolic = %I.as_wit.loc9_11.2 (constants.%I.as_wit.1)]
// CHECK:STDOUT:   %impl.elem0.loc9_11.2: @AccessGeneric.%T.loc8_18.2 (%T) = interface_witness_access %I.as_wit.loc9_11.2, element0 [symbolic = %impl.elem0.loc9_11.2 (constants.%impl.elem0.1)]
// CHECK:STDOUT:   %require_complete.loc9_13: <witness> = require_complete_type @AccessGeneric.%T.loc8_18.2 (%T) [symbolic = %require_complete.loc9_13 (constants.%require_complete.1)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn[%T.param_patt: type](%I.param_patt: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2)) -> @AccessGeneric.%T.loc8_18.2 (%T) {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %I.ref: @AccessGeneric.%Interface.type.loc8_43.2 (%Interface.type.2) = name_ref I, %I.loc8_28.1 [symbolic = %I.loc8_28.2 (constants.%I.1)]
// CHECK:STDOUT:     %.loc9: @AccessGeneric.%assoc_type (%assoc_type.1) = specific_constant @Interface.%assoc0.loc5_12.1, @Interface(constants.%T) [symbolic = %assoc0 (constants.%assoc0.1)]
// CHECK:STDOUT:     %X.ref: @AccessGeneric.%assoc_type (%assoc_type.1) = name_ref X, %.loc9 [symbolic = %assoc0 (constants.%assoc0.1)]
// CHECK:STDOUT:     %I.as_wit.loc9_11.1: <witness> = facet_access_witness %I.ref [symbolic = %I.as_wit.loc9_11.2 (constants.%I.as_wit.1)]
// CHECK:STDOUT:     %impl.elem0.loc9_11.1: @AccessGeneric.%T.loc8_18.2 (%T) = interface_witness_access %I.as_wit.loc9_11.1, element0 [symbolic = %impl.elem0.loc9_11.2 (constants.%impl.elem0.1)]
// CHECK:STDOUT:     return %impl.elem0.loc9_11.1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @AccessConcrete(%I.loc12_19.1: %Interface.type.3) {
// CHECK:STDOUT:   %I.loc12_19.2: %Interface.type.3 = bind_symbolic_name I, 0 [symbolic = %I.loc12_19.2 (constants.%I.2)]
// CHECK:STDOUT:   %I.patt.loc12_19.2: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic = %I.patt.loc12_19.2 (constants.%I.patt.2)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %I.as_wit.loc13_11.2: <witness> = facet_access_witness %I.loc12_19.2 [symbolic = %I.as_wit.loc13_11.2 (constants.%I.as_wit.2)]
// CHECK:STDOUT:   %impl.elem0.loc13_11.2: %i32 = interface_witness_access %I.as_wit.loc13_11.2, element0 [symbolic = %impl.elem0.loc13_11.2 (constants.%impl.elem0.2)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn(%I.param_patt: %Interface.type.3) -> %i32 {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %I.ref: %Interface.type.3 = name_ref I, %I.loc12_19.1 [symbolic = %I.loc12_19.2 (constants.%I.2)]
// CHECK:STDOUT:     %.loc13: %assoc_type.2 = specific_constant @Interface.%assoc0.loc5_12.1, @Interface(constants.%i32) [template = constants.%assoc0.2]
// CHECK:STDOUT:     %X.ref: %assoc_type.2 = name_ref X, %.loc13 [template = constants.%assoc0.2]
// CHECK:STDOUT:     %I.as_wit.loc13_11.1: <witness> = facet_access_witness %I.ref [symbolic = %I.as_wit.loc13_11.2 (constants.%I.as_wit.2)]
// CHECK:STDOUT:     %impl.elem0.loc13_11.1: %i32 = interface_witness_access %I.as_wit.loc13_11.1, element0 [symbolic = %impl.elem0.loc13_11.2 (constants.%impl.elem0.2)]
// CHECK:STDOUT:     return %impl.elem0.loc13_11.1
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(constants.%T) {
// CHECK:STDOUT:   %T.loc4_21.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc4_21.2 => constants.%T
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type => constants.%Interface.type.2
// CHECK:STDOUT:   %Self.2 => constants.%Self
// CHECK:STDOUT:   %require_complete => constants.%require_complete.1
// CHECK:STDOUT:   %assoc_type => constants.%assoc_type.1
// CHECK:STDOUT:   %assoc0.loc5_12.2 => constants.%assoc0.1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(%T.loc4_21.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(@AccessGeneric.%T.loc8_18.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @AccessGeneric(constants.%T, constants.%I.1) {
// CHECK:STDOUT:   %T.loc8_18.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc8_18.2 => constants.%T
// CHECK:STDOUT:   %Interface.type.loc8_43.2 => constants.%Interface.type.2
// CHECK:STDOUT:   %I.loc8_28.2 => constants.%I.1
// CHECK:STDOUT:   %I.patt.loc8_28.2 => constants.%I.1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(constants.%i32) {
// CHECK:STDOUT:   %T.loc4_21.2 => constants.%i32
// CHECK:STDOUT:   %T.patt.loc4_21.2 => constants.%i32
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type => constants.%Interface.type.3
// CHECK:STDOUT:   %Self.2 => constants.%Self
// CHECK:STDOUT:   %require_complete => constants.%complete_type.2
// CHECK:STDOUT:   %assoc_type => constants.%assoc_type.2
// CHECK:STDOUT:   %assoc0.loc5_12.2 => constants.%assoc0.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @AccessConcrete(constants.%I.2) {
// CHECK:STDOUT:   %I.loc12_19.2 => constants.%I.2
// CHECK:STDOUT:   %I.patt.loc12_19.2 => constants.%I.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_no_member.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %T: type = bind_symbolic_name T, 0 [symbolic]
// CHECK:STDOUT:   %T.patt: type = symbolic_binding_pattern T, 0 [symbolic]
// CHECK:STDOUT:   %Interface.type.1: type = generic_interface_type @Interface [template]
// CHECK:STDOUT:   %Interface.generic: %Interface.type.1 = struct_value () [template]
// CHECK:STDOUT:   %Interface.type.2: type = facet_type <@Interface, @Interface(%T)> [symbolic]
// CHECK:STDOUT:   %Self: %Interface.type.2 = bind_symbolic_name Self, 1 [symbolic]
// CHECK:STDOUT:   %require_complete.1: <witness> = require_complete_type %T [symbolic]
// CHECK:STDOUT:   %assoc_type.1: type = assoc_entity_type %Interface.type.2, %T [symbolic]
// CHECK:STDOUT:   %assoc0.1: %assoc_type.1 = assoc_entity element0, @Interface.%X [symbolic]
// CHECK:STDOUT:   %I.1: %Interface.type.2 = bind_symbolic_name I, 1 [symbolic]
// CHECK:STDOUT:   %I.patt.1: %Interface.type.2 = symbolic_binding_pattern I, 1 [symbolic]
// CHECK:STDOUT:   %AccessMissingGeneric.type: type = fn_type @AccessMissingGeneric [template]
// CHECK:STDOUT:   %AccessMissingGeneric: %AccessMissingGeneric.type = struct_value () [template]
// CHECK:STDOUT:   %require_complete.2: <witness> = require_complete_type %Interface.type.2 [symbolic]
// CHECK:STDOUT:   %int_32: Core.IntLiteral = int_value 32 [template]
// CHECK:STDOUT:   %i32: type = class_type @Int, @Int(%int_32) [template]
// CHECK:STDOUT:   %Interface.type.3: type = facet_type <@Interface, @Interface(%i32)> [template]
// CHECK:STDOUT:   %I.2: %Interface.type.3 = bind_symbolic_name I, 0 [symbolic]
// CHECK:STDOUT:   %I.patt.2: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic]
// CHECK:STDOUT:   %AccessMissingConcrete.type: type = fn_type @AccessMissingConcrete [template]
// CHECK:STDOUT:   %AccessMissingConcrete: %AccessMissingConcrete.type = struct_value () [template]
// CHECK:STDOUT:   %i32.builtin: type = int_type signed, %int_32 [template]
// CHECK:STDOUT:   %complete_type.2: <witness> = complete_type_witness %i32.builtin [template]
// CHECK:STDOUT:   %assoc_type.2: type = assoc_entity_type %Interface.type.3, %i32 [template]
// CHECK:STDOUT:   %assoc0.2: %assoc_type.2 = assoc_entity element0, @Interface.%X [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Int = %import_ref.1
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .Interface = %Interface.decl
// CHECK:STDOUT:     .AccessMissingGeneric = %AccessMissingGeneric.decl
// CHECK:STDOUT:     .AccessMissingConcrete = %AccessMissingConcrete.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %Interface.decl: %Interface.type.1 = interface_decl @Interface [template = constants.%Interface.generic] {
// CHECK:STDOUT:     %T.patt.loc4_21.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:     %T.param_patt: type = value_param_pattern %T.patt.loc4_21.1, runtime_param<invalid> [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.param: type = value_param runtime_param<invalid>
// CHECK:STDOUT:     %T.loc4_21.1: type = bind_symbolic_name T, 0, %T.param [symbolic = %T.loc4_21.2 (constants.%T)]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %AccessMissingGeneric.decl: %AccessMissingGeneric.type = fn_decl @AccessMissingGeneric [template = constants.%AccessMissingGeneric] {
// CHECK:STDOUT:     %T.patt.loc8_25.1: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc8_25.2 (constants.%T.patt)]
// CHECK:STDOUT:     %T.param_patt: type = value_param_pattern %T.patt.loc8_25.1, runtime_param<invalid> [symbolic = %T.patt.loc8_25.2 (constants.%T.patt)]
// CHECK:STDOUT:     %I.patt.loc8_35.1: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) = symbolic_binding_pattern I, 1 [symbolic = %I.patt.loc8_35.2 (constants.%I.patt.1)]
// CHECK:STDOUT:     %I.param_patt: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) = value_param_pattern %I.patt.loc8_35.1, runtime_param<invalid> [symbolic = %I.patt.loc8_35.2 (constants.%I.patt.1)]
// CHECK:STDOUT:     %return.patt: @AccessMissingGeneric.%T.loc8_25.2 (%T) = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: @AccessMissingGeneric.%T.loc8_25.2 (%T) = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %T.ref.loc8_56: type = name_ref T, %T.loc8_25.1 [symbolic = %T.loc8_25.2 (constants.%T)]
// CHECK:STDOUT:     %T.param: type = value_param runtime_param<invalid>
// CHECK:STDOUT:     %T.loc8_25.1: type = bind_symbolic_name T, 0, %T.param [symbolic = %T.loc8_25.2 (constants.%T)]
// CHECK:STDOUT:     %I.param: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) = value_param runtime_param<invalid>
// CHECK:STDOUT:     %.loc8: type = splice_block %Interface.type.loc8_50.1 [symbolic = %Interface.type.loc8_50.2 (constants.%Interface.type.2)] {
// CHECK:STDOUT:       %Interface.ref: %Interface.type.1 = name_ref Interface, file.%Interface.decl [template = constants.%Interface.generic]
// CHECK:STDOUT:       %T.ref.loc8_49: type = name_ref T, %T.loc8_25.1 [symbolic = %T.loc8_25.2 (constants.%T)]
// CHECK:STDOUT:       %Interface.type.loc8_50.1: type = facet_type <@Interface, @Interface(constants.%T)> [symbolic = %Interface.type.loc8_50.2 (constants.%Interface.type.2)]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %I.loc8_35.1: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) = bind_symbolic_name I, 1, %I.param [symbolic = %I.loc8_35.2 (constants.%I.1)]
// CHECK:STDOUT:     %return.param: ref @AccessMissingGeneric.%T.loc8_25.2 (%T) = out_param runtime_param0
// CHECK:STDOUT:     %return: ref @AccessMissingGeneric.%T.loc8_25.2 (%T) = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %AccessMissingConcrete.decl: %AccessMissingConcrete.type = fn_decl @AccessMissingConcrete [template = constants.%AccessMissingConcrete] {
// CHECK:STDOUT:     %I.patt.loc16_26.1: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic = %I.patt.loc16_26.2 (constants.%I.patt.2)]
// CHECK:STDOUT:     %I.param_patt: %Interface.type.3 = value_param_pattern %I.patt.loc16_26.1, runtime_param<invalid> [symbolic = %I.patt.loc16_26.2 (constants.%I.patt.2)]
// CHECK:STDOUT:     %return.patt: %i32 = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: %i32 = out_param_pattern %return.patt, runtime_param0
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %int_32.loc16_49: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:     %i32.loc16_49: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:     %I.param: %Interface.type.3 = value_param runtime_param<invalid>
// CHECK:STDOUT:     %.loc16: type = splice_block %Interface.type [template = constants.%Interface.type.3] {
// CHECK:STDOUT:       %Interface.ref: %Interface.type.1 = name_ref Interface, file.%Interface.decl [template = constants.%Interface.generic]
// CHECK:STDOUT:       %int_32.loc16_40: Core.IntLiteral = int_value 32 [template = constants.%int_32]
// CHECK:STDOUT:       %i32.loc16_40: type = class_type @Int, @Int(constants.%int_32) [template = constants.%i32]
// CHECK:STDOUT:       %Interface.type: type = facet_type <@Interface, @Interface(constants.%i32)> [template = constants.%Interface.type.3]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %I.loc16_26.1: %Interface.type.3 = bind_symbolic_name I, 0, %I.param [symbolic = %I.loc16_26.2 (constants.%I.2)]
// CHECK:STDOUT:     %return.param: ref %i32 = out_param runtime_param0
// CHECK:STDOUT:     %return: ref %i32 = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic interface @Interface(%T.loc4_21.1: type) {
// CHECK:STDOUT:   %T.loc4_21.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc4_21.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc4_21.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc4_21.2 (constants.%T.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type: type = facet_type <@Interface, @Interface(%T.loc4_21.2)> [symbolic = %Interface.type (constants.%Interface.type.2)]
// CHECK:STDOUT:   %Self.2: %Interface.type.2 = bind_symbolic_name Self, 1 [symbolic = %Self.2 (constants.%Self)]
// CHECK:STDOUT:   %require_complete: <witness> = require_complete_type @Interface.%T.loc4_21.2 (%T) [symbolic = %require_complete (constants.%require_complete.1)]
// CHECK:STDOUT:   %assoc_type: type = assoc_entity_type @Interface.%Interface.type (%Interface.type.2), @Interface.%T.loc4_21.2 (%T) [symbolic = %assoc_type (constants.%assoc_type.1)]
// CHECK:STDOUT:   %assoc0.loc5_12.2: @Interface.%assoc_type (%assoc_type.1) = assoc_entity element0, %X [symbolic = %assoc0.loc5_12.2 (constants.%assoc0.1)]
// CHECK:STDOUT:
// CHECK:STDOUT:   interface {
// CHECK:STDOUT:     %Self.1: @Interface.%Interface.type (%Interface.type.2) = bind_symbolic_name Self, 1 [symbolic = %Self.2 (constants.%Self)]
// CHECK:STDOUT:     %X: @Interface.%T.loc4_21.2 (%T) = assoc_const_decl X [template]
// CHECK:STDOUT:     %assoc0.loc5_12.1: @Interface.%assoc_type (%assoc_type.1) = assoc_entity element0, %X [symbolic = %assoc0.loc5_12.2 (constants.%assoc0.1)]
// CHECK:STDOUT:
// CHECK:STDOUT:   !members:
// CHECK:STDOUT:     .Self = %Self.1
// CHECK:STDOUT:     .X = %assoc0.loc5_12.1
// CHECK:STDOUT:     witness = (%X)
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @AccessMissingGeneric(%T.loc8_25.1: type, %I.loc8_35.1: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2)) {
// CHECK:STDOUT:   %T.loc8_25.2: type = bind_symbolic_name T, 0 [symbolic = %T.loc8_25.2 (constants.%T)]
// CHECK:STDOUT:   %T.patt.loc8_25.2: type = symbolic_binding_pattern T, 0 [symbolic = %T.patt.loc8_25.2 (constants.%T.patt)]
// CHECK:STDOUT:   %Interface.type.loc8_50.2: type = facet_type <@Interface, @Interface(%T.loc8_25.2)> [symbolic = %Interface.type.loc8_50.2 (constants.%Interface.type.2)]
// CHECK:STDOUT:   %I.loc8_35.2: %Interface.type.2 = bind_symbolic_name I, 1 [symbolic = %I.loc8_35.2 (constants.%I.1)]
// CHECK:STDOUT:   %I.patt.loc8_35.2: %Interface.type.2 = symbolic_binding_pattern I, 1 [symbolic = %I.patt.loc8_35.2 (constants.%I.patt.1)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %require_complete: <witness> = require_complete_type @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) [symbolic = %require_complete (constants.%require_complete.2)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn[%T.param_patt: type](%I.param_patt: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2)) -> @AccessMissingGeneric.%T.loc8_25.2 (%T) {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %I.ref: @AccessMissingGeneric.%Interface.type.loc8_50.2 (%Interface.type.2) = name_ref I, %I.loc8_35.1 [symbolic = %I.loc8_35.2 (constants.%I.1)]
// CHECK:STDOUT:     %nonesuch.ref: <error> = name_ref nonesuch, <error> [template = <error>]
// CHECK:STDOUT:     return <error>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @AccessMissingConcrete(%I.loc16_26.1: %Interface.type.3) {
// CHECK:STDOUT:   %I.loc16_26.2: %Interface.type.3 = bind_symbolic_name I, 0 [symbolic = %I.loc16_26.2 (constants.%I.2)]
// CHECK:STDOUT:   %I.patt.loc16_26.2: %Interface.type.3 = symbolic_binding_pattern I, 0 [symbolic = %I.patt.loc16_26.2 (constants.%I.patt.2)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   fn(%I.param_patt: %Interface.type.3) -> %i32 {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %I.ref: %Interface.type.3 = name_ref I, %I.loc16_26.1 [symbolic = %I.loc16_26.2 (constants.%I.2)]
// CHECK:STDOUT:     %nonesuch.ref: <error> = name_ref nonesuch, <error> [template = <error>]
// CHECK:STDOUT:     return <error>
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(constants.%T) {
// CHECK:STDOUT:   %T.loc4_21.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc4_21.2 => constants.%T
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type => constants.%Interface.type.2
// CHECK:STDOUT:   %Self.2 => constants.%Self
// CHECK:STDOUT:   %require_complete => constants.%require_complete.1
// CHECK:STDOUT:   %assoc_type => constants.%assoc_type.1
// CHECK:STDOUT:   %assoc0.loc5_12.2 => constants.%assoc0.1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(%T.loc4_21.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(@AccessMissingGeneric.%T.loc8_25.2) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @AccessMissingGeneric(constants.%T, constants.%I.1) {
// CHECK:STDOUT:   %T.loc8_25.2 => constants.%T
// CHECK:STDOUT:   %T.patt.loc8_25.2 => constants.%T
// CHECK:STDOUT:   %Interface.type.loc8_50.2 => constants.%Interface.type.2
// CHECK:STDOUT:   %I.loc8_35.2 => constants.%I.1
// CHECK:STDOUT:   %I.patt.loc8_35.2 => constants.%I.1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @Interface(constants.%i32) {
// CHECK:STDOUT:   %T.loc4_21.2 => constants.%i32
// CHECK:STDOUT:   %T.patt.loc4_21.2 => constants.%i32
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %Interface.type => constants.%Interface.type.3
// CHECK:STDOUT:   %Self.2 => constants.%Self
// CHECK:STDOUT:   %require_complete => constants.%complete_type.2
// CHECK:STDOUT:   %assoc_type => constants.%assoc_type.2
// CHECK:STDOUT:   %assoc0.loc5_12.2 => constants.%assoc0.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @AccessMissingConcrete(constants.%I.2) {
// CHECK:STDOUT:   %I.loc16_26.2 => constants.%I.2
// CHECK:STDOUT:   %I.patt.loc16_26.2 => constants.%I.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
