#include "Object3d.hlsli"
// CPUから送る値の構造体を用意
struct Material {
	float32_t4 color;
	int32_t enableLighting;
};
ConstantBuffer <Material> gMaterial : register(b0);

struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

/// <summary>
/// 平行光源構造体
/// </summary>
struct DirectionalLight {
	float32_t4 color; // ライトの色
	float32_t3 direction; // ライトの向き
	float intensity; // ライト光度
};
// 平行光源用のConstantBufferを用意する
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);

Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);
PixelShaderOutput main(VertexShaderOutput input) {
	PixelShaderOutput output;

	float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);

	if (gMaterial.enableLighting != 0) { // ライティングを行う場合
		//float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
		// HalfLambert
		float NdotL = dot(normalize(input.normal), -normalize(gDirectionalLight.direction));
		float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
		output.color = gMaterial.color * textureColor * gDirectionalLight.color * cos * gDirectionalLight.intensity;
	}
	else { // ライティングを行わない場合は前回までと同じ演算を行う
		output.color = gMaterial.color * textureColor;
	}

	return output;
}

//float4 main() : SV_TARGET
//{
//	return float4(1.0f, 1.0f, 1.0f, 1.0f);
//}