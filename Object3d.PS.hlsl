#include "Object3d.hlsli"
// CPU���瑗��l�̍\���̂�p��
struct Material {
	float32_t4 color;
	int32_t enableLighting;
};
ConstantBuffer <Material> gMaterial : register(b0);

struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

/// <summary>
/// ���s�����\����
/// </summary>
struct DirectionalLight {
	float32_t4 color; // ���C�g�̐F
	float32_t3 direction; // ���C�g�̌���
	float intensity; // ���C�g���x
};
// ���s�����p��ConstantBuffer��p�ӂ���
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);

Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);
PixelShaderOutput main(VertexShaderOutput input) {
	PixelShaderOutput output;

	float32_t4 textureColor = gTexture.Sample(gSampler, input.texcoord);

	if (gMaterial.enableLighting != 0) { // ���C�e�B���O���s���ꍇ
		//float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
		// HalfLambert
		float NdotL = dot(normalize(input.normal), -normalize(gDirectionalLight.direction));
		float cos = pow(NdotL * 0.5f + 0.5f, 2.0f);
		output.color = gMaterial.color * textureColor * gDirectionalLight.color * cos * gDirectionalLight.intensity;
	}
	else { // ���C�e�B���O���s��Ȃ��ꍇ�͑O��܂łƓ������Z���s��
		output.color = gMaterial.color * textureColor;
	}

	return output;
}

//float4 main() : SV_TARGET
//{
//	return float4(1.0f, 1.0f, 1.0f, 1.0f);
//}