using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FullScreen : MonoBehaviour
{

    public Material _mat;
    public RenderTexture _rtNull;//初始什么都没有
    public RenderTexture _rt0;//上一帧图形
    public RenderTexture _rt1;//本帧图形
    [Range(2, 100)]
    public int _TexelNumber;//设定网格的数量

    private void Start()
    {
        Graphics.Blit(_rtNull, _rt0);
        Application.targetFrameRate = 30;
        _TexelNumber = 8;
    }
    private void Update()
    {
        _mat.SetInt("_TexelNumber", _TexelNumber);
        _mat.SetTexture("_MainTex", _rt0);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(_rt0, _rt1, _mat);//将上一帧的图像经过迭代计算后放到这一帧的图像上
        Graphics.Blit(_rt1, destination);//将这一帧图像输出的屏幕上
        Graphics.Blit(_rt1, _rt0);//将一帧图像变为上一帧图像
    }
}
