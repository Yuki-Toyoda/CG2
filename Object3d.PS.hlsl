// CPU���瑗��l�̍\���̂�p��
struct Material {
	float32_t4 color;
};
ConstantBuffer <Material> gMaterial : register(b0);

struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

PixelShaderOutput main() {
	PixelShaderOutput output;
	output.color = gMaterial.color;
	return output;
}

//float4 main() : SV_TARGET
//{
//	return float4(1.0f, 1.0f, 1.0f, 1.0f);
//}