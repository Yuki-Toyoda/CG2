#include "Object3d.hlsli"
// CPU‚©‚ç‘—‚é’l‚Ì\‘¢‘Ì‚ğ—pˆÓ
struct Material {
	float32_t4 color;
	int32_t enableLighting;
};
ConstantBuffer <Material> gMaterial : register(b0);

struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);
PixelShaderOutput main(VertexShaderOutput input) {
	PixelShaderOutput output;

	float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);
	output.color = gMaterial.color* textureColor;
	return output;
}

//float4 main() : SV_TARGET
//{
//	return float4(1.0f, 1.0f, 1.0f, 1.0f);
//}