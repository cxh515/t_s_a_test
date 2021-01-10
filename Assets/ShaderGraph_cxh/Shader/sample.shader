//"Example"  Shader的分类  "Tint Final Color" Shader名称
Shader "Custom/Diffuse Texture1"
{
	//定义着色器的属性,在这里定义的属性将被作为输入提供给所有的子着色器
	Properties{
		//在Inspector面板中可以调整的变量定义格式
		/*_Name("Display Name", type) = defaultValue[{options}]
		_Name - 属性的名字，简单说就是变量名，在之后整个Shader代码中将使用这个名字来获取该属性的内容
		Display Name - 这个字符串将显示在Unity的材质编辑器中作为Shader的使用者可读的内容
		type - 这个属性的类型，可能的type所表示的内容有以下几种：
		Color - 一种颜色，由RGBA（红绿蓝和透明度）四个量来定义；
		2D - 一张2的阶数大小（256，512之类）的贴图。这张贴图将在采样后被转为对应基于模型UV的每个像素的颜色，最终被显示出来；
		Rect - 一个非2阶数大小的贴图；
		Cube - 即Cube map texture（立方体纹理），简单说就是6张有联系的2D贴图的组合，主要用来做反射效果（比如天空盒和动态反射），也会被转换为对应点的采样；
		Range(min, max) - 一个介于最小值和最大值之间的浮点数，一般用来当作调整Shader某些特性的参数（比如透明度渲染的截止值可以是从0至1的值等）；
		Float - 任意一个浮点数；
		Vector - 一个四维数；

		defaultValue 定义了这个属性的默认值，通过输入一个符合格式的默认值来指定对应属性的初始值
			（某些效果可能需要某些特定的参数值来达到需要的效果，虽然这些值可以在之后在进行调整，
			但是如果默认就指定为想要的值的话就省去了一个个调整的时间，方便很多）。
		Color - 以0～1定义的rgba颜色，比如(1,1,1,1)；
		2D/Rect/Cube - 对于贴图来说，默认值可以为一个代表默认tint颜色的字符串，可以是空字符串或者"white","black","gray","bump"中的一个
		Float，Range - 某个指定的浮点数
		Vector - 一个4维数，写为 (x,y,z,w)
		另外还有一个{option}，它只对2D，Rect或者Cube贴图有关，在写输入时我们最少要在贴图之后写一对什么都不含的空白的{}，当我们需要打
			开特定选项时可以把其写在这对花括号内。如果需要同时打开多个选项，可以使用空白分隔。可能的选择有ObjectLinear, EyeLinear, SphereMap,
			CubeReflect, CubeNormal中的一个，这些都是OpenGL中TexGen的模式

		各种类型的属性定义:
		_MainColor ("Main Color",Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainRect ("Main Rect",Rect) = "black" {}
		_MainCube ("Main Cube",Cube) = "gray" {}
		_MainRange ("Main Range",Range(0.0,1.0)) = 0.5
		_MainFloat ("Main Float",Float) = 0.314
		_MainVector ("Main Vector",Vector) = (0.1,0.2,0.3,0.4)
		*/


		_MainTex("Base (RGB)", 2D) = "white" {}
	}
		//一个Shader中可以包含任意多个SubShader,但是只有一个SubShader被显卡选中并最终执行
		//如果我们写的SubShader最后都没有被选中的话, 这时候就会默认去执行FallBack后面跟着那个Shader了.
		SubShader{
		//是告诉渲染设备,这个使用这个Shader的材质是一个不透明的物体
		//Tags { "RenderType" = "Opaque" }
		/*
		Tag 里面可以类似 "RenderType" = "XXX"
		或者 "Quene" = "XXX"（指定渲染顺序队列）
		或者 "ForceNoShadowCasting"="True"（从不产生阴影）
		预定义的Queue有：
		Background - 最早被调用的渲染，用来渲染天空盒或者背景
		Geometry - 这是默认值，用来渲染非透明物体（普通情况下，场景中的绝大多数物体应该是非透明的）
		AlphaTest - 用来渲染经过Alpha Test的像素，单独为AlphaTest设定一个Queue是出于对效率的考虑
		Transparent - 以从后往前的顺序渲染透明物体
		Overlay - 用来渲染叠加的效果，是渲染的最后阶段（比如镜头光晕等特效）
		这些预定义的值本质上是一组定义整数，Background = 1000， Geometry = 2000,
		AlphaTest = 2450， Transparent = 3000，最后Overlay = 4000。在我们实际设置Queue值时，
		不仅能使用上面的几个预定义值，我们也可以指定自己的Queue值，写成类似
		这样："Queue"="Transparent+100"，表示一个在Transparent之后100的Queue上进行调用。
		通过调整Queue值，我们可以确保某些物体一定在另一些物体之前或者之后渲染，这个技巧有时候很有用处

		{"RenderType" = “Transparent”}，意味着我们的shader只会输出半透明或透明的像素值

		*/

		//Level of Detail
		LOD 200
		/*
		VertexLit及其系列 = 100
		Decal, Reflective VertexLit = 150
		Diffuse = 200
		Diffuse Detail, Reflective Bumped Unlit, Reflective Bumped VertexLit = 250
		Bumped, Specular = 300
		Bumped Specular = 400
		Parallax = 500
		Parallax Specular = 600
		*/


		//这是一个开始标记，表明从这里开始是一段CG程序
		CGPROGRAM

		//它声明了我们要写一个表面Shader，并指定了光照模型
		#pragma surface surf Lambert
		/*
		#pragma surface surfaceFunction lightModel [optionalparams]

		surface - 声明的是一个表面着色器
		surfaceFunction - 着色器代码的方法的名字
		lightModel - 使用的光照模型
		*/

		//重新定义一个在Properties中定义的变量,名字必须要保持一致
		sampler2D _MainTex;

	//我们自定义的Input结构体,需要计算的数据需要放到这个结构体中

	struct Input {
		//在CG程序中，我们有这样的约定，在一个贴图变量（在我们例子中是_MainTex）之前加上uv两个字母，
		//就代表提取它的uv值,（其实就是两个代表贴图上点的二维坐标 ）


		//提取_MainTex 这张贴图的uv值
		float2 uv_MainTex;
	};

	//CG规定了声明为表面着色器的方法（就是我们这里的surf）这个方法的参数是固定的 不可以随便更改
	//（表面函数）每个像素调用一次
	//Input其实是需要我们去定义的结构,SurfaceOutput是已经定义好了里面类型输出结构
	//struct SurfaceOutput {  
	//	half3 Albedo;     //像素的颜色
	//	half3 Normal;     //像素的法向值
	//	half3 Emission;   //像素的发散颜色
	//	half Specular;    //像素的镜面高光
	//	half Gloss;       //像素的发光强度
	//	half Alpha;       //像素的透明度
	//};

	//着色器函数
	void surf(Input IN, inout SurfaceOutput o) {

		//tex2d函数，这是CG程序中用来在一张贴图中对一个点进行采样的方法，
		//返回一个float4。这里对_MainTex在输入点上进行了采样，并将其颜色
		//的rbg值赋予了输出的像素颜色，将a值赋予透明度。
		//于是，着色器就明白了应当怎样工作：


		//即找到贴图上对应的uv点，直接使用颜色信息来进行着色
		half4 c = tex2D(_MainTex, IN.uv_MainTex);
		//输出结构体中的 像素的颜色 这个字段 我们将其赋值为 _MainTex  UV采样后的rgb值
		o.Albedo = c.rgb;
		//输出结构体中的 像素的透明度 这个字段 我们将其赋值为 _MainTex  UV采样后的a值
		o.Alpha = c.a;

	}

	//ENDCG与CGPROGRAM是对应的，表明CG程序到此结束
	ENDCG
	}

		//如果这个shader在当前环境中运行失败后，会默认调用Unity自带的Diffuse Shader
		FallBack "Diffuse"
}
