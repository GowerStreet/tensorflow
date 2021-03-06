// RUN: flatbuffer_translate -mlir-to-tflite-flatbuffer %s -o - | flatbuffer_to_string - | FileCheck --dump-input-on-failure %s

func @main(tensor<3x!quant.uniform<i8:f32, 1.0>>) -> tensor<3x!quant.uniform<i8:f32, 1.0>> {
^bb0(%arg0: tensor<3x!quant.uniform<i8:f32, 1.0>>):
  // CHECK:      {
  // CHECK-NEXT:  version: 3,
  // CHECK-NEXT:  operator_codes: [ {
  // CHECK-NEXT:    builtin_code: MUL,
  // CHECK-NEXT:    version: 3
  // CHECK-NEXT:  } ],
  // CHECK-NEXT:  subgraphs: [ {
  // CHECK-NEXT:    tensors: [ {
  // CHECK-NEXT:      shape: [ 3 ],
  // CHECK-NEXT:      type: INT8,
  // CHECK-NEXT:      buffer: 1,
  // CHECK-NEXT:      name: "Input",
  // CHECK-NEXT:      quantization: {
  // CHECK-NEXT:        scale: [ 1.0 ],
  // CHECK-NEXT:        zero_point: [ 0 ]
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }, {
  // CHECK-NEXT:      shape: [ 3 ],
  // CHECK-NEXT:      type: INT8,
  // CHECK-NEXT:      buffer: 2,
  // CHECK-NEXT:      name: "tfl.pseudo_qconst",
  // CHECK-NEXT:      quantization: {
  // CHECK-NEXT:        scale: [ 1.0 ],
  // CHECK-NEXT:        zero_point: [ 0 ]
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }, {
  // CHECK-NEXT:      shape: [ 3 ],
  // CHECK-NEXT:      type: INT8,
  // CHECK-NEXT:      buffer: 3,
  // CHECK-NEXT:      name: "mul",
  // CHECK-NEXT:      quantization: {
  // CHECK-NEXT:        scale: [ 1.0 ],
  // CHECK-NEXT:        zero_point: [ 0 ]
  // CHECK-NEXT:      }
  // CHECK-NEXT:    } ],
  // CHECK-NEXT:    inputs: [ 0 ],
  // CHECK-NEXT:    outputs: [ 2 ],
  // CHECK-NEXT:    operators: [ {
  // CHECK-NEXT:      inputs: [ 0, 1 ],
  // CHECK-NEXT:      outputs: [ 2 ],
  // CHECK-NEXT:      builtin_options_type: MulOptions,
  // CHECK-NEXT:      builtin_options: {
  // CHECK-EMPTY:
  // CHECK-NEXT:      }
  // CHECK-NEXT:    } ],
  // CHECK-NEXT:    name: "main"
  // CHECK-NEXT:  } ],
  // CHECK-NEXT:  description: "MLIR Converted.",
  // CHECK-NEXT:  buffers: [ {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-NEXT:    data: [ 2, 2, 2 ]
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  } ]
  // CHECK-NEXT:}

  %0 = "tfl.pseudo_input" (%arg0)  : (tensor<3x!quant.uniform<i8:f32, 1.0>>) ->tensor<3x!quant.uniform<i8:f32, 1.0>> loc("Input")
  %1 = "tfl.pseudo_qconst"() { qtype = tensor<3x!quant.uniform<i8:f32, 1.0>>, value = dense<2> : tensor<3xi8>} : () -> tensor<3x!quant.uniform<i8:f32, 1.0>>
  %2 = "tfl.mul"(%0, %1) {fused_activation_function = "NONE"} : (tensor<3x!quant.uniform<i8:f32, 1.0>>, tensor<3x!quant.uniform<i8:f32, 1.0>>) -> tensor<3x!quant.uniform<i8:f32, 1.0>> loc("mul")
  return %2 : tensor<3x!quant.uniform<i8:f32, 1.0>>
}
