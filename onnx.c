#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <onnxruntime_c_api.h>

const OrtApi* g_ort = NULL;

int main() {
    // Initialize ONNX Runtime
    g_ort = OrtGetApiBase()->GetApi(ORT_API_VERSION);
    if (!g_ort) {
        printf("Failed to init ONNX Runtime engine.\n");
        return -1;
    }

    // Create environment
    OrtEnv* env;
    OrtStatus* status = g_ort->CreateEnv(ORT_LOGGING_LEVEL_WARNING, "mnist_model", &env);
    if (status != NULL) {
        printf("Failed to create environment: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        return -1;
    }

    // Create session options
    OrtSessionOptions* session_options;
    status = g_ort->CreateSessionOptions(&session_options);
    if (status != NULL) {
        printf("Failed to create session options: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        g_ort->ReleaseEnv(env);
        return -1;
    }

    // Set session options (optional)
    g_ort->SetIntraOpNumThreads(session_options, 1);
    g_ort->SetSessionGraphOptimizationLevel(session_options, ORT_ENABLE_BASIC);

    // Load the ONNX model
    const char* model_path = "models/mnist_model.onnx";
    OrtSession* session;
    
#ifdef _WIN32
    // Convert to wide string for Windows
    wchar_t wide_model_path[256];
    mbstowcs(wide_model_path, model_path, strlen(model_path) + 1);
    status = g_ort->CreateSession(env, wide_model_path, session_options, &session);
#else
    status = g_ort->CreateSession(env, model_path, session_options, &session);
#endif

    if (status != NULL) {
        printf("Failed to load model: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        g_ort->ReleaseSessionOptions(session_options);
        g_ort->ReleaseEnv(env);
        return -1;
    }

    printf("Successfully loaded MNIST ONNX model from: %s\n", model_path);

    // Get model information
    OrtAllocator* allocator;
    status = g_ort->GetAllocatorWithDefaultOptions(&allocator);
    if (status != NULL) {
        printf("Failed to get allocator: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        goto cleanup;
    }

    // Get input count
    size_t num_input_nodes;
    status = g_ort->SessionGetInputCount(session, &num_input_nodes);
    if (status != NULL) {
        printf("Failed to get input count: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        goto cleanup;
    }
    printf("Number of model inputs: %zu\n", num_input_nodes);

    // Get output count
    size_t num_output_nodes;
    status = g_ort->SessionGetOutputCount(session, &num_output_nodes);
    if (status != NULL) {
        printf("Failed to get output count: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        goto cleanup;
    }
    printf("Number of model outputs: %zu\n", num_output_nodes);

    // Get input name
    char* input_name;
    status = g_ort->SessionGetInputName(session, 0, allocator, &input_name);
    if (status != NULL) {
        printf("Failed to get input name: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        goto cleanup;
    }
    printf("Input name: %s\n", input_name);

    // Get output name
    char* output_name;
    status = g_ort->SessionGetOutputName(session, 0, allocator, &output_name);
    if (status != NULL) {
        printf("Failed to get output name: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        allocator->Free(allocator, input_name);
        goto cleanup;
    }
    printf("Output name: %s\n", output_name);

    // Get input type info
    OrtTypeInfo* input_type_info;
    status = g_ort->SessionGetInputTypeInfo(session, 0, &input_type_info);
    if (status != NULL) {
        printf("Failed to get input type info: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    const OrtTensorTypeAndShapeInfo* input_tensor_info;
    status = g_ort->CastTypeInfoToTensorInfo(input_type_info, &input_tensor_info);
    if (status != NULL) {
        printf("Failed to cast input type info: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    // Get input dimensions
    size_t input_dims_count;
    status = g_ort->GetDimensionsCount(input_tensor_info, &input_dims_count);
    if (status != NULL) {
        printf("Failed to get dimensions count: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    int64_t* input_dims = (int64_t*)malloc(input_dims_count * sizeof(int64_t));
    status = g_ort->GetDimensions(input_tensor_info, input_dims, input_dims_count);
    if (status != NULL) {
        printf("Failed to get dimensions: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        free(input_dims);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    printf("Input dimensions: [");
    for (size_t i = 0; i < input_dims_count; i++) {
        printf("%ld", input_dims[i]);
        if (i < input_dims_count - 1) printf(", ");
    }
    printf("]\n");

    // Handle dynamic dimensions (replace -1 with actual batch size)
    for (size_t i = 0; i < input_dims_count; i++) {
        if (input_dims[i] == -1) {
            input_dims[i] = 1; // Set batch size to 1
            printf("Set dynamic dimension %zu to 1\n", i);
        }
    }

    // Calculate input tensor size
    size_t input_tensor_size = 1;
    for (size_t i = 0; i < input_dims_count; i++) {
        input_tensor_size *= input_dims[i];
    }
    printf("Input tensor size: %zu elements\n", input_tensor_size);

    // Create dummy input data (random values between 0 and 1)
    float* input_data = (float*)malloc(input_tensor_size * sizeof(float));
    if (!input_data) {
        printf("Failed to allocate memory for input data\n");
        free(input_dims);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }
    
    // Initialize with dummy data (simple pattern for MNIST-like input)
    srand(42); // Set seed for reproducible results
    for (size_t i = 0; i < input_tensor_size; i++) {
        input_data[i] = (float)rand() / RAND_MAX; // Random values between 0 and 1
    }
    printf("Created dummy input data (random values between 0-1)\n");

    // Create input tensor
    OrtMemoryInfo* memory_info;
    status = g_ort->CreateCpuMemoryInfo(OrtArenaAllocator, OrtMemTypeDefault, &memory_info);
    if (status != NULL) {
        printf("Failed to create memory info: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        free(input_data);
        free(input_dims);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    OrtValue* input_tensor;
    status = g_ort->CreateTensorWithDataAsOrtValue(
        memory_info, input_data, input_tensor_size * sizeof(float),
        input_dims, input_dims_count, ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT, &input_tensor);
    if (status != NULL) {
        printf("Failed to create input tensor: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
        g_ort->ReleaseMemoryInfo(memory_info);
        free(input_data);
        free(input_dims);
        g_ort->ReleaseTypeInfo(input_type_info);
        allocator->Free(allocator, input_name);
        allocator->Free(allocator, output_name);
        goto cleanup;
    }

    // Prepare input and output arrays
    const char* input_names[] = {input_name};
    const char* output_names[] = {output_name};
    OrtValue* input_tensors[] = {input_tensor};
    OrtValue* output_tensors[] = {NULL};

    printf("Running inference...\n");
    
    // Run inference
    status = g_ort->Run(session, NULL, input_names, 
                       (const OrtValue* const*)input_tensors, 1,
                       output_names, 1, output_tensors);
    if (status != NULL) {
        printf("Failed to run inference: %s\n", g_ort->GetErrorMessage(status));
        g_ort->ReleaseStatus(status);
    } else {
        printf("Inference completed successfully!\n");
        
        // Get output data
        float* output_data;
        status = g_ort->GetTensorMutableData(output_tensors[0], (void**)&output_data);
        if (status == NULL) {
            // Get output tensor info
            OrtTensorTypeAndShapeInfo* output_tensor_info;
            status = g_ort->GetTensorTypeAndShape(output_tensors[0], &output_tensor_info);
            if (status == NULL) {
                size_t output_dims_count;
                g_ort->GetDimensionsCount(output_tensor_info, &output_dims_count);
                
                int64_t* output_dims = (int64_t*)malloc(output_dims_count * sizeof(int64_t));
                g_ort->GetDimensions(output_tensor_info, output_dims, output_dims_count);
                
                size_t output_size = 1;
                for (size_t i = 0; i < output_dims_count; i++) {
                    output_size *= output_dims[i];
                }
                
                printf("Output tensor shape: [");
                for (size_t i = 0; i < output_dims_count; i++) {
                    printf("%ld", output_dims[i]);
                    if (i < output_dims_count - 1) printf(", ");
                }
                printf("]\n");
                
                printf("Output values (first 10): ");
                for (size_t i = 0; i < (output_size < 10 ? output_size : 10); i++) {
                    printf("%.4f ", output_data[i]);
                }
                printf("\n");
                
                free(output_dims);
                g_ort->ReleaseTensorTypeAndShapeInfo(output_tensor_info);
            }
        }
        
        // Release output tensor
        if (output_tensors[0]) {
            g_ort->ReleaseValue(output_tensors[0]);
        }
    }

    // Clean up inference resources
    g_ort->ReleaseValue(input_tensor);
    g_ort->ReleaseMemoryInfo(memory_info);
    free(input_data);
    free(input_dims);
    g_ort->ReleaseTypeInfo(input_type_info);
    allocator->Free(allocator, input_name);
    allocator->Free(allocator, output_name);

cleanup:
    // Release resources
    g_ort->ReleaseSession(session);
    g_ort->ReleaseSessionOptions(session_options);
    g_ort->ReleaseEnv(env);

    printf("Model loading and inspection completed successfully!\n");
    return 0;
}